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
package org.apache.accumulo.proxy.its;

import static java.nio.charset.StandardCharsets.UTF_8;
import static org.apache.accumulo.core.util.UtilWaitThread.sleepUninterruptibly;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.URI;
import java.nio.ByteBuffer;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

import org.apache.accumulo.cluster.ClusterUser;
import org.apache.accumulo.core.client.Accumulo;
import org.apache.accumulo.core.client.AccumuloClient;
import org.apache.accumulo.core.client.admin.compaction.TooManyDeletesSelector;
import org.apache.accumulo.core.client.security.tokens.KerberosToken;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import org.apache.accumulo.core.client.summary.summarizers.DeletesSummarizer;
import org.apache.accumulo.core.clientImpl.ClientInfo;
import org.apache.accumulo.core.clientImpl.Namespace;
import org.apache.accumulo.core.conf.DefaultConfiguration;
import org.apache.accumulo.core.conf.Property;
import org.apache.accumulo.core.data.Value;
import org.apache.accumulo.core.file.FileOperations;
import org.apache.accumulo.core.file.FileSKVWriter;
import org.apache.accumulo.core.iterators.DebugIterator;
import org.apache.accumulo.core.iterators.DevNull;
import org.apache.accumulo.core.iterators.SortedKeyValueIterator;
import org.apache.accumulo.core.iterators.user.SummingCombiner;
import org.apache.accumulo.core.iterators.user.VersioningIterator;
import org.apache.accumulo.core.metadata.MetadataTable;
import org.apache.accumulo.core.security.Authorizations;
import org.apache.accumulo.core.spi.crypto.NoCryptoServiceFactory;
import org.apache.accumulo.core.util.ByteBufferUtil;
import org.apache.accumulo.core.util.HostAndPort;
import org.apache.accumulo.harness.MiniClusterConfigurationCallback;
import org.apache.accumulo.harness.MiniClusterHarness;
import org.apache.accumulo.harness.SharedMiniClusterBase;
import org.apache.accumulo.harness.TestingKdc;
import org.apache.accumulo.miniclusterImpl.MiniAccumuloClusterImpl;
import org.apache.accumulo.miniclusterImpl.MiniAccumuloConfigImpl;
import org.apache.accumulo.proxy.Proxy;
import org.apache.accumulo.proxy.thrift.AccumuloProxy.Client;
import org.apache.accumulo.proxy.thrift.AccumuloSecurityException;
import org.apache.accumulo.proxy.thrift.ActiveCompaction;
import org.apache.accumulo.proxy.thrift.ActiveScan;
import org.apache.accumulo.proxy.thrift.BatchScanOptions;
import org.apache.accumulo.proxy.thrift.Column;
import org.apache.accumulo.proxy.thrift.ColumnUpdate;
import org.apache.accumulo.proxy.thrift.CompactionReason;
import org.apache.accumulo.proxy.thrift.CompactionType;
import org.apache.accumulo.proxy.thrift.Condition;
import org.apache.accumulo.proxy.thrift.ConditionalStatus;
import org.apache.accumulo.proxy.thrift.ConditionalUpdates;
import org.apache.accumulo.proxy.thrift.ConditionalWriterOptions;
import org.apache.accumulo.proxy.thrift.DiskUsage;
import org.apache.accumulo.proxy.thrift.IteratorScope;
import org.apache.accumulo.proxy.thrift.IteratorSetting;
import org.apache.accumulo.proxy.thrift.Key;
import org.apache.accumulo.proxy.thrift.KeyValue;
import org.apache.accumulo.proxy.thrift.MutationsRejectedException;
import org.apache.accumulo.proxy.thrift.NamespaceExistsException;
import org.apache.accumulo.proxy.thrift.NamespaceNotEmptyException;
import org.apache.accumulo.proxy.thrift.NamespaceNotFoundException;
import org.apache.accumulo.proxy.thrift.NamespacePermission;
import org.apache.accumulo.proxy.thrift.PartialKey;
import org.apache.accumulo.proxy.thrift.PluginConfig;
import org.apache.accumulo.proxy.thrift.Range;
import org.apache.accumulo.proxy.thrift.ScanColumn;
import org.apache.accumulo.proxy.thrift.ScanOptions;
import org.apache.accumulo.proxy.thrift.ScanResult;
import org.apache.accumulo.proxy.thrift.ScanState;
import org.apache.accumulo.proxy.thrift.ScanType;
import org.apache.accumulo.proxy.thrift.SystemPermission;
import org.apache.accumulo.proxy.thrift.TableExistsException;
import org.apache.accumulo.proxy.thrift.TableNotFoundException;
import org.apache.accumulo.proxy.thrift.TablePermission;
import org.apache.accumulo.proxy.thrift.TimeType;
import org.apache.accumulo.proxy.thrift.UnknownScanner;
import org.apache.accumulo.proxy.thrift.UnknownWriter;
import org.apache.accumulo.proxy.thrift.WriterOptions;
import org.apache.accumulo.server.util.PortUtils;
import org.apache.accumulo.test.constraints.MaxMutationSize;
import org.apache.accumulo.test.constraints.NumericValueConstraint;
import org.apache.accumulo.test.functional.SlowIterator;
import org.apache.accumulo.test.util.Wait;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.CommonConfigurationKeysPublic;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FileUtil;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.thrift.TApplicationException;
import org.apache.thrift.TException;
import org.apache.thrift.protocol.TProtocolFactory;
import org.apache.thrift.server.TServer;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInfo;
import org.junit.jupiter.api.Timeout;
import org.junit.jupiter.api.function.Executable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Sets;

/**
 * Call every method on the proxy and try to verify that it works.
 */
public abstract class SimpleProxyBase extends SharedMiniClusterBase {
  private final Logger log = LoggerFactory.getLogger(getClass());

  @Override
  protected Duration defaultTimeout() {
    return Duration.ofMinutes(1);
  }

  private static final long ZOOKEEPER_PROPAGATION_TIME = 10 * 1000;
  private static TServer proxyServer;
  private static int proxyPort;

  private TestProxyClient proxyClient;
  private org.apache.accumulo.proxy.thrift.AccumuloProxy.Client client;

  private static String hostname;
  private static String proxyPrimary;
  private static String clientPrincipal;
  private static File clientKeytab;

  private static String sharedSecret;

  // Implementations can set this
  static TProtocolFactory factory = null;

  private static void waitForAccumulo(AccumuloClient c) throws Exception {
    assertNotEquals(0, c.createScanner(MetadataTable.NAME, Authorizations.EMPTY).stream().count());
  }

  private static boolean isKerberosEnabled() {
    return SharedMiniClusterBase.TRUE
        .equals(System.getProperty(MiniClusterHarness.USE_KERBEROS_FOR_IT_OPTION));
  }

  /**
   * The purpose of this callback is to setup the tests to NOT use the native libs
   */
  protected static class TestConfig implements MiniClusterConfigurationCallback {
    @Override
    public void configureMiniCluster(MiniAccumuloConfigImpl cfg, Configuration coreSite) {
      // Set the min span to 0 so we will definitely get all the traces back. See ACCUMULO-4365
      Map<String,String> siteConf = cfg.getSiteConfig();
      siteConf.put(Property.TSERV_NATIVEMAP_ENABLED.getKey(), "false");
      cfg.setSiteConfig(siteConf);
    }
  }

  /**
   * Does the actual test setup, invoked by the concrete test class
   */
  public static void setUpProxy() throws Exception {
    assertNotNull(factory, "Implementations must initialize the TProtocolFactory");

    try (AccumuloClient c = Accumulo.newClient().from(getClientProps()).build()) {
      waitForAccumulo(c);

      hostname = InetAddress.getLocalHost().getCanonicalHostName();

      Properties props = new Properties();
      ClientInfo info = ClientInfo.from(c.properties());
      props.put("instance", info.getInstanceName());
      props.put("zookeepers", info.getZooKeepers());

      final String tokenClass;
      if (isKerberosEnabled()) {
        tokenClass = KerberosToken.class.getName();
        TestingKdc kdc = getKdc();

        // Create a principal+keytab for the proxy
        File proxyKeytab = new File(kdc.getKeytabDir(), "proxy.keytab");
        hostname = InetAddress.getLocalHost().getCanonicalHostName();
        // Set the primary because the client needs to know it
        proxyPrimary = "proxy";
        // Qualify with an instance
        String proxyPrincipal = proxyPrimary + "/" + hostname;
        kdc.createPrincipal(proxyKeytab, proxyPrincipal);
        // Tack on the realm too
        proxyPrincipal = kdc.qualifyUser(proxyPrincipal);

        props.setProperty("kerberosPrincipal", proxyPrincipal);
        props.setProperty("kerberosKeytab", proxyKeytab.getCanonicalPath());
        props.setProperty("thriftServerType", "sasl");

        // Enabled kerberos auth
        Configuration conf = new Configuration(false);
        conf.set(CommonConfigurationKeysPublic.HADOOP_SECURITY_AUTHENTICATION, "kerberos");
        UserGroupInformation.setConfiguration(conf);

        // Login for the Proxy itself
        UserGroupInformation.loginUserFromKeytab(proxyPrincipal, proxyKeytab.getAbsolutePath());

        // User for tests
        ClusterUser user = kdc.getRootUser();
        clientPrincipal = user.getPrincipal();
        clientKeytab = user.getKeytab();
      } else {
        clientPrincipal = "root";
        tokenClass = PasswordToken.class.getName();
        sharedSecret = SharedMiniClusterBase.getRootPassword();
        props.put("sharedSecret", sharedSecret);
        hostname = "localhost";
      }

      props.put("tokenClass", tokenClass);
      props.putAll(SharedMiniClusterBase.getCluster().getClientProperties());
      proxyPort = PortUtils.getRandomFreePort();
      proxyServer = Proxy.createProxyServer(HostAndPort.fromParts(hostname, proxyPort), factory,
          props).server;
      while (!proxyServer.isServing()) {
        sleepUninterruptibly(100, TimeUnit.MILLISECONDS);
      }
    }
  }

  @AfterAll
  public static void tearDownProxy() {
    if (proxyServer != null) {
      proxyServer.stop();
    }

    SharedMiniClusterBase.stopMiniCluster();
  }

  final IteratorSetting setting = new IteratorSetting(100, "slow", SlowIterator.class.getName(),
      Collections.singletonMap("sleepTime", "200"));
  String tableName;
  String namespaceName;
  String badSecret;

  private String testName;

  private String[] getUniqueNameArray(int num) {
    String[] names = new String[num];
    for (int i = 0; i < num; i++) {
      names[i] = this.getClass().getSimpleName() + "_" + testName + i;
    }
    return names;
  }

