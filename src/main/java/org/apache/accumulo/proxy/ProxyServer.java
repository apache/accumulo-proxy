/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.accumulo.proxy;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import org.apache.accumulo.core.client.Accumulo;
import org.apache.accumulo.core.client.AccumuloClient;
import org.apache.accumulo.core.client.AccumuloException;
import org.apache.accumulo.core.client.AccumuloSecurityException;
import org.apache.accumulo.core.client.BatchScanner;
import org.apache.accumulo.core.client.BatchWriter;
import org.apache.accumulo.core.client.BatchWriterConfig;
import org.apache.accumulo.core.client.ConditionalWriter;
import org.apache.accumulo.core.client.ConditionalWriter.Result;
import org.apache.accumulo.core.client.ConditionalWriterConfig;
import org.apache.accumulo.core.client.IteratorSetting;
import org.apache.accumulo.core.client.MutationsRejectedException;
import org.apache.accumulo.core.client.NamespaceExistsException;
import org.apache.accumulo.core.client.NamespaceNotEmptyException;
import org.apache.accumulo.core.client.NamespaceNotFoundException;
import org.apache.accumulo.core.client.Scanner;
import org.apache.accumulo.core.client.ScannerBase;
import org.apache.accumulo.core.client.TableExistsException;
import org.apache.accumulo.core.client.TableNotFoundException;
import org.apache.accumulo.core.client.admin.ActiveCompaction;
import org.apache.accumulo.core.client.admin.ActiveScan;
import org.apache.accumulo.core.client.admin.CompactionConfig;
import org.apache.accumulo.core.client.admin.NewTableConfiguration;
import org.apache.accumulo.core.client.admin.TimeType;
import org.apache.accumulo.core.client.security.SecurityErrorCode;
import org.apache.accumulo.core.client.security.tokens.AuthenticationToken;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import org.apache.accumulo.core.clientImpl.Namespace;
import org.apache.accumulo.core.clientImpl.thrift.TableOperationExceptionType;
import org.apache.accumulo.core.clientImpl.thrift.ThriftTableOperationException;
import org.apache.accumulo.core.data.Column;
import org.apache.accumulo.core.data.ConditionalMutation;
import org.apache.accumulo.core.data.Key;
import org.apache.accumulo.core.data.Mutation;
import org.apache.accumulo.core.data.PartialKey;
import org.apache.accumulo.core.data.Range;
import org.apache.accumulo.core.data.TabletId;
import org.apache.accumulo.core.data.Value;
import org.apache.accumulo.core.iterators.IteratorUtil.IteratorScope;
import org.apache.accumulo.core.security.Authorizations;
import org.apache.accumulo.core.security.ColumnVisibility;
import org.apache.accumulo.core.security.NamespacePermission;
import org.apache.accumulo.core.security.SystemPermission;
import org.apache.accumulo.core.security.TablePermission;
import org.apache.accumulo.core.util.ByteBufferUtil;
import org.apache.accumulo.core.util.TextUtil;
import org.apache.accumulo.proxy.thrift.AccumuloProxy;
import org.apache.accumulo.proxy.thrift.BatchScanOptions;
import org.apache.accumulo.proxy.thrift.ColumnUpdate;
import org.apache.accumulo.proxy.thrift.CompactionReason;
import org.apache.accumulo.proxy.thrift.CompactionType;
import org.apache.accumulo.proxy.thrift.Condition;
import org.apache.accumulo.proxy.thrift.ConditionalStatus;
import org.apache.accumulo.proxy.thrift.ConditionalUpdates;
import org.apache.accumulo.proxy.thrift.ConditionalWriterOptions;
import org.apache.accumulo.proxy.thrift.DiskUsage;
import org.apache.accumulo.proxy.thrift.Durability;
import org.apache.accumulo.proxy.thrift.KeyValue;
import org.apache.accumulo.proxy.thrift.KeyValueAndPeek;
import org.apache.accumulo.proxy.thrift.NoMoreEntriesException;
import org.apache.accumulo.proxy.thrift.ScanColumn;
import org.apache.accumulo.proxy.thrift.ScanOptions;
import org.apache.accumulo.proxy.thrift.ScanResult;
import org.apache.accumulo.proxy.thrift.ScanState;
import org.apache.accumulo.proxy.thrift.ScanType;
import org.apache.accumulo.proxy.thrift.UnknownScanner;
import org.apache.accumulo.proxy.thrift.UnknownWriter;
import org.apache.accumulo.proxy.thrift.WriterOptions;
import org.apache.accumulo.server.rpc.ThriftServerType;
import org.apache.hadoop.io.Text;
import org.apache.thrift.TException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.RemovalListener;
import com.google.common.cache.RemovalNotification;

/**
 * Proxy Server exposing the Accumulo API via Thrift..
 *
 * @since 1.5
 */
public class ProxyServer implements AccumuloProxy.Iface {

  public static final Logger logger = LoggerFactory.getLogger(ProxyServer.class);
  public static final String RPC_ACCUMULO_PRINCIPAL_MISMATCH_MSG =
      "RPC principal did not match requested Accumulo principal";

  protected AccumuloClient client;

  private final String sharedSecret;

  protected Class<? extends AuthenticationToken> tokenClass;

  protected static class ScannerPlusIterator {
    public ScannerBase scanner;
    public Iterator<Map.Entry<Key,Value>> iterator;
  }

  protected static class BatchWriterPlusProblem {
    public BatchWriter writer;
    public MutationsRejectedException exception = null;
  }

  static class CloseWriter implements RemovalListener<UUID,BatchWriterPlusProblem> {
    @Override
    public void onRemoval(RemovalNotification<UUID,BatchWriterPlusProblem> notification) {
      try {
        BatchWriterPlusProblem value = notification.getValue();
        if (value.exception != null) {
          throw value.exception;
        }
        notification.getValue().writer.close();
      } catch (MutationsRejectedException e) {
        logger.warn("MutationsRejectedException", e);
      }
    }

    public CloseWriter() {}
  }

  static class CloseScanner implements RemovalListener<UUID,ScannerPlusIterator> {
    @Override
    public void onRemoval(RemovalNotification<UUID,ScannerPlusIterator> notification) {
      final ScannerBase base = notification.getValue().scanner;
      if (base instanceof BatchScanner) {
        final BatchScanner scanner = (BatchScanner) base;
        scanner.close();
      }
    }

    public CloseScanner() {}
  }

  public static class CloseConditionalWriter implements RemovalListener<UUID,ConditionalWriter> {
    @Override
    public void onRemoval(RemovalNotification<UUID,ConditionalWriter> notification) {
      notification.getValue().close();
    }
  }

  protected Cache<UUID,ScannerPlusIterator> scannerCache;
  protected Cache<UUID,BatchWriterPlusProblem> writerCache;
  protected Cache<UUID,ConditionalWriter> conditionalWriterCache;

  @SuppressWarnings("unused")
  private final ThriftServerType serverType;

  public ProxyServer(Properties props) {

    client = Accumulo.newClient().from(props).build();

    try {
      String tokenProp = props.getProperty("tokenClass", PasswordToken.class.getName());
      tokenClass = Class.forName(tokenProp).asSubclass(AuthenticationToken.class);
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }

    final String serverTypeStr =
        props.getProperty(Proxy.THRIFT_SERVER_TYPE, Proxy.THRIFT_SERVER_TYPE_DEFAULT);
    ThriftServerType tempServerType = Proxy.DEFAULT_SERVER_TYPE;
    if (!Proxy.THRIFT_SERVER_TYPE_DEFAULT.equals(serverTypeStr)) {
      tempServerType = ThriftServerType.get(serverTypeStr);
    }

    sharedSecret = props.getProperty("sharedSecret");
    if (sharedSecret == null) {
      throw new RuntimeException("The properties do not contain sharedSecret");
    }

    serverType = tempServerType;

    scannerCache = CacheBuilder.newBuilder().expireAfterAccess(10, TimeUnit.MINUTES)
        .maximumSize(1000).removalListener(new CloseScanner()).build();

    writerCache = CacheBuilder.newBuilder().expireAfterAccess(10, TimeUnit.MINUTES)
        .maximumSize(1000).removalListener(new CloseWriter()).build();

    conditionalWriterCache = CacheBuilder.newBuilder().expireAfterAccess(10, TimeUnit.MINUTES)
        .maximumSize(1000).removalListener(new CloseConditionalWriter()).build();
  }