  @BeforeEach
  public void setup(TestInfo info) throws Exception {
    // Create a new client for each test
    if (isKerberosEnabled()) {
      UserGroupInformation.loginUserFromKeytab(clientPrincipal, clientKeytab.getAbsolutePath());
      proxyClient = new TestProxyClient(hostname, proxyPort, factory, proxyPrimary,
          UserGroupInformation.getCurrentUser());
      client = proxyClient.proxy();

      TestingKdc kdc = getKdc();
      final ClusterUser user = kdc.getClientPrincipal(0);
      // Create another user
      client.createLocalUser(sharedSecret, user.getPrincipal(), s2bb("unused"));
      // Login in as that user we just created
      UserGroupInformation.loginUserFromKeytab(user.getPrincipal(),
          user.getKeytab().getAbsolutePath());
      final UserGroupInformation badUgi = UserGroupInformation.getCurrentUser();
      // Get a "Credentials" object for the proxy
      TestProxyClient badClient =
          new TestProxyClient(hostname, proxyPort, factory, proxyPrimary, badUgi);
      try {
        badSecret = "badSecret";
      } finally {
        badClient.close();
      }

      // Log back in as the test user
      UserGroupInformation.loginUserFromKeytab(clientPrincipal, clientKeytab.getAbsolutePath());
      // Drop test user, invalidating the credentials (not to mention not having the krb credentials
      // anymore)
      client.dropLocalUser(sharedSecret, user.getPrincipal());
    } else {
      proxyClient = new TestProxyClient(hostname, proxyPort, factory);
      client = proxyClient.proxy();

      // Create 'user'
      client.createLocalUser(sharedSecret, "user", s2bb(SharedMiniClusterBase.getRootPassword()));
      // Log in as 'user'
      badSecret = "badSecret";
      // Drop 'user', invalidating the credentials
      client.dropLocalUser(sharedSecret, "user");
    }

    testName = info.getTestMethod().get().getName();

    // Create some unique names for tables, namespaces, etc.
    String[] uniqueNames = getUniqueNameArray(2);

    // Create a general table to be used
    tableName = uniqueNames[0];
    client.createTable(sharedSecret, tableName, true, TimeType.MILLIS);

    // Create a general namespace to be used
    namespaceName = uniqueNames[1];
    client.createNamespace(sharedSecret, namespaceName);
  }

  @AfterEach
  public void teardown() throws Exception {
    if (tableName != null) {
      if (isKerberosEnabled()) {
        UserGroupInformation.loginUserFromKeytab(clientPrincipal, clientKeytab.getAbsolutePath());
      }
      try {
        if (client.tableExists(sharedSecret, tableName)) {
          client.deleteTable(sharedSecret, tableName);
        }
      } catch (Exception e) {
        log.warn("Failed to delete test table '{}'", tableName, e);
      }
    }

    if (namespaceName != null) {
      try {
        if (client.namespaceExists(sharedSecret, namespaceName)) {
          client.deleteNamespace(sharedSecret, namespaceName);
        }
      } catch (Exception e) {
        log.warn("Failed to delete test namespace '{}'", namespaceName, e);
      }
    }

    // Close the transport after the test
    if (proxyClient != null) {
      proxyClient.close();
    }
  }

  /*
   * Set a lower timeout for tests that should fail fast
   */

  @Test
  @Timeout(5)
  public void addConstraintBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.addConstraint(badSecret, tableName, NumericValueConstraint.class.getName()));
  }

  @Test
  @Timeout(5)
  public void addSplitsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.addSplits(badSecret, tableName, Collections.singleton(s2bb("1"))));
  }

  @Test
  @Timeout(5)
  public void clearLocatorCacheBadSharedSecret() {
    assertThrows(TApplicationException.class, () -> client.clearLocatorCache(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void compactTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.compactTable(badSecret, tableName, null, null, null, true, false, null, null));
  }

  @Test
  @Timeout(5)
  public void cancelCompactionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.cancelCompaction(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void createTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createTable(badSecret, tableName, false, TimeType.MILLIS));
  }

  @Test
  @Timeout(5)
  public void deleteTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.deleteTable(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void deleteRowsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.deleteRows(badSecret, tableName, null, null));
  }

  @Test
  @Timeout(5)
  public void tableExistsBadSharedSecret() {
    assertThrows(TApplicationException.class, () -> client.tableExists(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void flushTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.flushTable(badSecret, tableName, null, null, false));
  }

  @Test
  @Timeout(5)
  public void getLocalityGroupsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getLocalityGroups(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void getMaxRowBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.getMaxRow(badSecret, tableName,
        Collections.emptySet(), null, false, null, false));
  }

  @Test
  @Timeout(5)
  public void getTablePropertiesBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getTableProperties(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void listSplitsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.listSplits(badSecret, tableName, 10000));
  }

  @Test
  @Timeout(5)
  public void listTablesBadSharedSecret() {
    assertThrows(TApplicationException.class, () -> client.listTables(badSecret));
  }

  @Test
  @Timeout(5)
  public void listConstraintsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.listConstraints(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void mergeTabletsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.mergeTablets(badSecret, tableName, null, null));
  }

  @Test
  @Timeout(5)
  public void offlineTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.offlineTable(badSecret, tableName, false));
  }

  @Test
  @Timeout(5)
  public void onlineTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.onlineTable(badSecret, tableName, false));
  }

  @Test
  @Timeout(5)
  public void removeConstraintBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.removeConstraint(badSecret, tableName, 0));
  }

  @Test
  @Timeout(5)
  public void removeTablePropertyBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.removeTableProperty(badSecret, tableName, Property.TABLE_FILE_MAX.getKey()));
  }

  @Test
  @Timeout(5)
  public void renameTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.renameTable(badSecret, tableName, "someTableName"));
  }

  @Test
  @Timeout(5)
  public void setLocalityGroupsBadSharedSecret() {
    Map<String,Set<String>> groups = new HashMap<>();
    groups.put("group1", Collections.singleton("cf1"));
    groups.put("group2", Collections.singleton("cf2"));
    assertThrows(AccumuloSecurityException.class,
        () -> client.setLocalityGroups(badSecret, tableName, groups));
  }

  @Test
  @Timeout(5)
  public void setTablePropertyBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.setTableProperty(badSecret, tableName, Property.TABLE_FILE_MAX.getKey(), "0"));
  }

  @Test
  @Timeout(5)
  public void tableIdMapBadSharedSecret() {
    assertThrows(TException.class, () -> client.tableIdMap(badSecret));
  }

  @Test
  @Timeout(5)
  public void getSiteConfigurationBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.getSiteConfiguration(badSecret));
  }

  @Test
  @Timeout(5)
  public void getSystemConfigurationBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.getSystemConfiguration(badSecret));
  }

  @Test
  @Timeout(5)
  public void getTabletServersBadSharedSecret() {
    assertThrows(TException.class, () -> client.getTabletServers(badSecret));
  }

  @Test
  @Timeout(5)
  public void getActiveScansBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.getActiveScans(badSecret, "fake"));
  }

  @Test
  @Timeout(5)
  public void getActiveCompactionsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getActiveCompactions(badSecret, "fake"));
  }

  @Test
  @Timeout(5)
  public void removePropertyBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.removeProperty(badSecret, "table.split.threshold"));
  }

  @Test
  @Timeout(5)
  public void setPropertyBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.setProperty(badSecret, "table.split.threshold", "500M"));
  }

  @Test
  @Timeout(5)
  public void testClassLoadBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.testClassLoad(badSecret,
        DevNull.class.getName(), SortedKeyValueIterator.class.getName()));
  }

  @Test
  @Timeout(5)
  public void authenticateUserBadSharedSecret() {
    if (!isKerberosEnabled()) {
      // Not really a relevant test for kerberos
      Map<String,String> pw = s2pp(SharedMiniClusterBase.getRootPassword());
      assertThrows(AccumuloSecurityException.class,
          () -> client.authenticateUser(badSecret, "root", pw));
    }
  }

  @Test
  @Timeout(5)
  public void changeUserAuthorizationsBadSharedSecret() {
    HashSet<ByteBuffer> auths = new HashSet<>(List.of(s2bb("A"), s2bb("B")));
    assertThrows(AccumuloSecurityException.class,
        () -> client.changeUserAuthorizations(badSecret, "stooge", auths));
  }

  @Test
  @Timeout(5)
  public void changePasswordBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.changeLocalUserPassword(badSecret, "stooge", s2bb("")));
  }

  @Test
  @Timeout(5)
  public void createUserBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createLocalUser(badSecret, "stooge", s2bb("password")));
  }

  @Test
  @Timeout(5)
  public void dropUserBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.dropLocalUser(badSecret, "stooge"));
  }

  @Test
  @Timeout(5)
  public void getUserAuthorizationsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getUserAuthorizations(badSecret, "stooge"));
  }

  @Test
  @Timeout(5)
  public void grantSystemPermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.grantSystemPermission(badSecret, "stooge", SystemPermission.CREATE_TABLE));
  }

  @Test
  @Timeout(5)
  public void grantTablePermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.grantTablePermission(badSecret, "root", tableName, TablePermission.WRITE));
  }

  @Test
  @Timeout(5)
  public void hasSystemPermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.hasSystemPermission(badSecret, "stooge", SystemPermission.CREATE_TABLE));
  }

  @Test
  @Timeout(5)
  public void hasTablePermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.hasTablePermission(badSecret, "root", tableName, TablePermission.WRITE));
  }

  @Test
  @Timeout(5)
  public void listLocalUsersBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.listLocalUsers(badSecret));
  }

  @Test
  @Timeout(5)
  public void revokeSystemPermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.revokeSystemPermission(badSecret, "stooge", SystemPermission.CREATE_TABLE));
  }

  @Test
  @Timeout(5)
  public void revokeTablePermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.revokeTablePermission(badSecret,
        "root", tableName, TablePermission.ALTER_TABLE));
  }

  @Test
  @Timeout(5)
  public void createScannerBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createScanner(badSecret, tableName, new ScanOptions()));
  }

  @Test
  @Timeout(5)
  public void createBatchScannerBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createBatchScanner(badSecret, tableName, new BatchScanOptions()));
  }

  @Test
  @Timeout(5)
  public void updateAndFlushBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.updateAndFlush(badSecret, tableName, new HashMap<>()));
  }

  @Test
  @Timeout(5)
  public void createWriterBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createWriter(badSecret, tableName, new WriterOptions()));
  }

  @Test
  @Timeout(5)
  public void attachIteratorBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.attachIterator(badSecret, "slow",
        setting, EnumSet.allOf(IteratorScope.class)));
  }

  @Test
  @Timeout(5)
  public void checkIteratorBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.checkIteratorConflicts(badSecret,
        tableName, setting, EnumSet.allOf(IteratorScope.class)));
  }

  @Test
  @Timeout(5)
  public void cloneTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.cloneTable(badSecret, tableName, tableName + "_clone", false, null, null));
  }

  @Test
  @Timeout(5)
  public void exportTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.exportTable(badSecret, tableName, "/tmp"));
  }

  @Test
  @Timeout(5)
  public void importTableBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.importTable(badSecret, "testify", "/tmp"));
  }

  @Test
  @Timeout(5)
  public void getIteratorSettingBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getIteratorSetting(badSecret, tableName, "foo", IteratorScope.SCAN));
  }

  @Test
  @Timeout(5)
  public void listIteratorsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.listIterators(badSecret, tableName));
  }

  @Test
  @Timeout(5)
  public void removeIteratorBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.removeIterator(badSecret, tableName,
        "name", EnumSet.allOf(IteratorScope.class)));
  }

  @Test
  @Timeout(5)
  public void splitRangeByTabletsBadSharedSecret() throws Exception {
    Range range = client.getRowRange(ByteBuffer.wrap("row".getBytes(UTF_8)));
    assertThrows(AccumuloSecurityException.class,
        () -> client.splitRangeByTablets(badSecret, tableName, range, 10));
  }

  @Test
  @Timeout(5)
  public void importDirectoryBadSharedSecret() throws Exception {
    MiniAccumuloClusterImpl cluster = SharedMiniClusterBase.getCluster();
    Path base = cluster.getTemporaryPath();
    Path importDir = new Path(base, "importDir");
    Path failuresDir = new Path(base, "failuresDir");
    assertTrue(cluster.getFileSystem().mkdirs(importDir));
    assertTrue(cluster.getFileSystem().mkdirs(failuresDir));
    assertThrows(AccumuloSecurityException.class, () -> client.importDirectory(badSecret, tableName,
        importDir.toString(), failuresDir.toString(), true));
  }

  @Test
  @Timeout(5)
  public void pingTabletServerBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.pingTabletServer(badSecret, "fake"));
  }

  @Test
  @Timeout(5)
  public void testTableClassLoadBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.testTableClassLoad(badSecret,
        tableName, VersioningIterator.class.getName(), SortedKeyValueIterator.class.getName()));
  }

  @Test
  @Timeout(5)
  public void createConditionalWriterBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createConditionalWriter(badSecret, tableName, new ConditionalWriterOptions()));
  }

  @Test
  @Timeout(5)
  public void grantNamespacePermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.grantNamespacePermission(badSecret,
        "stooge", namespaceName, NamespacePermission.ALTER_NAMESPACE));
  }

  @Test
  @Timeout(5)
  public void hasNamespacePermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.hasNamespacePermission(badSecret,
        "stooge", namespaceName, NamespacePermission.ALTER_NAMESPACE));
  }

  @Test
  @Timeout(5)
  public void revokeNamespacePermissionBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.revokeNamespacePermission(badSecret,
        "stooge", namespaceName, NamespacePermission.ALTER_NAMESPACE));
  }

  @Test
  @Timeout(5)
  public void listNamespacesBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.listNamespaces(badSecret));
  }

  @Test
  @Timeout(5)
  public void namespaceExistsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.namespaceExists(badSecret, namespaceName));
  }

  @Test
  @Timeout(5)
  public void createNamespaceBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.createNamespace(badSecret, "abcdef"));
  }

  @Test
  @Timeout(5)
  public void deleteNamespaceBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.deleteNamespace(badSecret, namespaceName));
  }

  @Test
  @Timeout(5)
  public void renameNamespaceBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.renameNamespace(badSecret, namespaceName, "abcdef"));
  }

  @Test
  @Timeout(5)
  public void setNamespacePropertyBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.setNamespaceProperty(badSecret,
        namespaceName, "table.compaction.major.ratio", "4"));
  }

  @Test
  @Timeout(5)
  public void removeNamespacePropertyBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.removeNamespaceProperty(badSecret,
        namespaceName, "table.compaction.major.ratio"));
  }

  @Test
  @Timeout(5)
  public void getNamespacePropertiesBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getNamespaceProperties(badSecret, namespaceName));
  }

  @Test
  @Timeout(5)
  public void namespaceIdMapBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.namespaceIdMap(badSecret));
  }

  @Test
  @Timeout(5)
  public void attachNamespaceIteratorBadSharedSecret() {
    IteratorSetting setting = new IteratorSetting(100, "DebugTheThings",
        DebugIterator.class.getName(), Collections.emptyMap());
    assertThrows(AccumuloSecurityException.class, () -> client.attachNamespaceIterator(badSecret,
        namespaceName, setting, EnumSet.allOf(IteratorScope.class)));
  }

  @Test
  @Timeout(5)
  public void removeNamespaceIteratorBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.removeNamespaceIterator(badSecret,
        namespaceName, "DebugTheThings", EnumSet.allOf(IteratorScope.class)));
  }

  @Test
  @Timeout(5)
  public void getNamespaceIteratorSettingBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.getNamespaceIteratorSetting(badSecret, namespaceName, "DebugTheThings",
            IteratorScope.SCAN));
  }

  @Test
  @Timeout(5)
  public void listNamespaceIteratorsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.listNamespaceIterators(badSecret, namespaceName));
  }

  @Test
  @Timeout(5)
  public void checkNamespaceIteratorConflictsBadSharedSecret() {
    IteratorSetting setting = new IteratorSetting(100, "DebugTheThings",
        DebugIterator.class.getName(), Collections.emptyMap());
    assertThrows(AccumuloSecurityException.class,
        () -> client.checkNamespaceIteratorConflicts(badSecret, namespaceName, setting,
            EnumSet.allOf(IteratorScope.class)));
  }

  @Test
  @Timeout(5)
  public void addNamespaceConstraintBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.addNamespaceConstraint(badSecret,
        namespaceName, MaxMutationSize.class.getName()));
  }

  @Test
  @Timeout(5)
  public void removeNamespaceConstraintBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.removeNamespaceConstraint(badSecret, namespaceName, 1));
  }

  @Test
  @Timeout(5)
  public void listNamespaceConstraintsBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class,
        () -> client.listNamespaceConstraints(badSecret, namespaceName));
  }

  @Test
  @Timeout(5)
  public void testNamespaceClassLoadBadSharedSecret() {
    assertThrows(AccumuloSecurityException.class, () -> client.testNamespaceClassLoad(badSecret,
        namespaceName, DebugIterator.class.getName(), SortedKeyValueIterator.class.getName()));
  }

  @Test
  public void tableNotFound() throws IOException {
    final String doesNotExist = "doesNotExist";

    final IteratorSetting setting = new IteratorSetting(100, "slow", SlowIterator.class.getName(),
        Collections.singletonMap("sleepTime", "200"));

    final String newTableName = getUniqueNameArray(1)[0];

    final MiniAccumuloClusterImpl cluster = SharedMiniClusterBase.getCluster();
    final Path base = cluster.getTemporaryPath();
    final Path importDir = new Path(base, "importDir");
    final Path failuresDir = new Path(base, "failuresDir");
    assertTrue(cluster.getFileSystem().mkdirs(importDir));
    assertTrue(cluster.getFileSystem().mkdirs(failuresDir));

    // @formatter:off
    Stream<Executable> cases = Stream.of(
        () -> client.addConstraint(sharedSecret, doesNotExist, NumericValueConstraint.class.getName()),
        () -> client.addSplits(sharedSecret, doesNotExist, Collections.emptySet()),
        () -> client.attachIterator(sharedSecret, doesNotExist, setting, EnumSet.allOf(IteratorScope.class)),
        () -> client.cancelCompaction(sharedSecret, doesNotExist),
        () -> client.checkIteratorConflicts(sharedSecret, doesNotExist, setting, EnumSet.allOf(IteratorScope.class)),
        () -> client.clearLocatorCache(sharedSecret, doesNotExist),
        () -> client.cloneTable(sharedSecret, doesNotExist, newTableName, false, null, null),
        () -> client.compactTable(sharedSecret, doesNotExist, null, null, null, true, false, null,null),
        () -> client.createBatchScanner(sharedSecret, doesNotExist, new BatchScanOptions()),
        () -> client.createScanner(sharedSecret, doesNotExist, new ScanOptions()),
        () -> client.createWriter(sharedSecret, doesNotExist, new WriterOptions()),
        () -> client.deleteRows(sharedSecret, doesNotExist, null, null),
        () -> client.deleteTable(sharedSecret, doesNotExist),
        () -> client.exportTable(sharedSecret, doesNotExist, "/tmp"),
        () -> client.flushTable(sharedSecret, doesNotExist, null, null, false),
        () -> client.getIteratorSetting(sharedSecret, doesNotExist, "foo", IteratorScope.SCAN),
        () -> client.getLocalityGroups(sharedSecret, doesNotExist),
        () -> client.getMaxRow(sharedSecret, doesNotExist, Collections.emptySet(), null, false, null, false),
        () -> client.getTableProperties(sharedSecret, doesNotExist),
        () -> client.grantTablePermission(sharedSecret, "root", doesNotExist, TablePermission.WRITE),
        () -> client.hasTablePermission(sharedSecret, "root", doesNotExist, TablePermission.WRITE),
        () -> client.importDirectory(sharedSecret, doesNotExist, importDir.toString(), failuresDir.toString(), true),
        () -> client.listConstraints(sharedSecret, doesNotExist),
        () -> client.listSplits(sharedSecret, doesNotExist, 10000),
        () -> client.mergeTablets(sharedSecret, doesNotExist, null, null),
        () -> client.offlineTable(sharedSecret, doesNotExist, false),
        () -> client.onlineTable(sharedSecret, doesNotExist, false),
        () -> client.removeConstraint(sharedSecret, doesNotExist, 0),
        () -> client.removeIterator(sharedSecret, doesNotExist, "name", EnumSet.allOf(IteratorScope.class)),
        () -> client.removeTableProperty(sharedSecret, doesNotExist, Property.TABLE_FILE_MAX.getKey()),
        () -> client.renameTable(sharedSecret, doesNotExist, "someTableName"),
        () -> client.revokeTablePermission(sharedSecret, "root", doesNotExist, TablePermission.ALTER_TABLE),
        () -> client.setTableProperty(sharedSecret, doesNotExist, Property.TABLE_FILE_MAX.getKey(), "0"),
        () -> client.splitRangeByTablets(sharedSecret, doesNotExist, client.getRowRange(ByteBuffer.wrap("row".getBytes(UTF_8))), 10),
        () -> client.updateAndFlush(sharedSecret, doesNotExist, new HashMap<>()),
        () -> client.getDiskUsage(sharedSecret, Collections.singleton(doesNotExist)),
        () -> client.testTableClassLoad(sharedSecret, doesNotExist, VersioningIterator.class.getName(), SortedKeyValueIterator.class.getName()),
        () -> client.createConditionalWriter(sharedSecret, doesNotExist, new ConditionalWriterOptions())
    );
    // @formatter:on

    cases.forEach(e -> assertThrows(TableNotFoundException.class, e));
  }

  @Test
  public void namespaceNotFound() {
    final String doesNotExist = "doesNotExist";
    final IteratorSetting iteratorSetting = new IteratorSetting(100, "DebugTheThings",
        DebugIterator.class.getName(), Collections.emptyMap());

    // @formatter:off
    Stream<Executable> cases = Stream.of(
        () -> client.deleteNamespace(sharedSecret, doesNotExist),
        () -> client.renameNamespace(sharedSecret, doesNotExist, "abcdefg"),
        () -> client.setNamespaceProperty(sharedSecret, doesNotExist, "table.compaction.major.ratio", "4"),
        () -> client.removeNamespaceProperty(sharedSecret, doesNotExist, "table.compaction.major.ratio"),
        () -> client.getNamespaceProperties(sharedSecret, doesNotExist),
        () -> client.attachNamespaceIterator(sharedSecret, doesNotExist, setting, EnumSet.allOf(IteratorScope.class)),
        () -> client.removeNamespaceIterator(sharedSecret, doesNotExist, "DebugTheThings", EnumSet.allOf(IteratorScope.class)),
        () -> client.getNamespaceIteratorSetting(sharedSecret, doesNotExist, "DebugTheThings", IteratorScope.SCAN),
        () -> client.listNamespaceIterators(sharedSecret, doesNotExist),
        () -> client.checkNamespaceIteratorConflicts(sharedSecret, doesNotExist, iteratorSetting, EnumSet.allOf(IteratorScope.class)),
        () -> client.addNamespaceConstraint(sharedSecret, doesNotExist, MaxMutationSize.class.getName()),
        () -> client.removeNamespaceConstraint(sharedSecret, doesNotExist, 1),
        () -> client.listNamespaceConstraints(sharedSecret, doesNotExist),
        () -> client.testNamespaceClassLoad(sharedSecret, doesNotExist, DebugIterator.class.getName(), SortedKeyValueIterator.class.getName())
    );
    // @formatter:on

    cases.forEach(executable -> assertThrows(NamespaceNotFoundException.class, executable));
  }

  @Test
  public void testExists() throws TException {
    final String table1 = "ett1";
    final String table2 = "ett2";

    client.createTable(sharedSecret, table1, false, TimeType.MILLIS);
    client.createTable(sharedSecret, table2, false, TimeType.MILLIS);

    // @formatter:off
    Stream<Executable> cases = Stream.of(
        () -> client.createTable(sharedSecret, table1, false, TimeType.MILLIS),
        () -> client.renameTable(sharedSecret, table1, table2),
        () -> client.cloneTable(sharedSecret, table1, table2, false, new HashMap<>(), new HashSet<>())
    );
    // @formatter:on

    cases.forEach(executable -> assertThrows(TableExistsException.class, executable));
  }

  @Test
  public void testNamespaceExists() throws TException {
    client.createNamespace(sharedSecret, "foobar");

    // @formatter:off
    Stream<Executable> cases = Stream.of(
        () -> client.createNamespace(sharedSecret, namespaceName),
        () -> client.renameNamespace(sharedSecret, "foobar", namespaceName)
    );
    // @formatter:on

    cases.forEach(executable -> assertThrows(NamespaceExistsException.class, executable));
  }

  @Test
  public void testNamespaceNotEmpty() throws Exception {
    final String tableInNamespace = namespaceName + ".abcdefg";
    client.createTable(sharedSecret, tableInNamespace, true, TimeType.MILLIS);

    assertThrows(NamespaceNotEmptyException.class,
        () -> client.deleteNamespace(sharedSecret, namespaceName));

    // delete table so namespace can also be deleted
    client.deleteTable(sharedSecret, tableInNamespace);
  }

  @Test
  public void testUnknownScanner() throws TException {
    String scanner = client.createScanner(sharedSecret, tableName, null);
    assertFalse(client.hasNext(scanner));
    client.closeScanner(scanner);

    // @formatter:off
    Stream<Executable> cases = Stream.of(
        () -> client.hasNext(scanner),
        () -> client.closeScanner(scanner),
        () -> client.nextEntry("99999999"),
        () -> client.nextK("99999999", 6),
        () -> client.hasNext("99999999"),
        () -> client.hasNext(UUID.randomUUID().toString())
    );
    // @formatter:on

    cases.forEach(executable -> assertThrows(UnknownScanner.class, executable));
  }

  @Test
  public void testUnknownWriter() throws TException {
    String writer = client.createWriter(sharedSecret, tableName, null);
    client.update(writer, mutation("row0", "cf", "cq", "value"));
    client.flush(writer);
    client.update(writer, mutation("row2", "cf", "cq", "value2"));
    client.closeWriter(writer);

    // this is a oneway call, so it does not throw exceptions
    client.update(writer, mutation("row2", "cf", "cq", "value2"));

    // @formatter:off
    Stream<Executable> cases = Stream.of(
        () -> client.flush(writer),
        () -> client.flush("99999"),
        () -> client.flush(UUID.randomUUID().toString()),
        () -> client.closeWriter("99999")
    );
    // @formatter:on

    cases.forEach(executable -> assertThrows(UnknownWriter.class, executable));
  }

  @Test
  public void testDelete() throws Exception {
    client.updateAndFlush(sharedSecret, tableName, mutation("row0", "cf", "cq", "value"));

    assertScan(new String[][] {{"row0", "cf", "cq", "value"}}, tableName);

    ColumnUpdate upd = new ColumnUpdate(s2bb("cf"), s2bb("cq"));
    upd.setDeleteCell(false);
    Map<ByteBuffer,List<ColumnUpdate>> notDelete =
        Collections.singletonMap(s2bb("row0"), Collections.singletonList(upd));
    client.updateAndFlush(sharedSecret, tableName, notDelete);
    String scanner = client.createScanner(sharedSecret, tableName, null);
    ScanResult entries = client.nextK(scanner, 10);
    client.closeScanner(scanner);
    assertFalse(entries.more);
    assertEquals(1, entries.results.size(), "Results: " + entries.results);

    upd = new ColumnUpdate(s2bb("cf"), s2bb("cq"));
    upd.setDeleteCell(true);
    Map<ByteBuffer,List<ColumnUpdate>> delete =
        Collections.singletonMap(s2bb("row0"), Collections.singletonList(upd));

    client.updateAndFlush(sharedSecret, tableName, delete);

    assertScan(new String[][] {}, tableName);
  }

  @Test
  public void testSystemProperties() throws Exception {
    Map<String,String> cfg = client.getSiteConfiguration(sharedSecret);

    // set generic property
    client.setProperty(sharedSecret, "general.custom.test.systemprop", "whistletips");
    assertEquals(proxyClient.proxy().getSystemConfiguration(sharedSecret)
        .get("general.custom.test.systemprop"), "whistletips");
    client.removeProperty(sharedSecret, "general.custom.test.systemprop");
    assertNull(client.getSystemConfiguration(sharedSecret).get("general.custom.test.systemprop"));

    // set a property in zookeeper
    client.setProperty(sharedSecret, "table.split.threshold", "500M");

    // check that we can read it
    for (int i = 0; i < 5; i++) {
      cfg = client.getSystemConfiguration(sharedSecret);
      if ("500M".equals(cfg.get("table.split.threshold"))) {
        break;
      }
      sleepUninterruptibly(200, TimeUnit.MILLISECONDS);
    }
    assertEquals("500M", cfg.get("table.split.threshold"));

    // unset the setting, check that it's not what it was
    client.removeProperty(sharedSecret, "table.split.threshold");
    for (int i = 0; i < 5; i++) {
      cfg = client.getSystemConfiguration(sharedSecret);
      if (!"500M".equals(cfg.get("table.split.threshold"))) {
        break;
      }
      sleepUninterruptibly(200, TimeUnit.MILLISECONDS);
    }
    assertNotEquals("500M", cfg.get("table.split.threshold"));
  }

  @Test
  public void pingTabletServers() throws Exception {
    int tservers = 0;
    for (String tserver : client.getTabletServers(sharedSecret)) {
      client.pingTabletServer(sharedSecret, tserver);
      tservers++;
    }
    assertTrue(tservers > 0);
  }

  @Test
  public void testSiteConfiguration() throws Exception {
    // get something we know is in the site config
    MiniAccumuloClusterImpl cluster = SharedMiniClusterBase.getCluster();
    Map<String,String> cfg = client.getSiteConfiguration(sharedSecret);
    assertEquals(new File(new URI(cfg.get("instance.volumes"))).getCanonicalPath(),
        cluster.getConfig().getAccumuloDir().getCanonicalPath());
  }

  @Test
  public void testClassLoad() throws Exception {
    // try to load some classes via the proxy
    assertTrue(client.testClassLoad(sharedSecret, DevNull.class.getName(),
        SortedKeyValueIterator.class.getName()));
    assertFalse(
        client.testClassLoad(sharedSecret, "foo.bar", SortedKeyValueIterator.class.getName()));
  }

  @Test
  public void attachIteratorsWithScans() throws Exception {
    if (client.tableExists(sharedSecret, "slow")) {
      client.deleteTable(sharedSecret, "slow");
    }

    // create a table that's very slow, so we can look for scans
    client.createTable(sharedSecret, "slow", true, TimeType.MILLIS);
    IteratorSetting setting = new IteratorSetting(100, "slow", SlowIterator.class.getName(),
        Collections.singletonMap("sleepTime", "250"));
    client.attachIterator(sharedSecret, "slow", setting, EnumSet.allOf(IteratorScope.class));

    // Should take 10 seconds to read every record
    for (int i = 0; i < 40; i++) {
      client.updateAndFlush(sharedSecret, "slow", mutation("row" + i, "cf", "cq", "value"));
    }

    // scan
    Thread t = new Thread(() -> {
      String scanner;
      TestProxyClient proxyClient2 = null;
      try {
        if (isKerberosEnabled()) {
          UserGroupInformation.loginUserFromKeytab(clientPrincipal, clientKeytab.getAbsolutePath());
          proxyClient2 = new TestProxyClient(hostname, proxyPort, factory, proxyPrimary,
              UserGroupInformation.getCurrentUser());
        } else {
          proxyClient2 = new TestProxyClient(hostname, proxyPort, factory);
        }

        Client client2 = proxyClient2.proxy();
        scanner = client2.createScanner(sharedSecret, "slow", null);
        client2.nextK(scanner, 10);
        client2.closeScanner(scanner);
      } catch (Exception e) {
        throw new RuntimeException(e);
      } finally {
        if (proxyClient2 != null) {
          proxyClient2.close();
        }
      }
    });
    t.start();

    // look for the scan many times
    List<ActiveScan> scans = new ArrayList<>();
    for (int i = 0; i < 100 && scans.isEmpty(); i++) {
      for (String tserver : client.getTabletServers(sharedSecret)) {
        List<ActiveScan> scansForServer = client.getActiveScans(sharedSecret, tserver);
        for (ActiveScan scan : scansForServer) {
          if (clientPrincipal.equals(scan.getUser())) {
            scans.add(scan);
          }
        }

        if (!scans.isEmpty()) {
          break;
        }
        sleepUninterruptibly(100, TimeUnit.MILLISECONDS);
      }
    }
    t.join();

    assertFalse(scans.isEmpty(), "Expected to find scans, but found none");
    boolean found = false;
    Map<String,String> map;
    for (int i = 0; i < scans.size() && !found; i++) {
      ActiveScan scan = scans.get(i);
      if (clientPrincipal.equals(scan.getUser())) {
        assertTrue(
            ScanState.RUNNING.equals(scan.getState()) || ScanState.QUEUED.equals(scan.getState()));
        assertEquals(ScanType.SINGLE, scan.getType());
        assertEquals("slow", scan.getTable());

        map = client.tableIdMap(sharedSecret);
        assertEquals(map.get("slow"), scan.getExtent().tableId);
        assertNull(scan.getExtent().endRow);
        assertNull(scan.getExtent().prevEndRow);
        found = true;
      }
    }

    assertTrue(found, "Could not find a scan against the 'slow' table");
  }

  @Test
  public void attachIteratorWithCompactions() throws Exception {
    if (client.tableExists(sharedSecret, "slow")) {
      client.deleteTable(sharedSecret, "slow");
    }

    // create a table that's very slow, so we can look for compactions
    client.createTable(sharedSecret, "slow", true, TimeType.MILLIS);
    IteratorSetting setting = new IteratorSetting(100, "slow", SlowIterator.class.getName(),
        Collections.singletonMap("sleepTime", "250"));
    client.attachIterator(sharedSecret, "slow", setting, EnumSet.allOf(IteratorScope.class));

    // Should take 10 seconds to read every record
    for (int i = 0; i < 40; i++) {
      client.updateAndFlush(sharedSecret, "slow", mutation("row" + i, "cf", "cq", "value"));
    }

    Map<String,String> map = client.tableIdMap(sharedSecret);

    // start a compaction
    Thread t = new Thread(() -> {
      TestProxyClient proxyClient2 = null;
      try {
        if (isKerberosEnabled()) {
          UserGroupInformation.loginUserFromKeytab(clientPrincipal, clientKeytab.getAbsolutePath());
          proxyClient2 = new TestProxyClient(hostname, proxyPort, factory, proxyPrimary,
              UserGroupInformation.getCurrentUser());
        } else {
          proxyClient2 = new TestProxyClient(hostname, proxyPort, factory);
        }
        Client client2 = proxyClient2.proxy();
        client2.compactTable(sharedSecret, "slow", null, null, null, true, true, null, null);
      } catch (Exception e) {
        throw new RuntimeException(e);
      } finally {
        if (proxyClient2 != null) {
          proxyClient2.close();
        }
      }
    });
    t.start();

    final String desiredTableId = map.get("slow");

    // Make sure we can find the slow table
    assertNotNull(desiredTableId);

    // try to catch it in the act
    List<ActiveCompaction> compactions = new ArrayList<>();
    for (int i = 0; i < 100 && compactions.isEmpty(); i++) {
      // Iterate over the tservers
      for (String tserver : client.getTabletServers(sharedSecret)) {
        // And get the compactions on each
        List<ActiveCompaction> compactionsOnServer =
            client.getActiveCompactions(sharedSecret, tserver);
        for (ActiveCompaction compact : compactionsOnServer) {
          // There might be other compactions occurring (e.g. on METADATA) in which
          // case we want to prune out those that aren't for our slow table
          if (desiredTableId.equals(compact.getExtent().tableId)) {
            compactions.add(compact);
          }
        }

        // If we found a compaction for the table we wanted, so we can stop looking
        if (!compactions.isEmpty()) {
          break;
        }
      }
      sleepUninterruptibly(10, TimeUnit.MILLISECONDS);
    }
    t.join();

    // verify the compaction information
    assertFalse(compactions.isEmpty());
    for (ActiveCompaction c : compactions) {
      if (desiredTableId.equals(c.getExtent().tableId)) {
        assertTrue(c.inputFiles.isEmpty());
        assertEquals(CompactionType.MINOR, c.getType());
        assertEquals(CompactionReason.USER, c.getReason());
        assertEquals("", c.localityGroup);
        assertTrue(c.outputFile.contains("default_tablet"));

        return;
      }
    }

    fail("Expection to find running compaction for table 'slow' but did not find one");
  }

  @Test
  public void userAuthentication() throws Exception {
    if (isKerberosEnabled()) {
      assertTrue(client.authenticateUser(sharedSecret, clientPrincipal, Collections.emptyMap()));
      // Can't really authenticate "badly" at the application level w/ kerberos. It's going to fail
      // to even set up
      // an RPC
    } else {
      // check password
      assertTrue(client.authenticateUser(sharedSecret, "root",
          s2pp(SharedMiniClusterBase.getRootPassword())));
      assertFalse(client.authenticateUser(sharedSecret, "otheruser", s2pp("")));
    }
  }

  @Test
  public void userManagement() throws Exception {

    String user;
    ClusterUser otherClient = null;
    ByteBuffer password = s2bb("password");
    if (isKerberosEnabled()) {
      otherClient = getKdc().getClientPrincipal(1);
      user = otherClient.getPrincipal();
    } else {
      user = getUniqueNameArray(1)[0];
    }

    // create a user
    client.createLocalUser(sharedSecret, user, password);
    // change auths
    Set<String> users = client.listLocalUsers(sharedSecret);
    Set<String> expectedUsers = new HashSet<>(List.of(clientPrincipal, user));
    assertTrue(users.containsAll(expectedUsers),
        "Did not find all expected users: " + expectedUsers);
    HashSet<ByteBuffer> auths = new HashSet<>(List.of(s2bb("A"), s2bb("B")));
    client.changeUserAuthorizations(sharedSecret, user, auths);
    List<ByteBuffer> update = client.getUserAuthorizations(sharedSecret, user);
    assertEquals(auths, new HashSet<>(update));

    // change password
    if (!isKerberosEnabled()) {
      password = s2bb("");
      client.changeLocalUserPassword(sharedSecret, user, password);
      assertTrue(
          client.authenticateUser(sharedSecret, user, s2pp(ByteBufferUtil.toString(password))));
    }
  }

  @Test
  public void testBatchWriter() throws Exception {
    client.addConstraint(sharedSecret, tableName, NumericValueConstraint.class.getName());
    // zookeeper propagation time
    sleepUninterruptibly(ZOOKEEPER_PROPAGATION_TIME, TimeUnit.MILLISECONDS);

    // Take the table offline and online to force a config update
    client.offlineTable(sharedSecret, tableName, true);
    client.onlineTable(sharedSecret, tableName, true);

    WriterOptions writerOptions = new WriterOptions();
    writerOptions.setLatencyMs(10000);
    writerOptions.setMaxMemory(2);
    writerOptions.setThreads(1);
    writerOptions.setTimeoutMs(100000);

    assertNumericValueConstraintIsPresent();

    boolean success = false;
    for (int i = 0; i < 15; i++) {
      String batchWriter = client.createWriter(sharedSecret, tableName, writerOptions);
      client.update(batchWriter, mutation("row1", "cf", "cq", "x"));
      client.update(batchWriter, mutation("row1", "cf", "cq", "x"));
      try {
        client.flush(batchWriter);
        log.debug("Constraint failed to fire. Waiting and retrying");
        Thread.sleep(5000);
        continue;
      } catch (MutationsRejectedException ex) {}
      try {
        client.closeWriter(batchWriter);
        log.debug("Constraint failed to fire. Waiting and retrying");
        Thread.sleep(5000);
        continue;
      } catch (MutationsRejectedException e) {}
      success = true;
      break;
    }

    if (!success) {
      fail("constraint did not fire");
    }

    client.removeConstraint(sharedSecret, tableName, 2);

    // Take the table offline and online to force a config update
    client.offlineTable(sharedSecret, tableName, true);
    client.onlineTable(sharedSecret, tableName, true);

    assertNumericValueConstraintIsAbsent();

    assertScan(new String[][] {}, tableName);

    sleepUninterruptibly(ZOOKEEPER_PROPAGATION_TIME, TimeUnit.MILLISECONDS);

    writerOptions = new WriterOptions();
    writerOptions.setLatencyMs(10000);
    writerOptions.setMaxMemory(3000);
    writerOptions.setThreads(1);
    writerOptions.setTimeoutMs(100000);

    success = false;
    for (int i = 0; i < 15; i++) {
      try {
        String batchWriter = client.createWriter(sharedSecret, tableName, writerOptions);

        client.update(batchWriter, mutation("row1", "cf", "cq", "x"));
        client.flush(batchWriter);
        client.closeWriter(batchWriter);
        success = true;
        break;
      } catch (MutationsRejectedException e) {
        log.info("Mutations were rejected, assuming constraint is still active", e);
        Thread.sleep(5000);
      }
    }

    if (!success) {
      fail("Failed to successfully write data after constraint was removed");
    }

    assertScan(new String[][] {{"row1", "cf", "cq", "x"}}, tableName);

    client.deleteTable(sharedSecret, tableName);
  }

  @Test
  public void testTableConstraints() throws Exception {
    log.debug("Setting NumericValueConstraint on table {}", tableName);

    // constraints
    client.addConstraint(sharedSecret, tableName, NumericValueConstraint.class.getName());

    // zookeeper propagation time
    Thread.sleep(ZOOKEEPER_PROPAGATION_TIME);

    // Take the table offline and online to force a config update
    client.offlineTable(sharedSecret, tableName, true);
    client.onlineTable(sharedSecret, tableName, true);

    log.debug("Attempting to verify client-side that constraints are observed");

    assertNumericValueConstraintIsPresent();

    assertEquals(2, client.listConstraints(sharedSecret, tableName).size());
    log.debug("Verified client-side that constraints exist");

    // Write data that satisfies the constraint
    client.updateAndFlush(sharedSecret, tableName, mutation("row1", "cf", "cq", "123"));

    log.debug("Successfully wrote data that satisfies the constraint");
    log.debug("Trying to write data that the constraint should reject");

    // Expect failure on data that fails the constraint
    while (true) {
      try {
        client.updateAndFlush(sharedSecret, tableName, mutation("row1", "cf", "cq", "x"));
        log.debug("Expected mutation to be rejected, but was not. Waiting and retrying");
        Thread.sleep(5000);
      } catch (MutationsRejectedException ex) {
        break;
      }
    }

    log.debug("Saw expected failure on data which fails the constraint");

    log.debug("Removing constraint from table");
    client.removeConstraint(sharedSecret, tableName, 2);

    sleepUninterruptibly(ZOOKEEPER_PROPAGATION_TIME, TimeUnit.MILLISECONDS);

    // Take the table offline and online to force a config update
    client.offlineTable(sharedSecret, tableName, true);
    client.onlineTable(sharedSecret, tableName, true);

    assertNumericValueConstraintIsAbsent();

    assertEquals(1, client.listConstraints(sharedSecret, tableName).size());
    log.debug("Verified client-side that the constraint was removed");

    log.debug("Attempting to write mutation that should succeed after constraints was removed");
    // Make sure we can write the data after we removed the constraint
    while (true) {
      try {
        client.updateAndFlush(sharedSecret, tableName, mutation("row1", "cf", "cq", "x"));
        break;
      } catch (MutationsRejectedException ex) {
        log.debug("Expected mutation accepted, but was not. Waiting and retrying");
        Thread.sleep(5000);
      }
    }

    log.debug("Verifying that record can be read from the table");
    assertScan(new String[][] {{"row1", "cf", "cq", "x"}}, tableName);
  }

  @Test
  public void tableMergesAndSplits() throws Exception {
    // add some splits
    client.addSplits(sharedSecret, tableName,
        new HashSet<>(List.of(s2bb("a"), s2bb("m"), s2bb("z"))));
    List<ByteBuffer> splits = client.listSplits(sharedSecret, tableName, 1);
    assertEquals(List.of(s2bb("m")), splits);

    // Merge some of the splits away
    client.mergeTablets(sharedSecret, tableName, null, s2bb("m"));
    splits = client.listSplits(sharedSecret, tableName, 10);
    assertEquals(List.of(s2bb("m"), s2bb("z")), splits);

    // Merge the entire table
    client.mergeTablets(sharedSecret, tableName, null, null);
    splits = client.listSplits(sharedSecret, tableName, 10);
    List<ByteBuffer> empty = Collections.emptyList();

    // No splits after merge on whole table
    assertEquals(empty, splits);
  }

  @Test
  public void iteratorFunctionality() throws Exception {
    // iterators
    HashMap<String,String> options = new HashMap<>();
    options.put("type", "STRING");
    options.put("columns", "cf");
    IteratorSetting setting =
        new IteratorSetting(10, tableName, SummingCombiner.class.getName(), options);
    client.attachIterator(sharedSecret, tableName, setting, EnumSet.allOf(IteratorScope.class));
    for (int i = 0; i < 10; i++) {
      client.updateAndFlush(sharedSecret, tableName, mutation("row1", "cf", "cq", "1"));
    }
    // 10 updates of "1" in the value w/ SummingCombiner should return value of "10"
    assertScan(new String[][] {{"row1", "cf", "cq", "10"}}, tableName);

    assertThrows(Exception.class, () -> client.checkIteratorConflicts(sharedSecret, tableName,
        setting, EnumSet.allOf(IteratorScope.class)));

    client.deleteRows(sharedSecret, tableName, null, null);
    client.removeIterator(sharedSecret, tableName, "test", EnumSet.allOf(IteratorScope.class));
    String[][] expected = new String[10][];
    for (int i = 0; i < 10; i++) {
      client.updateAndFlush(sharedSecret, tableName, mutation("row" + i, "cf", "cq", "" + i));
      expected[i] = new String[] {"row" + i, "cf", "cq", "" + i};
      client.flushTable(sharedSecret, tableName, null, null, true);
    }
    assertScan(expected, tableName);
  }

  @Test
  public void cloneTable() throws Exception {
    String TABLE_TEST2 = getUniqueNameArray(2)[1];

    String[][] expected = new String[10][];
    for (int i = 0; i < 10; i++) {
      client.updateAndFlush(sharedSecret, tableName, mutation("row" + i, "cf", "cq", "" + i));
      expected[i] = new String[] {"row" + i, "cf", "cq", "" + i};
      client.flushTable(sharedSecret, tableName, null, null, true);
    }
    assertScan(expected, tableName);

    // clone
    client.cloneTable(sharedSecret, tableName, TABLE_TEST2, true, null, null);
    assertScan(expected, TABLE_TEST2);
    client.deleteTable(sharedSecret, TABLE_TEST2);
  }

  @Test
  public void clearLocatorCache() throws Exception {
    // don't know how to test this, call it just for fun
    client.clearLocatorCache(sharedSecret, tableName);
  }

  @Test
  public void compactTable() throws Exception {
    String[][] expected = new String[10][];
    for (int i = 0; i < 10; i++) {
      client.updateAndFlush(sharedSecret, tableName, mutation("row" + i, "cf", "cq", "" + i));
      expected[i] = new String[] {"row" + i, "cf", "cq", "" + i};
      client.flushTable(sharedSecret, tableName, null, null, true);
    }
    assertScan(expected, tableName);

    // compact
    client.compactTable(sharedSecret, tableName, null, null, null, true, true, null, null);
    assertEquals(1, countFiles(tableName));
    assertScan(expected, tableName);
  }

  @Test
  public void diskUsage() throws Exception {
    String TABLE_TEST2 = getUniqueNameArray(2)[1];

    // Write some data
    String[][] expected = new String[10][];
    for (int i = 0; i < 10; i++) {
      client.updateAndFlush(sharedSecret, tableName, mutation("row" + i, "cf", "cq", "" + i));
      expected[i] = new String[] {"row" + i, "cf", "cq", "" + i};
      client.flushTable(sharedSecret, tableName, null, null, true);
    }
    assertScan(expected, tableName);

    // compact
    client.compactTable(sharedSecret, tableName, null, null, null, true, true, null, null);
    assertEquals(1, countFiles(tableName));
    assertScan(expected, tableName);

    // Clone the table
    client.cloneTable(sharedSecret, tableName, TABLE_TEST2, true, null, null);
    Set<String> tablesToScan = new HashSet<>();
    tablesToScan.add(tableName);
    tablesToScan.add(TABLE_TEST2);
    tablesToScan.add("foo");

    client.createTable(sharedSecret, "foo", true, TimeType.MILLIS);

    // get disk usage
    List<DiskUsage> diskUsage = (client.getDiskUsage(sharedSecret, tablesToScan));
    assertEquals(2, diskUsage.size());
    // The original table and the clone are lumped together (they share the same files)
    assertEquals(2, diskUsage.get(0).getTables().size());
    // The empty table we created
    assertEquals(1, diskUsage.get(1).getTables().size());

    // Compact the clone so it writes its own files instead of referring to the original
    client.compactTable(sharedSecret, TABLE_TEST2, null, null, null, true, true, null, null);

    diskUsage = (client.getDiskUsage(sharedSecret, tablesToScan));
    assertEquals(3, diskUsage.size());
    // The original
    assertEquals(1, diskUsage.get(0).getTables().size());
    // The clone w/ its own files now
    assertEquals(1, diskUsage.get(1).getTables().size());
    // The empty table
    assertEquals(1, diskUsage.get(2).getTables().size());
    client.deleteTable(sharedSecret, "foo");
    client.deleteTable(sharedSecret, TABLE_TEST2);
  }

  @Test
  public void importExportTable() throws Exception {
    // Write some data
    String[][] expected = new String[10][];
    for (int i = 0; i < 10; i++) {
      client.updateAndFlush(sharedSecret, tableName, mutation("row" + i, "cf", "cq", "" + i));
      expected[i] = new String[] {"row" + i, "cf", "cq", "" + i};
      client.flushTable(sharedSecret, tableName, null, null, true);
    }
    assertScan(expected, tableName);

    // export/import
    MiniAccumuloClusterImpl cluster = SharedMiniClusterBase.getCluster();
    FileSystem fs = cluster.getFileSystem();
    Path base = cluster.getTemporaryPath();
    Path dir = new Path(base, "test");
    assertTrue(fs.mkdirs(dir));
    Path destDir = new Path(base, "test_dest");
    assertTrue(fs.mkdirs(destDir));
    client.offlineTable(sharedSecret, tableName, false);
    client.exportTable(sharedSecret, tableName, dir.toString());
    // copy files to a new location
    FSDataInputStream is = fs.open(new Path(dir, "distcp.txt"));
    try (BufferedReader r = new BufferedReader(new InputStreamReader(is, UTF_8))) {
      while (true) {
        String line = r.readLine();
        if (line == null) {
          break;
        }
        Path srcPath = new Path(line);
        FileUtil.copy(fs, srcPath, fs, destDir, false, fs.getConf());
      }
    }
    client.deleteTable(sharedSecret, tableName);
    client.importTable(sharedSecret, "testify", destDir.toString());
    assertScan(expected, "testify");
    client.deleteTable(sharedSecret, "testify");

    assertThrows(org.apache.accumulo.proxy.thrift.AccumuloException.class,
        () -> client.importTable(sharedSecret, "testify2", destDir.toString()));

    assertFalse(client.listTables(sharedSecret).contains("testify2"));
  }

  @Test
  public void localityGroups() throws Exception {
    Map<String,Set<String>> groups = new HashMap<>();
    groups.put("group1", Collections.singleton("cf1"));
    groups.put("group2", Collections.singleton("cf2"));
    client.setLocalityGroups(sharedSecret, tableName, groups);
    assertEquals(groups, client.getLocalityGroups(sharedSecret, tableName));
  }

  @Test
  public void tableProperties() throws Exception {
    Map<String,String> systemProps = client.getSystemConfiguration(sharedSecret);
    String systemTableSplitThreshold = systemProps.get("table.split.threshold");

    Map<String,String> orig = client.getTableProperties(sharedSecret, tableName);
    client.setTableProperty(sharedSecret, tableName, "table.split.threshold", "500M");

    // Get the new table property value
    Map<String,String> update = client.getTableProperties(sharedSecret, tableName);
    assertEquals(update.get("table.split.threshold"), "500M");

    // Table level properties shouldn't affect system level values
    assertEquals(systemTableSplitThreshold,
        client.getSystemConfiguration(sharedSecret).get("table.split.threshold"));

    client.removeTableProperty(sharedSecret, tableName, "table.split.threshold");
    update = client.getTableProperties(sharedSecret, tableName);

    var difference = Sets.symmetricDifference(orig.entrySet(), update.entrySet());

    assertTrue(difference.isEmpty(),
        "Properties should have been the same. Found difference: " + difference);
  }

  @Test
  public void tableRenames() throws Exception {
    final String newTableName = "bar";

    Map<String,String> tableIds = client.tableIdMap(sharedSecret);
    final String originalTableID = tableIds.get(tableName);

    client.renameTable(sharedSecret, tableName, newTableName);

    tableIds = client.tableIdMap(sharedSecret);
    final String newTableID = tableIds.get(newTableName);

    assertEquals(originalTableID, newTableID,
        "Table ID should be the same before and after the table has been renamed");

    assertTrue(client.tableExists(sharedSecret, newTableName),
        "Expected to find table with new name");
    assertFalse(client.tableExists(sharedSecret, tableName),
        "Did not expect to find table with original name");

    client.deleteTable(sharedSecret, newTableName);
  }

  @Test
  public void bulkImport() throws Exception {
    MiniAccumuloClusterImpl cluster = SharedMiniClusterBase.getCluster();
    FileSystem fs = cluster.getFileSystem();
    Path base = cluster.getTemporaryPath();
    Path dir = new Path(base, "test");
    assertTrue(fs.mkdirs(dir));

    // Write an RFile
    String filename = dir + "/bulk/import/rfile.rf";
    try (FileSKVWriter writer = FileOperations.getInstance().newWriterBuilder()
        .forFile(filename, fs, fs.getConf(), NoCryptoServiceFactory.NONE)
        .withTableConfiguration(DefaultConfiguration.getInstance()).build()) {
      writer.startDefaultLocalityGroup();
      writer.append(
          new org.apache.accumulo.core.data.Key(new Text("a"), new Text("b"), new Text("c")),
          new Value("value".getBytes(UTF_8)));
    }

    // Create failures directory
    fs.mkdirs(new Path(dir + "/bulk/fail"));

    // Run the bulk import
    client.importDirectory(sharedSecret, tableName, dir + "/bulk/import", dir + "/bulk/fail", true);

    // Make sure we find the data
    String scanner = client.createScanner(sharedSecret, tableName, null);
    ScanResult more = client.nextK(scanner, 100);
    client.closeScanner(scanner);
    assertEquals(1, more.results.size());
    ByteBuffer maxRow = client.getMaxRow(sharedSecret, tableName, null, null, false, null, false);
    assertEquals(s2bb("a"), maxRow);
  }

  @Test
  public void testTableClassLoad() throws Exception {
    assertFalse(client.testTableClassLoad(sharedSecret, tableName, "abc123",
        SortedKeyValueIterator.class.getName()));
    assertTrue(client.testTableClassLoad(sharedSecret, tableName,
        VersioningIterator.class.getName(), SortedKeyValueIterator.class.getName()));
  }

  private Condition newCondition(String cf, String cq) {
    return new Condition(new Column(s2bb(cf), s2bb(cq), s2bb("")));
  }

  private Condition newCondition(String cf, String cq, String val) {
    return newCondition(cf, cq).setValue(s2bb(val));
  }

  private Condition newCondition(String cf, String cq, long ts, String val) {
    return newCondition(cf, cq).setValue(s2bb(val)).setTimestamp(ts);
  }

  private ColumnUpdate newColUpdate(String cf, String cq, String val) {
    return new ColumnUpdate(s2bb(cf), s2bb(cq)).setValue(s2bb(val));
  }

  private ColumnUpdate newColUpdate(String cf, String cq, long ts, String val) {
    return new ColumnUpdate(s2bb(cf), s2bb(cq)).setTimestamp(ts).setValue(s2bb(val));
  }

  private void assertScan(String[][] expected, String table) throws Exception {
    String scid = client.createScanner(sharedSecret, table, new ScanOptions());
    ScanResult keyValues = client.nextK(scid, expected.length + 1);

    assertEquals(expected.length, keyValues.results.size(), "Saw " + keyValues.results);
    assertFalse(keyValues.more);

    for (int i = 0; i < keyValues.results.size(); i++) {
      checkKey(expected[i][0], expected[i][1], expected[i][2], expected[i][3],
          keyValues.results.get(i));
    }

    client.closeScanner(scid);
  }

  @Test
  public void testConditionalWriter() throws Exception {
    log.debug("Adding constraint {} to {}", tableName, NumericValueConstraint.class.getName());
    client.addConstraint(sharedSecret, tableName, NumericValueConstraint.class.getName());
    sleepUninterruptibly(ZOOKEEPER_PROPAGATION_TIME, TimeUnit.MILLISECONDS);

    // Take the table offline and online to force a config update
    client.offlineTable(sharedSecret, tableName, true);
    client.onlineTable(sharedSecret, tableName, true);

    assertNumericValueConstraintIsPresent();

    String cwid =
        client.createConditionalWriter(sharedSecret, tableName, new ConditionalWriterOptions());

    Map<ByteBuffer,ConditionalUpdates> updates = new HashMap<>();

    updates.put(s2bb("00345"), new ConditionalUpdates(List.of(newCondition("meta", "seq")),
        List.of(newColUpdate("meta", "seq", 10, "1"), newColUpdate("data", "img", "73435435"))));

    Map<ByteBuffer,ConditionalStatus> results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.ACCEPTED, results.get(s2bb("00345")));

    assertScan(new String[][] {{"00345", "data", "img", "73435435"}, {"00345", "meta", "seq", "1"}},
        tableName);

    // test not setting values on conditions
    updates.clear();

    updates.put(s2bb("00345"), new ConditionalUpdates(List.of(newCondition("meta", "seq")),
        List.of(newColUpdate("meta", "seq", "2"))));
    updates.put(s2bb("00346"), new ConditionalUpdates(List.of(newCondition("meta", "seq")),
        List.of(newColUpdate("meta", "seq", "1"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(2, results.size());
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00345")));
    assertEquals(ConditionalStatus.ACCEPTED, results.get(s2bb("00346")));

    assertScan(new String[][] {{"00345", "data", "img", "73435435"}, {"00345", "meta", "seq", "1"},
        {"00346", "meta", "seq", "1"}}, tableName);

    // test setting values on conditions
    updates.clear();

    updates.put(s2bb("00345"),
        new ConditionalUpdates(List.of(newCondition("meta", "seq", "1")), Arrays
            .asList(newColUpdate("meta", "seq", 20, "2"), newColUpdate("data", "img", "567890"))));

    updates.put(s2bb("00346"), new ConditionalUpdates(List.of(newCondition("meta", "seq", "2")),
        List.of(newColUpdate("meta", "seq", "3"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(2, results.size());
    assertEquals(ConditionalStatus.ACCEPTED, results.get(s2bb("00345")));
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00346")));

    assertScan(new String[][] {{"00345", "data", "img", "567890"}, {"00345", "meta", "seq", "2"},
        {"00346", "meta", "seq", "1"}}, tableName);

    // test setting timestamp on condition to a nonexistent version
    updates.clear();

    updates.put(s2bb("00345"), new ConditionalUpdates(List.of(newCondition("meta", "seq", 10, "2")),
        List.of(newColUpdate("meta", "seq", 30, "3"), newColUpdate("data", "img", "1234567890"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00345")));

    assertScan(new String[][] {{"00345", "data", "img", "567890"}, {"00345", "meta", "seq", "2"},
        {"00346", "meta", "seq", "1"}}, tableName);

    // test setting timestamp to an existing version

    updates.clear();

    updates.put(s2bb("00345"), new ConditionalUpdates(List.of(newCondition("meta", "seq", 20, "2")),
        List.of(newColUpdate("meta", "seq", 30, "3"), newColUpdate("data", "img", "1234567890"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.ACCEPTED, results.get(s2bb("00345")));

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"}}, tableName);

    // run test w/ condition that has iterators
    // following should fail w/o iterator
    client.updateAndFlush(sharedSecret, tableName,
        Collections.singletonMap(s2bb("00347"), List.of(newColUpdate("data", "count", "1"))));
    client.updateAndFlush(sharedSecret, tableName,
        Collections.singletonMap(s2bb("00347"), List.of(newColUpdate("data", "count", "1"))));
    client.updateAndFlush(sharedSecret, tableName,
        Collections.singletonMap(s2bb("00347"), List.of(newColUpdate("data", "count", "1"))));

    updates.clear();
    updates.put(s2bb("00347"), new ConditionalUpdates(List.of(newCondition("data", "count", "3")),
        List.of(newColUpdate("data", "img", "1234567890"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00347")));

    assertScan(
        new String[][] {{"00345", "data", "img", "1234567890"}, {"00345", "meta", "seq", "3"},
            {"00346", "meta", "seq", "1"}, {"00347", "data", "count", "1"}},
        tableName);

    // following test w/ iterator setup should succeed
    Condition iterCond = newCondition("data", "count", "3");
    Map<String,String> props = new HashMap<>();
    props.put("type", "STRING");
    props.put("columns", "data:count");
    IteratorSetting is = new IteratorSetting(1, "sumc", SummingCombiner.class.getName(), props);
    iterCond.setIterators(List.of(is));

    updates.clear();
    updates.put(s2bb("00347"), new ConditionalUpdates(List.of(iterCond),
        List.of(newColUpdate("data", "img", "1234567890"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.ACCEPTED, results.get(s2bb("00347")));

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"},
        {"00347", "data", "count", "1"}, {"00347", "data", "img", "1234567890"}}, tableName);

    ConditionalStatus status = null;
    for (int i = 0; i < 30; i++) {
      // test a mutation that violated a constraint
      updates.clear();
      updates.put(s2bb("00347"),
          new ConditionalUpdates(List.of(newCondition("data", "img", "1234567890")),
              List.of(newColUpdate("data", "count", "A"))));

      results = client.updateRowsConditionally(cwid, updates);

      assertEquals(1, results.size());
      status = results.get(s2bb("00347"));
      if (status != ConditionalStatus.VIOLATED) {
        log.info("ConditionalUpdate was not rejected by server due to table"
            + " constraint. Sleeping and retrying");
        Thread.sleep(5000);
        continue;
      }

      assertEquals(ConditionalStatus.VIOLATED, status);
      break;
    }

    // Final check to make sure we succeeded and didn't exceed the retries
    assertEquals(ConditionalStatus.VIOLATED, status);

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"},
        {"00347", "data", "count", "1"}, {"00347", "data", "img", "1234567890"}}, tableName);

    // run test with two conditions
    // both conditions should fail
    updates.clear();
    updates.put(s2bb("00347"), new ConditionalUpdates(
        List.of(newCondition("data", "img", "565"), newCondition("data", "count", "2")),
        List.of(newColUpdate("data", "count", "3"), newColUpdate("data", "img", "0987654321"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00347")));

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"},
        {"00347", "data", "count", "1"}, {"00347", "data", "img", "1234567890"}}, tableName);

    // one condition should fail
    updates.clear();
    updates.put(s2bb("00347"), new ConditionalUpdates(
        List.of(newCondition("data", "img", "1234567890"), newCondition("data", "count", "2")),
        List.of(newColUpdate("data", "count", "3"), newColUpdate("data", "img", "0987654321"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00347")));

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"},
        {"00347", "data", "count", "1"}, {"00347", "data", "img", "1234567890"}}, tableName);

    // one condition should fail
    updates.clear();
    updates.put(s2bb("00347"), new ConditionalUpdates(
        List.of(newCondition("data", "img", "565"), newCondition("data", "count", "1")),
        List.of(newColUpdate("data", "count", "3"), newColUpdate("data", "img", "0987654321"))));

    results = client.updateRowsConditionally(cwid, updates);

    assertEquals(1, results.size());
    assertEquals(ConditionalStatus.REJECTED, results.get(s2bb("00347")));

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"},
        {"00347", "data", "count", "1"}, {"00347", "data", "img", "1234567890"}}, tableName);

    // both conditions should succeed

    ConditionalStatus result = client.updateRowConditionally(sharedSecret, tableName, s2bb("00347"),
        new ConditionalUpdates(
            List.of(newCondition("data", "img", "1234567890"), newCondition("data", "count", "1")),
            List.of(newColUpdate("data", "count", "3"),
                newColUpdate("data", "img", "0987654321"))));

    assertEquals(ConditionalStatus.ACCEPTED, result);

    assertScan(new String[][] {{"00345", "data", "img", "1234567890"},
        {"00345", "meta", "seq", "3"}, {"00346", "meta", "seq", "1"},
        {"00347", "data", "count", "3"}, {"00347", "data", "img", "0987654321"}}, tableName);

    client.closeConditionalWriter(cwid);
    assertThrows(UnknownWriter.class, () -> client.updateRowsConditionally(cwid, updates),
        "conditional writer not closed");
  }

  private void assertNumericValueConstraintIsPresent() throws Exception {
    assertTrue(
        Wait.waitFor(() -> client.listConstraints(sharedSecret, tableName)
            .containsKey(NumericValueConstraint.class.getName()), 30_000L, 2_000L),
        "Expected to find NumericValueConstraint in constraints.");
  }

  private void assertNumericValueConstraintIsAbsent() throws Exception {
    assertTrue(
        Wait.waitFor(() -> !client.listConstraints(sharedSecret, tableName)
            .containsKey(NumericValueConstraint.class.getName()), 30_000L, 2_000L),
        "Found NumericValueConstraint in constraints, expected it to be absent.");
  }

  private void checkKey(String row, String cf, String cq, String val, KeyValue keyValue) {
    assertEquals(row, ByteBufferUtil.toString(keyValue.key.row));
    assertEquals(cf, ByteBufferUtil.toString(keyValue.key.colFamily));
    assertEquals(cq, ByteBufferUtil.toString(keyValue.key.colQualifier));
    assertEquals("", ByteBufferUtil.toString(keyValue.key.colVisibility));
    assertEquals(val, ByteBufferUtil.toString(keyValue.value));
  }

  // scan metadata for file entries for the given table
  private int countFiles(String table) throws Exception {
    Map<String,String> tableIdMap = client.tableIdMap(sharedSecret);
    String tableId = tableIdMap.get(table);
    Key start = new Key();
    start.row = s2bb(tableId + ";");
    Key end = new Key();
    end.row = s2bb(tableId + "<");
    end = client.getFollowing(end, PartialKey.ROW);
    ScanOptions opt = new ScanOptions();
    opt.range = new Range(start, true, end, false);
    opt.columns = Collections.singletonList(new ScanColumn(s2bb("file")));
    String scanner = client.createScanner(sharedSecret, MetadataTable.NAME, opt);
    int result = 0;
    while (true) {
      ScanResult more = client.nextK(scanner, 100);
      result += more.getResults().size();
      if (!more.more) {
        break;
      }
    }
    client.closeScanner(scanner);
    return result;
  }

  private Map<ByteBuffer,List<ColumnUpdate>> mutation(String row, String cf, String cq,
      String value) {
    ColumnUpdate upd = new ColumnUpdate(s2bb(cf), s2bb(cq));
    upd.setValue(value.getBytes(UTF_8));
    return Collections.singletonMap(s2bb(row), Collections.singletonList(upd));
  }

  private ByteBuffer s2bb(String cf) {
    return ByteBuffer.wrap(cf.getBytes(UTF_8));
  }

  private Map<String,String> s2pp(String cf) {
    return Map.of("password", cf);
  }

  private static ByteBuffer t2bb(Text t) {
    return ByteBuffer.wrap(t.getBytes());
  }

  @Test
  public void testGetRowRange() throws Exception {
    Range range = client.getRowRange(s2bb("xyzzy"));
    org.apache.accumulo.core.data.Range range2 =
        new org.apache.accumulo.core.data.Range(new Text("xyzzy"));
    assertEquals(0, range.start.row.compareTo(t2bb(range2.getStartKey().getRow())));
    assertEquals(0, range.stop.row.compareTo(t2bb(range2.getEndKey().getRow())));
    assertEquals(range.startInclusive, range2.isStartKeyInclusive());
    assertEquals(range.stopInclusive, range2.isEndKeyInclusive());
    assertEquals(0, range.start.colFamily.compareTo(t2bb(range2.getStartKey().getColumnFamily())));
    assertEquals(0,
        range.start.colQualifier.compareTo(t2bb(range2.getStartKey().getColumnQualifier())));
    assertEquals(0, range.stop.colFamily.compareTo(t2bb(range2.getEndKey().getColumnFamily())));
    assertEquals(0,
        range.stop.colQualifier.compareTo(t2bb(range2.getEndKey().getColumnQualifier())));
    assertEquals(range.start.timestamp, range.start.timestamp);
    assertEquals(range.stop.timestamp, range.stop.timestamp);
  }

  private void addFile(String tableName, int startRow, int endRow, boolean delete)
      throws TException {
    Map<ByteBuffer,List<ColumnUpdate>> mutation = new HashMap<>();

    for (int i = startRow; i < endRow; i++) {
      String row = String.format("%09d", i);
      ColumnUpdate columnUpdate = newColUpdate("cf", "cq", "v" + i);
      columnUpdate.setDeleteCell(delete);
      mutation.put(s2bb(row), List.of(columnUpdate));
    }

    client.updateAndFlush(sharedSecret, tableName, mutation);
    client.flushTable(sharedSecret, tableName, null, null, true);
  }

  @Test
  public void testCompactionSelector() throws Exception {

    // delete table so new tables won't have the same name
    client.deleteTable(sharedSecret, tableName);

    final String[] tableNames = getUniqueNameArray(3);

    // for each table, set the summarizer property needed for TooManyDeletesSelector
    final String summarizerKey = Property.TABLE_SUMMARIZER_PREFIX + "s1";
    final String summarizerClassName = DeletesSummarizer.class.getName();

    for (String tableName : tableNames) {
      client.createTable(sharedSecret, tableName, true, TimeType.MILLIS);
      client.setTableProperty(sharedSecret, tableName, summarizerKey, summarizerClassName);
    }

    // add files to each table

    addFile(tableNames[0], 1, 1000, false);
    addFile(tableNames[0], 1, 1000, true);

    addFile(tableNames[1], 1, 1000, false);
    addFile(tableNames[1], 1000, 2000, false);

    addFile(tableNames[2], 1, 2000, false);
    addFile(tableNames[2], 1, 1000, true);

    final String messagePrefix = "Unexpected file count on table ";

    for (String tableName : tableNames) {
      assertEquals(2, countFiles(tableName), messagePrefix + tableName);
    }

    // compact the tables and check for expected file counts

    final String selectorClassname = TooManyDeletesSelector.class.getName();
    PluginConfig selector = new PluginConfig(selectorClassname, Map.of("threshold", ".99"));

    for (String tableName : tableNames) {
      client.compactTable(sharedSecret, tableName, null, null, null, true, true, selector, null);
    }

    assertEquals(0, countFiles(tableNames[0]), messagePrefix + tableNames[0]);
    assertEquals(2, countFiles(tableNames[1]), messagePrefix + tableNames[1]);
    assertEquals(2, countFiles(tableNames[2]), messagePrefix + tableNames[2]);

    // create a selector with different properties then compact and check file counts

    selector = new PluginConfig(selectorClassname, Map.of("threshold", ".40"));

    for (String tableName : tableNames) {
      client.compactTable(sharedSecret, tableName, null, null, null, true, true, selector, null);
    }

    assertEquals(0, countFiles(tableNames[0]), messagePrefix + tableNames[0]);
    assertEquals(2, countFiles(tableNames[1]), messagePrefix + tableNames[1]);
    assertEquals(1, countFiles(tableNames[2]), messagePrefix + tableNames[2]);

    client.compactTable(sharedSecret, tableNames[1], null, null, null, true, true, null, null);

    assertEquals(1, countFiles(tableNames[1]), messagePrefix + tableNames[2]);
  }

  @Test
  public void namespaceOperations() throws Exception {
    // default namespace and accumulo namespace
    assertEquals(client.systemNamespace(), Namespace.ACCUMULO.name(), "System namespace is wrong");
    assertEquals(client.defaultNamespace(), Namespace.DEFAULT.name(), "Default namespace is wrong");

    // namespace existence and namespace listing
    assertTrue(client.namespaceExists(sharedSecret, namespaceName),
        "Namespace created during setup should exist");
    assertTrue(client.listNamespaces(sharedSecret).contains(namespaceName),
        "Namespace listing should contain namespace created during setup");

    // create new namespace
    String newNamespace = "foobar";
    client.createNamespace(sharedSecret, newNamespace);

    assertTrue(client.namespaceExists(sharedSecret, newNamespace),
        "Namespace just created should exist");
    assertTrue(client.listNamespaces(sharedSecret).contains(newNamespace),
        "Namespace listing should contain just created");

    // rename the namespace
    String renamedNamespace = "foobar_renamed";
    client.renameNamespace(sharedSecret, newNamespace, renamedNamespace);

    assertTrue(client.namespaceExists(sharedSecret, renamedNamespace),
        "Renamed namespace should exist");
    assertTrue(client.listNamespaces(sharedSecret).contains(renamedNamespace),
        "Namespace listing should contain renamed namespace");

    assertFalse(client.namespaceExists(sharedSecret, newNamespace),
        "Original namespace should no longer exist");
    assertFalse(client.listNamespaces(sharedSecret).contains(newNamespace),
        "Namespace listing should no longer contain original namespace");

    // delete the namespace
    client.deleteNamespace(sharedSecret, renamedNamespace);
    assertFalse(client.namespaceExists(sharedSecret, renamedNamespace),
        "Renamed namespace should no longer exist");
    assertFalse(client.listNamespaces(sharedSecret).contains(renamedNamespace),
        "Namespace listing should no longer contain renamed namespace");

    // namespace properties
    Map<String,String> cfg = client.getNamespaceProperties(sharedSecret, namespaceName);
    String defaultProp = cfg.get("table.compaction.major.ratio");
    assertNotEquals(defaultProp, "10"); // let's make sure we are setting this value to something
                                        // different than default...
    client.setNamespaceProperty(sharedSecret, namespaceName, "table.compaction.major.ratio", "10");
    for (int i = 0; i < 5; i++) {
      cfg = client.getNamespaceProperties(sharedSecret, namespaceName);
      if ("10".equals(cfg.get("table.compaction.major.ratio"))) {
        break;
      }
      sleepUninterruptibly(200, TimeUnit.MILLISECONDS);
    }
    assertTrue(
        client.getNamespaceProperties(sharedSecret, namespaceName)
            .containsKey("table.compaction.major.ratio"),
        "Namespace should contain table.compaction.major.ratio property");
    assertEquals(
        client.getNamespaceProperties(sharedSecret, namespaceName)
            .get("table.compaction.major.ratio"),
        "10", "Namespace property table.compaction.major.ratio property should equal 10");
    client.removeNamespaceProperty(sharedSecret, namespaceName, "table.compaction.major.ratio");
    for (int i = 0; i < 5; i++) {
      cfg = client.getNamespaceProperties(sharedSecret, namespaceName);
      if (!defaultProp.equals(cfg.get("table.compaction.major.ratio"))) {
        break;
      }
      sleepUninterruptibly(200, TimeUnit.MILLISECONDS);
    }
    assertEquals(defaultProp, cfg.get("table.compaction.major.ratio"),
        "Namespace should have default value for table.compaction.major.ratio");

    // namespace ID map
    assertTrue(client.namespaceIdMap(sharedSecret).containsKey("accumulo"),
        "Namespace ID map should contain accumulo");
    assertTrue(client.namespaceIdMap(sharedSecret).containsKey(namespaceName),
        "Namespace ID map should contain namespace created during setup");

    // namespace iterators
    IteratorSetting setting = new IteratorSetting(100, "DebugTheThings",
        DebugIterator.class.getName(), Collections.emptyMap());
    client.attachNamespaceIterator(sharedSecret, namespaceName, setting,
        EnumSet.of(IteratorScope.SCAN));
    assertEquals(setting, client.getNamespaceIteratorSetting(sharedSecret, namespaceName,
        "DebugTheThings", IteratorScope.SCAN), "Wrong iterator setting returned");
    assertTrue(
        client.listNamespaceIterators(sharedSecret, namespaceName).containsKey("DebugTheThings"),
        "Namespace iterator settings should contain iterator just added");
    assertEquals(EnumSet.of(IteratorScope.SCAN),
        client.listNamespaceIterators(sharedSecret, namespaceName).get("DebugTheThings"),
        "Namespace iterator listing should contain iterator scope just added");
    client.checkNamespaceIteratorConflicts(sharedSecret, namespaceName, setting,
        EnumSet.of(IteratorScope.MAJC));
    client.removeNamespaceIterator(sharedSecret, namespaceName, "DebugTheThings",
        EnumSet.of(IteratorScope.SCAN));
    assertFalse(
        client.listNamespaceIterators(sharedSecret, namespaceName).containsKey("DebugTheThings"),
        "Namespace iterator settings should contain iterator just added");

    // namespace constraints
    int id =
        client.addNamespaceConstraint(sharedSecret, namespaceName, MaxMutationSize.class.getName());
    assertTrue(
        client.listNamespaceConstraints(sharedSecret, namespaceName)
            .containsKey(MaxMutationSize.class.getName()),
        "Namespace should contain max mutation size constraint");
    assertEquals(id,
        (int) client.listNamespaceConstraints(sharedSecret, namespaceName)
            .get(MaxMutationSize.class.getName()),
        "Namespace max mutation size constraint id is wrong");
    client.removeNamespaceConstraint(sharedSecret, namespaceName, id);
    assertFalse(
        client.listNamespaceConstraints(sharedSecret, namespaceName)
            .containsKey(MaxMutationSize.class.getName()),
        "Namespace should no longer contain max mutation size constraint");

    // namespace class load
    assertTrue(client.testNamespaceClassLoad(sharedSecret, namespaceName,
        DebugIterator.class.getName(), SortedKeyValueIterator.class.getName()),
        "Namespace class load should work");
    assertFalse(client.testNamespaceClassLoad(sharedSecret, namespaceName, "foo.bar",
        SortedKeyValueIterator.class.getName()), "Namespace class load should not work");
  }
}