  protected AccumuloClient getClient(String sharedSecret) throws Exception {
    if (sharedSecret.equals(this.sharedSecret)) {
      return client;
    } else {
      throw new org.apache.accumulo.core.client.AccumuloSecurityException(
          "Incorrect shared secret provided",
          org.apache.accumulo.core.clientImpl.thrift.SecurityErrorCode.PERMISSION_DENIED);
    }
  }

  private void handleAccumuloException(AccumuloException e)
      throws org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.AccumuloException {
    if (e.getCause() instanceof ThriftTableOperationException) {
      ThriftTableOperationException ttoe = (ThriftTableOperationException) e.getCause();
      if (ttoe.type == TableOperationExceptionType.NOTFOUND) {
        throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(e.toString());
      }
    }
    throw new org.apache.accumulo.proxy.thrift.AccumuloException(e.toString());
  }

  private void handleAccumuloSecurityException(AccumuloSecurityException e)
      throws org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException {
    if (e.getSecurityErrorCode().equals(SecurityErrorCode.TABLE_DOESNT_EXIST)) {
      throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(e.toString());
    }
    throw new org.apache.accumulo.proxy.thrift.AccumuloSecurityException(e.toString());
  }

  private void handleExceptionTNF(Exception ex)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      throw ex;
    } catch (AccumuloException e) {
      Throwable cause = e.getCause();
      if (cause != null && TableNotFoundException.class.equals(cause.getClass())) {
        throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(cause.toString());
      }
      handleAccumuloException(e);
    } catch (AccumuloSecurityException e) {
      handleAccumuloSecurityException(e);
    } catch (TableNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(ex.toString());
    } catch (Exception e) {
      throw new org.apache.accumulo.proxy.thrift.AccumuloException(e.toString());
    }
  }

  private void handleExceptionTEE(Exception ex)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.TableExistsException, TException {
    try {
      throw ex;
    } catch (AccumuloException e) {
      handleAccumuloException(e);
    } catch (AccumuloSecurityException e) {
      handleAccumuloSecurityException(e);
    } catch (TableNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(ex.toString());
    } catch (TableExistsException e) {
      throw new org.apache.accumulo.proxy.thrift.TableExistsException(e.toString());
    } catch (Exception e) {
      throw new org.apache.accumulo.proxy.thrift.AccumuloException(e.toString());
    }
  }

  private void handleExceptionMRE(Exception ex)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.MutationsRejectedException, TException {
    try {
      throw ex;
    } catch (MutationsRejectedException e) {
      throw new org.apache.accumulo.proxy.thrift.MutationsRejectedException(ex.toString());
    } catch (AccumuloException e) {
      handleAccumuloException(e);
    } catch (AccumuloSecurityException e) {
      handleAccumuloSecurityException(e);
    } catch (TableNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(ex.toString());
    } catch (Exception e) {
      throw new org.apache.accumulo.proxy.thrift.AccumuloException(e.toString());
    }
  }

  private void handleExceptionNNF(Exception ex)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      throw ex;
    } catch (AccumuloException e) {
      Throwable cause = e.getCause();
      if (cause != null && NamespaceNotFoundException.class.equals(cause.getClass())) {
        throw new org.apache.accumulo.proxy.thrift.NamespaceNotFoundException(cause.toString());
      }
      handleAccumuloException(e);
    } catch (AccumuloSecurityException e) {
      handleAccumuloSecurityException(e);
    } catch (NamespaceNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.NamespaceNotFoundException(ex.toString());
    } catch (Exception e) {
      throw new org.apache.accumulo.proxy.thrift.AccumuloException(e.toString());
    }
  }

  private void handleException(Exception ex)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      throw ex;
    } catch (AccumuloSecurityException e) {
      throw new org.apache.accumulo.proxy.thrift.AccumuloSecurityException(e.toString());
    } catch (Exception e) {
      throw new org.apache.accumulo.proxy.thrift.AccumuloException(e.toString());
    }
  }

  @Override
  public int addConstraint(String sharedSecret, String tableName, String constraintClassName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {

    try {
      return getClient(sharedSecret).tableOperations().addConstraint(tableName,
          constraintClassName);
    } catch (Exception e) {
      handleExceptionTNF(e);
      return -1;
    }
  }

  @Override
  public void addSplits(String sharedSecret, String tableName, Set<ByteBuffer> splits)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {

    try {
      SortedSet<Text> sorted = new TreeSet<>();
      for (ByteBuffer split : splits) {
        sorted.add(ByteBufferUtil.toText(split));
      }
      getClient(sharedSecret).tableOperations().addSplits(tableName, sorted);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void clearLocatorCache(String sharedSecret, String tableName)
      throws org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().clearLocatorCache(tableName);
    } catch (TableNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.TableNotFoundException(e.toString());
    } catch (Exception e) {
      throw new TException(e.toString());
    }
  }

  @Override
  public void compactTable(String sharedSecret, String tableName, ByteBuffer startRow,
      ByteBuffer endRow, List<org.apache.accumulo.proxy.thrift.IteratorSetting> iterators,
      boolean flush, boolean wait, org.apache.accumulo.proxy.thrift.PluginConfig selectorConfig,
      org.apache.accumulo.proxy.thrift.PluginConfig configurerConfig)
      throws org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.AccumuloException, TException {
    try {
      CompactionConfig compactionConfig = new CompactionConfig()
          .setStartRow(ByteBufferUtil.toText(startRow)).setEndRow(ByteBufferUtil.toText(endRow))
          .setIterators(getIteratorSettings(iterators)).setFlush(flush).setWait(wait);

      if (selectorConfig != null) {
        Map<String,String> options =
            selectorConfig.options == null ? Map.of() : selectorConfig.options;

        org.apache.accumulo.core.client.admin.PluginConfig spc =
            new org.apache.accumulo.core.client.admin.PluginConfig(selectorConfig.getClassName(),
                options);

        compactionConfig.setSelector(spc);
      }

      if (configurerConfig != null) {
        Map<String,String> options =
            configurerConfig.options == null ? Map.of() : configurerConfig.options;

        org.apache.accumulo.core.client.admin.PluginConfig cpc =
            new org.apache.accumulo.core.client.admin.PluginConfig(configurerConfig.getClassName(),
                options);

        compactionConfig.setConfigurer(cpc);
      }

      getClient(sharedSecret).tableOperations().compact(tableName, compactionConfig);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void cancelCompaction(String sharedSecret, String tableName)
      throws org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.AccumuloException, TException {

    try {
      getClient(sharedSecret).tableOperations().cancelCompaction(tableName);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  private List<IteratorSetting>
      getIteratorSettings(List<org.apache.accumulo.proxy.thrift.IteratorSetting> iterators) {

    if (iterators == null) {
      return List.of();
    }

    return iterators.stream().map(this::getIteratorSetting).collect(Collectors.toList());
  }

  @Override
  public void createTable(String sharedSecret, String tableName, boolean versioningIter,
      org.apache.accumulo.proxy.thrift.TimeType type)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableExistsException, TException {
    try {
      if (type == null) {
        type = org.apache.accumulo.proxy.thrift.TimeType.MILLIS;
      }

      NewTableConfiguration tConfig =
          new NewTableConfiguration().setTimeType(TimeType.valueOf(type.toString()));
      if (!versioningIter) {
        tConfig = tConfig.withoutDefaultIterators();
      }
      getClient(sharedSecret).tableOperations().create(tableName, tConfig);
    } catch (TableExistsException e) {
      throw new org.apache.accumulo.proxy.thrift.TableExistsException(e.toString());
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void deleteTable(String sharedSecret, String tableName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().delete(tableName);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void deleteRows(String sharedSecret, String tableName, ByteBuffer startRow,
      ByteBuffer endRow) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().deleteRows(tableName,
          ByteBufferUtil.toText(startRow), ByteBufferUtil.toText(endRow));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public boolean tableExists(String sharedSecret, String tableName) throws TException {
    try {
      return getClient(sharedSecret).tableOperations().exists(tableName);
    } catch (Exception e) {
      throw new TException(e);
    }
  }

  @Override
  public void flushTable(String sharedSecret, String tableName, ByteBuffer startRow,
      ByteBuffer endRow, boolean wait) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().flush(tableName, ByteBufferUtil.toText(startRow),
          ByteBufferUtil.toText(endRow), wait);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public Map<String,Set<String>> getLocalityGroups(String sharedSecret, String tableName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      Map<String,Set<Text>> groups =
          getClient(sharedSecret).tableOperations().getLocalityGroups(tableName);
      Map<String,Set<String>> ret = new HashMap<>();
      for (Entry<String,Set<Text>> entry : groups.entrySet()) {
        Set<String> value = new HashSet<>();
        ret.put(entry.getKey(), value);
        for (Text val : entry.getValue()) {
          value.add(val.toString());
        }
      }
      return ret;
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public ByteBuffer getMaxRow(String sharedSecret, String tableName, Set<ByteBuffer> auths,
      ByteBuffer startRow, boolean startInclusive, ByteBuffer endRow, boolean endInclusive)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      AccumuloClient accumuloClient = getClient(sharedSecret);
      Text startText = ByteBufferUtil.toText(startRow);
      Text endText = ByteBufferUtil.toText(endRow);
      Authorizations auth;
      if (auths != null) {
        auth = getAuthorizations(auths);
      } else {
        auth = accumuloClient.securityOperations().getUserAuthorizations(accumuloClient.whoami());
      }
      Text max = accumuloClient.tableOperations().getMaxRow(tableName, auth, startText,
          startInclusive, endText, endInclusive);
      return TextUtil.getByteBuffer(max);
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public Map<String,String> getTableProperties(String sharedSecret, String tableName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      Map<String,String> ret = new HashMap<>();

      for (Map.Entry<String,String> entry : getClient(sharedSecret).tableOperations()
          .getProperties(tableName)) {
        ret.put(entry.getKey(), entry.getValue());
      }
      return ret;
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public List<ByteBuffer> listSplits(String sharedSecret, String tableName, int maxSplits)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      Collection<Text> splits =
          getClient(sharedSecret).tableOperations().listSplits(tableName, maxSplits);

      return splits.stream().map(TextUtil::getByteBuffer).collect(Collectors.toList());
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public Set<String> listTables(String sharedSecret) throws TException {
    try {
      return getClient(sharedSecret).tableOperations().list();
    } catch (Exception e) {
      throw new TException(e);
    }
  }

  @Override
  public Map<String,Integer> listConstraints(String sharedSecret, String tableName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {

    try {
      return getClient(sharedSecret).tableOperations().listConstraints(tableName);
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public void mergeTablets(String sharedSecret, String tableName, ByteBuffer startRow,
      ByteBuffer endRow) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().merge(tableName, ByteBufferUtil.toText(startRow),
          ByteBufferUtil.toText(endRow));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void offlineTable(String sharedSecret, String tableName, boolean wait)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().offline(tableName, wait);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void onlineTable(String sharedSecret, String tableName, boolean wait)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().online(tableName, wait);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void removeConstraint(String sharedSecret, String tableName, int constraint)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {

    try {
      getClient(sharedSecret).tableOperations().removeConstraint(tableName, constraint);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void removeTableProperty(String sharedSecret, String tableName, String property)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().removeProperty(tableName, property);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void renameTable(String sharedSecret, String oldTableName, String newTableName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.TableExistsException, TException {
    try {
      getClient(sharedSecret).tableOperations().rename(oldTableName, newTableName);
    } catch (Exception e) {
      handleExceptionTEE(e);
    }
  }

  @Override
  public void setLocalityGroups(String sharedSecret, String tableName,
      Map<String,Set<String>> groupStrings)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      Map<String,Set<Text>> groups = new HashMap<>();
      for (Entry<String,Set<String>> groupEntry : groupStrings.entrySet()) {
        groups.put(groupEntry.getKey(), new HashSet<>());
        for (String val : groupEntry.getValue()) {
          groups.get(groupEntry.getKey()).add(new Text(val));
        }
      }
      getClient(sharedSecret).tableOperations().setLocalityGroups(tableName, groups);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void setTableProperty(String sharedSecret, String tableName, String property, String value)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().setProperty(tableName, property, value);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public Map<String,String> tableIdMap(String sharedSecret) throws TException {
    try {
      return getClient(sharedSecret).tableOperations().tableIdMap();
    } catch (Exception e) {
      throw new TException(e);
    }
  }

  @Override
  public List<DiskUsage> getDiskUsage(String sharedSecret, Set<String> tables)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      List<org.apache.accumulo.core.client.admin.DiskUsage> diskUsages =
          getClient(sharedSecret).tableOperations().getDiskUsage(tables);
      List<DiskUsage> retUsages = new ArrayList<>();
      for (org.apache.accumulo.core.client.admin.DiskUsage diskUsage : diskUsages) {
        DiskUsage usage = new DiskUsage();
        usage.setTables(new ArrayList<>(diskUsage.getTables()));
        usage.setUsage(diskUsage.getUsage());
        retUsages.add(usage);
      }
      return retUsages;
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public Map<String,String> getSiteConfiguration(String sharedSecret)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).instanceOperations().getSiteConfiguration();
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public Map<String,String> getSystemConfiguration(String sharedSecret)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).instanceOperations().getSystemConfiguration();
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public List<String> getTabletServers(String sharedSecret) throws TException {
    try {
      return getClient(sharedSecret).instanceOperations().getTabletServers();
    } catch (Exception e) {
      throw new TException(e);
    }
  }

  @Override
  public List<org.apache.accumulo.proxy.thrift.ActiveScan> getActiveScans(String sharedSecret,
      String tserver) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    List<org.apache.accumulo.proxy.thrift.ActiveScan> result = new ArrayList<>();
    try {
      List<ActiveScan> activeScans =
          getClient(sharedSecret).instanceOperations().getActiveScans(tserver);
      for (ActiveScan scan : activeScans) {
        org.apache.accumulo.proxy.thrift.ActiveScan pscan =
            new org.apache.accumulo.proxy.thrift.ActiveScan();
        pscan.client = scan.getClient();
        pscan.user = scan.getUser();
        pscan.table = scan.getTable();
        pscan.age = scan.getAge();
        pscan.idleTime = scan.getIdleTime();
        pscan.type = ScanType.valueOf(scan.getType().toString());
        pscan.state = ScanState.valueOf(scan.getState().toString());
        TabletId e = scan.getTablet();
        pscan.extent = new org.apache.accumulo.proxy.thrift.KeyExtent(e.getTable().toString(),
            TextUtil.getByteBuffer(e.getEndRow()), TextUtil.getByteBuffer(e.getPrevEndRow()));
        pscan.columns = new ArrayList<>();
        if (scan.getColumns() != null) {
          for (Column c : scan.getColumns()) {
            org.apache.accumulo.proxy.thrift.Column column =
                new org.apache.accumulo.proxy.thrift.Column();
            column.setColFamily(c.getColumnFamily());
            column.setColQualifier(c.getColumnQualifier());
            column.setColVisibility(c.getColumnVisibility());
            pscan.columns.add(column);
          }
        }
        pscan.iterators = new ArrayList<>();
        for (String iteratorString : scan.getSsiList()) {
          String[] parts = iteratorString.split("[=,]");
          if (parts.length == 3) {
            String name = parts[0];
            int priority = Integer.parseInt(parts[1]);
            String classname = parts[2];
            org.apache.accumulo.proxy.thrift.IteratorSetting settings =
                new org.apache.accumulo.proxy.thrift.IteratorSetting(priority, name, classname,
                    scan.getSsio().get(name));
            pscan.iterators.add(settings);
          }
        }
        pscan.authorizations = new ArrayList<>();
        if (scan.getAuthorizations() != null) {
          for (byte[] a : scan.getAuthorizations()) {
            pscan.authorizations.add(ByteBuffer.wrap(a));
          }
        }
        result.add(pscan);
      }
      return result;
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public List<org.apache.accumulo.proxy.thrift.ActiveCompaction>
      getActiveCompactions(String sharedSecret, String tserver)
          throws org.apache.accumulo.proxy.thrift.AccumuloException,
          org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {

    try {
      List<org.apache.accumulo.proxy.thrift.ActiveCompaction> result = new ArrayList<>();
      List<ActiveCompaction> active =
          getClient(sharedSecret).instanceOperations().getActiveCompactions(tserver);
      for (ActiveCompaction comp : active) {
        org.apache.accumulo.proxy.thrift.ActiveCompaction pcomp =
            new org.apache.accumulo.proxy.thrift.ActiveCompaction();
        pcomp.age = comp.getAge();
        pcomp.entriesRead = comp.getEntriesRead();
        pcomp.entriesWritten = comp.getEntriesWritten();
        TabletId e = comp.getTablet();
        pcomp.extent = new org.apache.accumulo.proxy.thrift.KeyExtent(e.getTable().toString(),
            TextUtil.getByteBuffer(e.getEndRow()), TextUtil.getByteBuffer(e.getPrevEndRow()));
        pcomp.inputFiles = new ArrayList<>();
        if (comp.getInputFiles() != null) {
          pcomp.inputFiles.addAll(comp.getInputFiles());
        }
        pcomp.localityGroup = comp.getLocalityGroup();
        pcomp.outputFile = comp.getOutputFile();
        pcomp.reason = CompactionReason.valueOf(comp.getReason().toString());
        pcomp.type = CompactionType.valueOf(comp.getType().toString());

        pcomp.iterators = new ArrayList<>();
        if (comp.getIterators() != null) {
          for (IteratorSetting setting : comp.getIterators()) {
            org.apache.accumulo.proxy.thrift.IteratorSetting psetting =
                new org.apache.accumulo.proxy.thrift.IteratorSetting(setting.getPriority(),
                    setting.getName(), setting.getIteratorClass(), setting.getOptions());
            pcomp.iterators.add(psetting);
          }
        }
        result.add(pcomp);
      }
      return result;
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public void removeProperty(String sharedSecret, String property)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).instanceOperations().removeProperty(property);
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void setProperty(String sharedSecret, String property, String value)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).instanceOperations().setProperty(property, value);
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public boolean testClassLoad(String sharedSecret, String className, String asTypeName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).instanceOperations().testClassLoad(className, asTypeName);
    } catch (Exception e) {
      handleException(e);
      return false;
    }
  }

  @Override
  public boolean authenticateUser(String sharedSecret, String user, Map<String,String> properties)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).securityOperations().authenticateUser(user,
          getToken(user, properties));
    } catch (Exception e) {
      handleException(e);
      return false;
    }
  }

  @Override
  public void changeUserAuthorizations(String sharedSecret, String user,
      Set<ByteBuffer> authorizations) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      String[] auths =
          authorizations.stream().distinct().map(ByteBufferUtil::toString).toArray(String[]::new);

      getClient(sharedSecret).securityOperations().changeUserAuthorizations(user,
          new Authorizations(auths));
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void changeLocalUserPassword(String sharedSecret, String user, ByteBuffer password)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().changeLocalUserPassword(user,
          new PasswordToken(password));
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void createLocalUser(String sharedSecret, String user, ByteBuffer password)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().createLocalUser(user,
          new PasswordToken(password));
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void dropLocalUser(String sharedSecret, String user)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().dropLocalUser(user);
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public List<ByteBuffer> getUserAuthorizations(String sharedSecret, String user)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).securityOperations().getUserAuthorizations(user)
          .getAuthorizationsBB();
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public void grantSystemPermission(String sharedSecret, String user,
      org.apache.accumulo.proxy.thrift.SystemPermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().grantSystemPermission(user,
          SystemPermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void grantTablePermission(String sharedSecret, String user, String table,
      org.apache.accumulo.proxy.thrift.TablePermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).securityOperations().grantTablePermission(user, table,
          TablePermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public boolean hasSystemPermission(String sharedSecret, String user,
      org.apache.accumulo.proxy.thrift.SystemPermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).securityOperations().hasSystemPermission(user,
          SystemPermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleException(e);
      return false;
    }
  }

  @Override
  public boolean hasTablePermission(String sharedSecret, String user, String table,
      org.apache.accumulo.proxy.thrift.TablePermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      return getClient(sharedSecret).securityOperations().hasTablePermission(user, table,
          TablePermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleExceptionTNF(e);
      return false;
    }
  }

  @Override
  public Set<String> listLocalUsers(String sharedSecret)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).securityOperations().listLocalUsers();
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public void revokeSystemPermission(String sharedSecret, String user,
      org.apache.accumulo.proxy.thrift.SystemPermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().revokeSystemPermission(user,
          SystemPermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void revokeTablePermission(String sharedSecret, String user, String table,
      org.apache.accumulo.proxy.thrift.TablePermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).securityOperations().revokeTablePermission(user, table,
          TablePermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void grantNamespacePermission(String sharedSecret, String user, String namespaceName,
      org.apache.accumulo.proxy.thrift.NamespacePermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().grantNamespacePermission(user, namespaceName,
          NamespacePermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public boolean hasNamespacePermission(String sharedSecret, String user, String namespaceName,
      org.apache.accumulo.proxy.thrift.NamespacePermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).securityOperations().hasNamespacePermission(user,
          namespaceName, NamespacePermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleException(e);
      return false;
    }
  }

  @Override
  public void revokeNamespacePermission(String sharedSecret, String user, String namespaceName,
      org.apache.accumulo.proxy.thrift.NamespacePermission perm)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).securityOperations().revokeNamespacePermission(user, namespaceName,
          NamespacePermission.getPermissionById((byte) perm.getValue()));
    } catch (Exception e) {
      handleException(e);
    }
  }

  private Authorizations getAuthorizations(Set<ByteBuffer> authorizations) {
    String[] auths = authorizations.stream().map(ByteBufferUtil::toString).toArray(String[]::new);

    return new Authorizations(auths);
  }

  @Override
  public String createScanner(String sharedSecret, String tableName, ScanOptions opts)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      AccumuloClient accumuloClient = getClient(sharedSecret);

      Authorizations auth;
      if (opts != null && opts.isSetAuthorizations()) {
        auth = getAuthorizations(opts.authorizations);
      } else {
        auth = accumuloClient.securityOperations().getUserAuthorizations(accumuloClient.whoami());
      }
      Scanner scanner = accumuloClient.createScanner(tableName, auth);

      if (opts != null) {
        if (opts.iterators != null) {
          for (org.apache.accumulo.proxy.thrift.IteratorSetting iter : opts.iterators) {
            IteratorSetting is = new IteratorSetting(iter.getPriority(), iter.getName(),
                iter.getIteratorClass(), iter.getProperties());
            scanner.addScanIterator(is);
          }
        }
        org.apache.accumulo.proxy.thrift.Range prange = opts.range;
        if (prange != null) {
          Range range = new Range(Util.fromThrift(prange.getStart()), prange.startInclusive,
              Util.fromThrift(prange.getStop()), prange.stopInclusive);
          scanner.setRange(range);
        }
        if (opts.columns != null) {
          for (ScanColumn col : opts.columns) {
            if (col.isSetColQualifier()) {
              scanner.fetchColumn(ByteBufferUtil.toText(col.colFamily),
                  ByteBufferUtil.toText(col.colQualifier));
            } else {
              scanner.fetchColumnFamily(ByteBufferUtil.toText(col.colFamily));
            }
          }
        }
      }

      UUID uuid = UUID.randomUUID();

      ScannerPlusIterator spi = new ScannerPlusIterator();
      spi.scanner = scanner;
      spi.iterator = scanner.iterator();
      scannerCache.put(uuid, spi);
      return uuid.toString();
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public String createBatchScanner(String sharedSecret, String tableName, BatchScanOptions opts)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      AccumuloClient accumuloClient = getClient(sharedSecret);

      int threads = 10;
      Authorizations auth;
      if (opts != null && opts.isSetAuthorizations()) {
        auth = getAuthorizations(opts.authorizations);
      } else {
        auth = accumuloClient.securityOperations().getUserAuthorizations(accumuloClient.whoami());
      }
      if (opts != null && opts.threads > 0) {
        threads = opts.threads;
      }

      BatchScanner scanner = accumuloClient.createBatchScanner(tableName, auth, threads);

      if (opts != null) {
        if (opts.iterators != null) {
          for (org.apache.accumulo.proxy.thrift.IteratorSetting iter : opts.iterators) {
            IteratorSetting is = new IteratorSetting(iter.getPriority(), iter.getName(),
                iter.getIteratorClass(), iter.getProperties());
            scanner.addScanIterator(is);
          }
        }

        ArrayList<Range> ranges = new ArrayList<>();

        if (opts.ranges == null) {
          ranges.add(new Range());
        } else {
          for (org.apache.accumulo.proxy.thrift.Range range : opts.ranges) {
            Range aRange =
                new Range(range.getStart() == null ? null : Util.fromThrift(range.getStart()), true,
                    range.getStop() == null ? null : Util.fromThrift(range.getStop()), false);
            ranges.add(aRange);
          }
        }
        scanner.setRanges(ranges);

        if (opts.columns != null) {
          for (ScanColumn col : opts.columns) {
            if (col.isSetColQualifier()) {
              scanner.fetchColumn(ByteBufferUtil.toText(col.colFamily),
                  ByteBufferUtil.toText(col.colQualifier));
            } else {
              scanner.fetchColumnFamily(ByteBufferUtil.toText(col.colFamily));
            }
          }
        }
      }

      UUID uuid = UUID.randomUUID();

      ScannerPlusIterator spi = new ScannerPlusIterator();
      spi.scanner = scanner;
      spi.iterator = scanner.iterator();
      scannerCache.put(uuid, spi);
      return uuid.toString();
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  private ScannerPlusIterator getScanner(String scanner) throws UnknownScanner {

    UUID uuid = null;
    try {
      uuid = UUID.fromString(scanner);
    } catch (IllegalArgumentException e) {
      throw new UnknownScanner(e.getMessage());
    }

    ScannerPlusIterator spi = scannerCache.getIfPresent(uuid);
    if (spi == null) {
      throw new UnknownScanner("Scanner never existed or no longer exists");
    }
    return spi;
  }

  @Override
  public boolean hasNext(String scanner) throws UnknownScanner, TException {
    ScannerPlusIterator spi = getScanner(scanner);

    return (spi.iterator.hasNext());
  }

  @Override
  public KeyValueAndPeek nextEntry(String scanner) throws NoMoreEntriesException, UnknownScanner,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {

    ScanResult scanResult = nextK(scanner, 1);
    if (scanResult.results.size() > 0) {
      return new KeyValueAndPeek(scanResult.results.get(0), scanResult.isMore());
    } else {
      throw new NoMoreEntriesException();
    }
  }

  @Override
  public ScanResult nextK(String scanner, int k) throws NoMoreEntriesException, UnknownScanner,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {

    // fetch the scanner
    ScannerPlusIterator spi = getScanner(scanner);
    Iterator<Map.Entry<Key,Value>> batchScanner = spi.iterator;
    // synchronized to prevent race conditions
    synchronized (batchScanner) {
      ScanResult ret = new ScanResult();
      ret.setResults(new ArrayList<>());
      int numRead = 0;
      try {
        while (batchScanner.hasNext() && numRead < k) {
          Map.Entry<Key,Value> next = batchScanner.next();
          ret.addToResults(
              new KeyValue(Util.toThrift(next.getKey()), ByteBuffer.wrap(next.getValue().get())));
          numRead++;
        }
        ret.setMore(numRead == k);
      } catch (Exception ex) {
        closeScanner(scanner);
        throw new org.apache.accumulo.proxy.thrift.AccumuloSecurityException(ex.toString());
      }
      return ret;
    }
  }

  @Override
  public void closeScanner(String scanner) throws UnknownScanner, TException {
    UUID uuid = null;
    try {
      uuid = UUID.fromString(scanner);
    } catch (IllegalArgumentException e) {
      throw new UnknownScanner(e.getMessage());
    }

    try {
      if (scannerCache.asMap().remove(uuid) == null) {
        throw new UnknownScanner("Scanner never existed or no longer exists");
      }
    } catch (UnknownScanner e) {
      throw e;
    } catch (Exception e) {
      throw new TException(e.toString());
    }
  }

  @Override
  public void updateAndFlush(String sharedSecret, String tableName,
      Map<ByteBuffer,List<ColumnUpdate>> cells)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.MutationsRejectedException, TException {
    BatchWriterPlusProblem bwpe = null;
    try {
      bwpe = getWriter(sharedSecret, tableName, null);
      addCellsToWriter(cells, bwpe);
      if (bwpe.exception != null) {
        throw bwpe.exception;
      }
      bwpe.writer.flush();
    } catch (Exception e) {
      handleExceptionMRE(e);
    } finally {
      if (bwpe != null) {
        try {
          bwpe.writer.close();
        } catch (MutationsRejectedException e) {
          handleExceptionMRE(e);
        }
      }
    }
  }

  private static final ColumnVisibility EMPTY_VIS = new ColumnVisibility();

  void addCellsToWriter(Map<ByteBuffer,List<ColumnUpdate>> cells, BatchWriterPlusProblem bwpe) {
    if (bwpe.exception != null) {
      return;
    }

    HashMap<Text,ColumnVisibility> vizMap = new HashMap<>();

    for (Map.Entry<ByteBuffer,List<ColumnUpdate>> entry : cells.entrySet()) {
      Mutation m = new Mutation(ByteBufferUtil.toBytes(entry.getKey()));
      addUpdatesToMutation(vizMap, m, entry.getValue());
      try {
        bwpe.writer.addMutation(m);
      } catch (MutationsRejectedException mre) {
        bwpe.exception = mre;
      }
    }
  }

  private void addUpdatesToMutation(HashMap<Text,ColumnVisibility> vizMap, Mutation m,
      List<ColumnUpdate> cu) {
    for (ColumnUpdate update : cu) {
      ColumnVisibility viz = EMPTY_VIS;
      if (update.isSetColVisibility()) {
        viz = getCahcedCV(vizMap, update.getColVisibility());
      }
      byte[] value = new byte[0];
      if (update.isSetValue()) {
        value = update.getValue();
      }
      if (update.isSetTimestamp()) {
        if (update.isSetDeleteCell() && update.isDeleteCell()) {
          m.putDelete(update.getColFamily(), update.getColQualifier(), viz, update.getTimestamp());
        } else {
          m.put(update.getColFamily(), update.getColQualifier(), viz, update.getTimestamp(), value);
        }
      } else {
        if (update.isSetDeleteCell() && update.isDeleteCell()) {
          m.putDelete(new Text(update.getColFamily()), new Text(update.getColQualifier()), viz);
        } else {
          m.put(new Text(update.getColFamily()), new Text(update.getColQualifier()), viz,
              new Value(value));
        }
      }
    }
  }

  private static ColumnVisibility getCahcedCV(HashMap<Text,ColumnVisibility> vizMap, byte[] cv) {
    ColumnVisibility viz;
    Text vizText = new Text(cv);
    viz = vizMap.get(vizText);
    if (viz == null) {
      vizMap.put(vizText, viz = new ColumnVisibility(vizText));
    }
    return viz;
  }

  @Override
  public String createWriter(String sharedSecret, String tableName, WriterOptions opts)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      BatchWriterPlusProblem writer = getWriter(sharedSecret, tableName, opts);
      UUID uuid = UUID.randomUUID();
      writerCache.put(uuid, writer);
      return uuid.toString();
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public void update(String writer, Map<ByteBuffer,List<ColumnUpdate>> cells) throws TException {
    try {
      BatchWriterPlusProblem bwpe = getWriter(writer);
      addCellsToWriter(cells, bwpe);
    } catch (UnknownWriter e) {
      // just drop it, this is a oneway thrift call and throwing a TException seems to make all
      // subsequent thrift calls fail
    }
  }

  @Override
  public void flush(String writer) throws UnknownWriter,
      org.apache.accumulo.proxy.thrift.MutationsRejectedException, TException {
    try {
      BatchWriterPlusProblem bwpe = getWriter(writer);
      if (bwpe.exception != null) {
        throw bwpe.exception;
      }
      bwpe.writer.flush();
    } catch (MutationsRejectedException e) {
      throw new org.apache.accumulo.proxy.thrift.MutationsRejectedException(e.toString());
    } catch (UnknownWriter uw) {
      throw uw;
    } catch (Exception e) {
      throw new TException(e);
    }
  }

  @Override
  public void closeWriter(String writer) throws UnknownWriter,
      org.apache.accumulo.proxy.thrift.MutationsRejectedException, TException {
    try {
      BatchWriterPlusProblem bwpe = getWriter(writer);
      if (bwpe.exception != null) {
        throw bwpe.exception;
      }
      bwpe.writer.close();
      writerCache.invalidate(UUID.fromString(writer));
    } catch (UnknownWriter uw) {
      throw uw;
    } catch (MutationsRejectedException e) {
      throw new org.apache.accumulo.proxy.thrift.MutationsRejectedException(e.toString());
    } catch (Exception e) {
      throw new TException(e);
    }
  }

  private BatchWriterPlusProblem getWriter(String writer) throws UnknownWriter {
    UUID uuid = null;
    try {
      uuid = UUID.fromString(writer);
    } catch (IllegalArgumentException iae) {
      throw new UnknownWriter(iae.getMessage());
    }

    BatchWriterPlusProblem bwpe = writerCache.getIfPresent(uuid);
    if (bwpe == null) {
      throw new UnknownWriter("Writer never existed or no longer exists");
    }
    return bwpe;
  }

  BatchWriterPlusProblem getWriter(String sharedSecret, String tableName, WriterOptions opts)
      throws Exception {
    BatchWriterConfig cfg = new BatchWriterConfig();
    if (opts != null) {
      if (opts.maxMemory != 0) {
        cfg.setMaxMemory(opts.maxMemory);
      }
      if (opts.threads != 0) {
        cfg.setMaxWriteThreads(opts.threads);
      }
      if (opts.timeoutMs != 0) {
        cfg.setTimeout(opts.timeoutMs, TimeUnit.MILLISECONDS);
      }
      if (opts.latencyMs != 0) {
        cfg.setMaxLatency(opts.latencyMs, TimeUnit.MILLISECONDS);
      }
      if (opts.isSetDurability() && opts.durability != null) {
        cfg.setDurability(getDurability(opts.getDurability()));
      }
    }
    BatchWriterPlusProblem result = new BatchWriterPlusProblem();
    result.writer = getClient(sharedSecret).createBatchWriter(tableName, cfg);
    return result;
  }

  private org.apache.accumulo.core.client.Durability getDurability(Durability durability) {
    switch (durability) {
      case DEFAULT:
        return org.apache.accumulo.core.client.Durability.DEFAULT;
      case FLUSH:
        return org.apache.accumulo.core.client.Durability.FLUSH;
      case LOG:
        return org.apache.accumulo.core.client.Durability.LOG;
      case NONE:
        return org.apache.accumulo.core.client.Durability.NONE;
      case SYNC:
        return org.apache.accumulo.core.client.Durability.SYNC;
    }
    throw new IllegalArgumentException("Invalid durability value: " + durability.ordinal());
  }

  private IteratorSetting
      getIteratorSetting(org.apache.accumulo.proxy.thrift.IteratorSetting setting) {
    return new IteratorSetting(setting.priority, setting.name, setting.iteratorClass,
        setting.getProperties());
  }

  private IteratorScope getIteratorScope(org.apache.accumulo.proxy.thrift.IteratorScope scope) {
    return IteratorScope.valueOf(scope.toString().toLowerCase());
  }

  private EnumSet<IteratorScope>
      getIteratorScopes(Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes) {
    EnumSet<IteratorScope> scopes_ = EnumSet.noneOf(IteratorScope.class);
    for (org.apache.accumulo.proxy.thrift.IteratorScope scope : scopes) {
      scopes_.add(getIteratorScope(scope));
    }
    return scopes_;
  }

  private EnumSet<org.apache.accumulo.proxy.thrift.IteratorScope>
      getProxyIteratorScopes(Set<IteratorScope> scopes) {
    EnumSet<org.apache.accumulo.proxy.thrift.IteratorScope> scopes_ =
        EnumSet.noneOf(org.apache.accumulo.proxy.thrift.IteratorScope.class);
    for (IteratorScope scope : scopes) {
      scopes_.add(
          org.apache.accumulo.proxy.thrift.IteratorScope.valueOf(scope.toString().toUpperCase()));
    }
    return scopes_;
  }

  @Override
  public void attachIterator(String sharedSecret, String tableName,
      org.apache.accumulo.proxy.thrift.IteratorSetting setting,
      Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes)
      throws org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().attachIterator(tableName,
          getIteratorSetting(setting), getIteratorScopes(scopes));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void checkIteratorConflicts(String sharedSecret, String tableName,
      org.apache.accumulo.proxy.thrift.IteratorSetting setting,
      Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().checkIteratorConflicts(tableName,
          getIteratorSetting(setting), getIteratorScopes(scopes));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void cloneTable(String sharedSecret, String tableName, String newTableName, boolean flush,
      Map<String,String> propertiesToSet, Set<String> propertiesToExclude)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.TableExistsException, TException {
    try {
      propertiesToExclude = propertiesToExclude == null ? new HashSet<>() : propertiesToExclude;
      propertiesToSet = propertiesToSet == null ? new HashMap<>() : propertiesToSet;

      getClient(sharedSecret).tableOperations().clone(tableName, newTableName, flush,
          propertiesToSet, propertiesToExclude);
    } catch (Exception e) {
      handleExceptionTEE(e);
    }
  }

  @Override
  public void exportTable(String sharedSecret, String tableName, String exportDir)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {

    try {
      getClient(sharedSecret).tableOperations().exportTable(tableName, exportDir);
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public void importTable(String sharedSecret, String tableName, String importDir)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableExistsException, TException {

    try {
      getClient(sharedSecret).tableOperations().importTable(tableName, importDir);
    } catch (TableExistsException e) {
      throw new org.apache.accumulo.proxy.thrift.TableExistsException(e.toString());
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public org.apache.accumulo.proxy.thrift.IteratorSetting getIteratorSetting(String sharedSecret,
      String tableName, String iteratorName, org.apache.accumulo.proxy.thrift.IteratorScope scope)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      IteratorSetting is = getClient(sharedSecret).tableOperations().getIteratorSetting(tableName,
          iteratorName, getIteratorScope(scope));
      return new org.apache.accumulo.proxy.thrift.IteratorSetting(is.getPriority(), is.getName(),
          is.getIteratorClass(), is.getOptions());
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public Map<String,Set<org.apache.accumulo.proxy.thrift.IteratorScope>>
      listIterators(String sharedSecret, String tableName)
          throws org.apache.accumulo.proxy.thrift.AccumuloException,
          org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
          org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      Map<String,EnumSet<IteratorScope>> iterMap =
          getClient(sharedSecret).tableOperations().listIterators(tableName);
      Map<String,Set<org.apache.accumulo.proxy.thrift.IteratorScope>> result = new HashMap<>();
      for (Map.Entry<String,EnumSet<IteratorScope>> entry : iterMap.entrySet()) {
        result.put(entry.getKey(), getProxyIteratorScopes(entry.getValue()));
      }
      return result;
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public void removeIterator(String sharedSecret, String tableName, String iterName,
      Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      getClient(sharedSecret).tableOperations().removeIterator(tableName, iterName,
          getIteratorScopes(scopes));
    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public Set<org.apache.accumulo.proxy.thrift.Range> splitRangeByTablets(String sharedSecret,
      String tableName, org.apache.accumulo.proxy.thrift.Range range, int maxSplits)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      Set<Range> ranges = getClient(sharedSecret).tableOperations().splitRangeByTablets(tableName,
          getRange(range), maxSplits);
      return ranges.stream().map(this::getRange).collect(Collectors.toSet());
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  private org.apache.accumulo.proxy.thrift.Range getRange(Range r) {
    return new org.apache.accumulo.proxy.thrift.Range(getProxyKey(r.getStartKey()),
        r.isStartKeyInclusive(), getProxyKey(r.getEndKey()), r.isEndKeyInclusive());
  }

  private org.apache.accumulo.proxy.thrift.Key getProxyKey(Key k) {
    if (k == null) {
      return null;
    }
    org.apache.accumulo.proxy.thrift.Key result = new org.apache.accumulo.proxy.thrift.Key(
        TextUtil.getByteBuffer(k.getRow()), TextUtil.getByteBuffer(k.getColumnFamily()),
        TextUtil.getByteBuffer(k.getColumnQualifier()),
        TextUtil.getByteBuffer(k.getColumnVisibility()));
    result.setTimestamp(k.getTimestamp());
    return result;
  }

  private Range getRange(org.apache.accumulo.proxy.thrift.Range range) {
    return new Range(Util.fromThrift(range.start), Util.fromThrift(range.stop));
  }

  @Override
  public void importDirectory(String sharedSecret, String tableName, String importDir,
      String failureDir, boolean setTime)
      throws org.apache.accumulo.proxy.thrift.TableNotFoundException,
      org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).tableOperations().importDirectory(importDir).to(tableName)
          .tableTime(setTime).load();

    } catch (Exception e) {
      handleExceptionTNF(e);
    }
  }

  @Override
  public org.apache.accumulo.proxy.thrift.Range getRowRange(ByteBuffer row) throws TException {
    return getRange(new Range(ByteBufferUtil.toText(row)));
  }

  @Override
  public org.apache.accumulo.proxy.thrift.Key getFollowing(org.apache.accumulo.proxy.thrift.Key key,
      org.apache.accumulo.proxy.thrift.PartialKey part) throws TException {
    Key key_ = Util.fromThrift(key);
    PartialKey part_ = PartialKey.valueOf(part.toString());
    Key followingKey = key_.followingKey(part_);
    return getProxyKey(followingKey);
  }

  @Override
  public String systemNamespace() throws TException {
    return Namespace.ACCUMULO.name();
  }

  @Override
  public String defaultNamespace() throws TException {
    return Namespace.DEFAULT.name();
  }

  @Override
  public List<String> listNamespaces(String sharedSecret)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return new LinkedList<>(getClient(sharedSecret).namespaceOperations().list());
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public boolean namespaceExists(String sharedSecret, String namespaceName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).namespaceOperations().exists(namespaceName);
    } catch (Exception e) {
      handleException(e);
      return false;
    }
  }

  @Override
  public void createNamespace(String sharedSecret, String namespaceName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceExistsException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().create(namespaceName);
    } catch (NamespaceExistsException e) {
      throw new org.apache.accumulo.proxy.thrift.NamespaceExistsException(e.toString());
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void deleteNamespace(String sharedSecret, String namespaceName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException,
      org.apache.accumulo.proxy.thrift.NamespaceNotEmptyException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().delete(namespaceName);
    } catch (NamespaceNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.NamespaceNotFoundException(e.toString());
    } catch (NamespaceNotEmptyException e) {
      throw new org.apache.accumulo.proxy.thrift.NamespaceNotEmptyException(e.toString());
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void renameNamespace(String sharedSecret, String oldNamespaceName, String newNamespaceName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException,
      org.apache.accumulo.proxy.thrift.NamespaceExistsException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().rename(oldNamespaceName, newNamespaceName);
    } catch (NamespaceNotFoundException e) {
      throw new org.apache.accumulo.proxy.thrift.NamespaceNotFoundException(e.toString());
    } catch (NamespaceExistsException e) {
      throw new org.apache.accumulo.proxy.thrift.NamespaceExistsException(e.toString());
    } catch (Exception e) {
      handleException(e);
    }
  }

  @Override
  public void setNamespaceProperty(String sharedSecret, String namespaceName, String property,
      String value) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().setProperty(namespaceName, property, value);
    } catch (Exception e) {
      handleExceptionNNF(e);
    }
  }

  @Override
  public void removeNamespaceProperty(String sharedSecret, String namespaceName, String property)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().removeProperty(namespaceName, property);
    } catch (Exception e) {
      handleExceptionNNF(e);
    }
  }

  @Override
  public Map<String,String> getNamespaceProperties(String sharedSecret, String namespaceName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      Map<String,String> props = new HashMap<>();
      for (Map.Entry<String,String> entry : getClient(sharedSecret).namespaceOperations()
          .getProperties(namespaceName)) {
        props.put(entry.getKey(), entry.getValue());
      }
      return props;
    } catch (Exception e) {
      handleExceptionNNF(e);
      return null;
    }
  }

  @Override
  public Map<String,String> namespaceIdMap(String sharedSecret)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      return getClient(sharedSecret).namespaceOperations().namespaceIdMap();
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public void attachNamespaceIterator(String sharedSecret, String namespaceName,
      org.apache.accumulo.proxy.thrift.IteratorSetting setting,
      Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      if (scopes != null && scopes.size() > 0) {
        getClient(sharedSecret).namespaceOperations().attachIterator(namespaceName,
            getIteratorSetting(setting), getIteratorScopes(scopes));
      } else {
        getClient(sharedSecret).namespaceOperations().attachIterator(namespaceName,
            getIteratorSetting(setting));
      }
    } catch (Exception e) {
      handleExceptionNNF(e);
    }
  }

  @Override
  public void removeNamespaceIterator(String sharedSecret, String namespaceName, String name,
      Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().removeIterator(namespaceName, name,
          getIteratorScopes(scopes));
    } catch (Exception e) {
      handleExceptionNNF(e);
    }
  }

  @Override
  public org.apache.accumulo.proxy.thrift.IteratorSetting getNamespaceIteratorSetting(
      String sharedSecret, String namespaceName, String name,
      org.apache.accumulo.proxy.thrift.IteratorScope scope)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      IteratorSetting setting = getClient(sharedSecret).namespaceOperations()
          .getIteratorSetting(namespaceName, name, getIteratorScope(scope));
      return new org.apache.accumulo.proxy.thrift.IteratorSetting(setting.getPriority(),
          setting.getName(), setting.getIteratorClass(), setting.getOptions());
    } catch (Exception e) {
      handleExceptionNNF(e);
      return null;
    }
  }

  @Override
  public Map<String,Set<org.apache.accumulo.proxy.thrift.IteratorScope>>
      listNamespaceIterators(String sharedSecret, String namespaceName)
          throws org.apache.accumulo.proxy.thrift.AccumuloException,
          org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
          org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      Map<String,Set<org.apache.accumulo.proxy.thrift.IteratorScope>> namespaceIters =
          new HashMap<>();
      for (Map.Entry<String,EnumSet<IteratorScope>> entry : getClient(sharedSecret)
          .namespaceOperations().listIterators(namespaceName).entrySet()) {
        namespaceIters.put(entry.getKey(), getProxyIteratorScopes(entry.getValue()));
      }
      return namespaceIters;
    } catch (Exception e) {
      handleExceptionNNF(e);
      return null;
    }
  }

  @Override
  public void checkNamespaceIteratorConflicts(String sharedSecret, String namespaceName,
      org.apache.accumulo.proxy.thrift.IteratorSetting setting,
      Set<org.apache.accumulo.proxy.thrift.IteratorScope> scopes)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().checkIteratorConflicts(namespaceName,
          getIteratorSetting(setting), getIteratorScopes(scopes));
    } catch (Exception e) {
      handleExceptionNNF(e);
    }
  }

  @Override
  public int addNamespaceConstraint(String sharedSecret, String namespaceName,
      String constraintClassName) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      return getClient(sharedSecret).namespaceOperations().addConstraint(namespaceName,
          constraintClassName);
    } catch (Exception e) {
      handleExceptionNNF(e);
      return -1;
    }
  }

  @Override
  public void removeNamespaceConstraint(String sharedSecret, String namespaceName, int id)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      getClient(sharedSecret).namespaceOperations().removeConstraint(namespaceName, id);
    } catch (Exception e) {
      handleExceptionNNF(e);
    }
  }

  @Override
  public Map<String,Integer> listNamespaceConstraints(String sharedSecret, String namespaceName)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      return getClient(sharedSecret).namespaceOperations().listConstraints(namespaceName);
    } catch (Exception e) {
      handleExceptionNNF(e);
      return null;
    }
  }

  @Override
  public boolean testNamespaceClassLoad(String sharedSecret, String namespaceName, String className,
      String asTypeName) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.NamespaceNotFoundException, TException {
    try {
      return getClient(sharedSecret).namespaceOperations().testClassLoad(namespaceName, className,
          asTypeName);
    } catch (Exception e) {
      handleExceptionNNF(e);
      return false;
    }
  }

  @Override
  public void pingTabletServer(String sharedSecret, String tserver)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {
    try {
      getClient(sharedSecret).instanceOperations().ping(tserver);
    } catch (Exception e) {
      handleException(e);
    }
  }

  private AuthenticationToken getToken(String principal, Map<String,String> properties)
      throws AccumuloSecurityException, AccumuloException {
    AuthenticationToken.Properties props = new AuthenticationToken.Properties();
    props.putAllStrings(properties);
    AuthenticationToken token;
    try {
      token = tokenClass.getDeclaredConstructor().newInstance();
    } catch (ReflectiveOperationException e) {
      logger.error("Error constructing authentication token", e);
      throw new AccumuloException(e);
    }
    token.init(props);
    return token;
  }

  @Override
  public boolean testTableClassLoad(String sharedSecret, String tableName, String className,
      String asTypeName) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      return getClient(sharedSecret).tableOperations().testClassLoad(tableName, className,
          asTypeName);
    } catch (Exception e) {
      handleExceptionTNF(e);
      return false;
    }
  }

  @Override
  public String createConditionalWriter(String sharedSecret, String tableName,
      ConditionalWriterOptions options) throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {
    try {
      ConditionalWriterConfig cwc = new ConditionalWriterConfig();
      if (options.getMaxMemory() != 0) {
        // TODO
      }
      if (options.isSetThreads() && options.getThreads() != 0) {
        cwc.setMaxWriteThreads(options.getThreads());
      }
      if (options.isSetTimeoutMs() && options.getTimeoutMs() != 0) {
        cwc.setTimeout(options.getTimeoutMs(), TimeUnit.MILLISECONDS);
      }
      if (options.isSetAuthorizations() && options.getAuthorizations() != null) {
        cwc.setAuthorizations(getAuthorizations(options.getAuthorizations()));
      }
      if (options.isSetDurability() && options.getDurability() != null) {
        cwc.setDurability(getDurability(options.getDurability()));
      }

      ConditionalWriter cw = getClient(sharedSecret).createConditionalWriter(tableName, cwc);

      UUID id = UUID.randomUUID();

      conditionalWriterCache.put(id, cw);

      return id.toString();
    } catch (Exception e) {
      handleExceptionTNF(e);
      return null;
    }
  }

  @Override
  public Map<ByteBuffer,ConditionalStatus> updateRowsConditionally(String conditionalWriter,
      Map<ByteBuffer,ConditionalUpdates> updates)
      throws UnknownWriter, org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException, TException {

    ConditionalWriter cw = conditionalWriterCache.getIfPresent(UUID.fromString(conditionalWriter));

    if (cw == null) {
      throw new UnknownWriter();
    }

    try {
      HashMap<Text,ColumnVisibility> vizMap = new HashMap<>();

      ArrayList<ConditionalMutation> cmuts = new ArrayList<>(updates.size());
      for (Entry<ByteBuffer,ConditionalUpdates> cu : updates.entrySet()) {
        ConditionalMutation cmut = new ConditionalMutation(ByteBufferUtil.toBytes(cu.getKey()));

        for (Condition tcond : cu.getValue().conditions) {
          org.apache.accumulo.core.data.Condition cond =
              new org.apache.accumulo.core.data.Condition(tcond.column.getColFamily(),
                  tcond.column.getColQualifier());

          if (tcond.getColumn().getColVisibility() != null
              && tcond.getColumn().getColVisibility().length > 0) {
            cond.setVisibility(getCahcedCV(vizMap, tcond.getColumn().getColVisibility()));
          }

          if (tcond.isSetValue()) {
            cond.setValue(tcond.getValue());
          }

          if (tcond.isSetTimestamp()) {
            cond.setTimestamp(tcond.getTimestamp());
          }

          if (tcond.isSetIterators()) {
            cond.setIterators(getIteratorSettings(tcond.getIterators())
                .toArray(new IteratorSetting[tcond.getIterators().size()]));
          }

          cmut.addCondition(cond);
        }

        addUpdatesToMutation(vizMap, cmut, cu.getValue().updates);

        cmuts.add(cmut);
      }

      Iterator<Result> results = cw.write(cmuts.iterator());

      HashMap<ByteBuffer,ConditionalStatus> resultMap = new HashMap<>();

      while (results.hasNext()) {
        Result result = results.next();
        ByteBuffer row = ByteBuffer.wrap(result.getMutation().getRow());
        ConditionalStatus status = ConditionalStatus.valueOf(result.getStatus().name());
        resultMap.put(row, status);
      }

      return resultMap;
    } catch (RuntimeException e) {
      throw (e);
    } catch (Exception e) {
      handleException(e);
      return null;
    }
  }

  @Override
  public void closeConditionalWriter(String conditionalWriter) throws TException {
    ConditionalWriter cw = conditionalWriterCache.getIfPresent(UUID.fromString(conditionalWriter));
    if (cw != null) {
      cw.close();
      conditionalWriterCache.invalidate(UUID.fromString(conditionalWriter));
    }
  }

  @Override
  public ConditionalStatus updateRowConditionally(String sharedSecret, String tableName,
      ByteBuffer row, ConditionalUpdates updates)
      throws org.apache.accumulo.proxy.thrift.AccumuloException,
      org.apache.accumulo.proxy.thrift.AccumuloSecurityException,
      org.apache.accumulo.proxy.thrift.TableNotFoundException, TException {

    String cwid = createConditionalWriter(sharedSecret, tableName, new ConditionalWriterOptions());
    try {
      return updateRowsConditionally(cwid, Collections.singletonMap(row, updates)).get(row);
    } finally {
      closeConditionalWriter(cwid);
    }
  }
}
