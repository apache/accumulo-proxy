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

import static org.apache.accumulo.core.util.UtilWaitThread.sleepUninterruptibly;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.file.Files;
import java.time.Duration;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;
import java.util.concurrent.TimeUnit;

import org.apache.accumulo.core.client.Accumulo;
import org.apache.accumulo.core.client.AccumuloClient;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import org.apache.accumulo.core.conf.ClientProperty;
import org.apache.accumulo.core.conf.Property;
import org.apache.accumulo.core.security.Authorizations;
import org.apache.accumulo.core.util.HostAndPort;
import org.apache.accumulo.minicluster.ServerType;
import org.apache.accumulo.miniclusterImpl.MiniAccumuloConfigImpl;
import org.apache.accumulo.miniclusterImpl.ProcessReference;
import org.apache.accumulo.proxy.Proxy;
import org.apache.accumulo.proxy.thrift.AccumuloProxy.Client;
import org.apache.accumulo.proxy.thrift.Column;
import org.apache.accumulo.proxy.thrift.ColumnUpdate;
import org.apache.accumulo.proxy.thrift.Condition;
import org.apache.accumulo.proxy.thrift.ConditionalStatus;
import org.apache.accumulo.proxy.thrift.ConditionalUpdates;
import org.apache.accumulo.proxy.thrift.ConditionalWriterOptions;
import org.apache.accumulo.proxy.thrift.Durability;
import org.apache.accumulo.proxy.thrift.TimeType;
import org.apache.accumulo.proxy.thrift.WriterOptions;
import org.apache.accumulo.server.util.PortUtils;
import org.apache.accumulo.test.functional.ConfigurableMacBase;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.RawLocalFileSystem;
import org.apache.thrift.protocol.TJSONProtocol;
import org.apache.thrift.server.TServer;
import org.junit.jupiter.api.Test;

import com.google.common.collect.Iterators;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;

public class ProxyDurabilityIT extends ConfigurableMacBase {

  @Override
  protected Duration defaultTimeout() {
    return Duration.ofMinutes(2);
  }

  @Override
  public void configure(MiniAccumuloConfigImpl cfg, Configuration hadoopCoreSite) {
    hadoopCoreSite.set("fs.file.impl", RawLocalFileSystem.class.getName());
    cfg.setProperty(Property.TSERV_NATIVEMAP_ENABLED, "false");
    cfg.setClientProperty(ClientProperty.INSTANCE_ZOOKEEPERS_TIMEOUT, "15s");
    cfg.setProperty(Property.INSTANCE_ZK_TIMEOUT, "15s");
    cfg.setNumTservers(1);
  }

  @SuppressFBWarnings(value = {"DM_DEFAULT_ENCODING"},
      justification = "no check needed on encoding")
  private static ByteBuffer bytes(String value) {
    return ByteBuffer.wrap(value.getBytes());
  }

  @SuppressFBWarnings(value = {"HARD_CODE_PASSWORD", "DM_DEFAULT_ENCODING"},
      justification = "test password is okay and no check needed on encoding")
  @Test
  public void testDurability() throws Exception {
    try (AccumuloClient c = Accumulo.newClient().from(getClientProperties()).build()) {
      Properties proxyProps = new Properties();
      // Avoid issues with locally installed client configuration files with custom properties
      File emptyFile = Files.createTempFile(null, null).toFile();
      emptyFile.deleteOnExit();
      proxyProps.put("tokenClass", PasswordToken.class.getName());
      proxyProps.putAll(getClientProperties());

      String sharedSecret = "superSecret";

      proxyProps.put("sharedSecret", sharedSecret);

      TJSONProtocol.Factory protocol = new TJSONProtocol.Factory();

      int proxyPort = PortUtils.getRandomFreePort();
      final TServer proxyServer =
          Proxy.createProxyServer(HostAndPort.fromParts("localhost", proxyPort), protocol,
              proxyProps).server;
      while (!proxyServer.isServing()) {
        sleepUninterruptibly(100, TimeUnit.MILLISECONDS);
      }
      try (var proxyClient = new TestProxyClient("localhost", proxyPort, protocol)) {
        Client client = proxyClient.proxy();
        String tableName = getUniqueNames(1)[0];
        client.createTable(sharedSecret, tableName, true, TimeType.MILLIS);
        assertTrue(c.tableOperations().exists(tableName));

        WriterOptions options = new WriterOptions();
        options.setDurability(Durability.NONE);
        String writer = client.createWriter(sharedSecret, tableName, options);
        Map<ByteBuffer,List<ColumnUpdate>> cells = new TreeMap<>();
        ColumnUpdate column = new ColumnUpdate(bytes("cf"), bytes("cq"));
        column.setValue("value".getBytes());
        cells.put(bytes("row"), Collections.singletonList(column));
        client.update(writer, cells);
        client.closeWriter(writer);
        assertEquals(1, count(c, tableName));
        restartTServer();
        assertEquals(0, count(c, tableName));

        ConditionalWriterOptions cfg = new ConditionalWriterOptions();
        cfg.setDurability(Durability.SYNC);
        String cwriter = client.createConditionalWriter(sharedSecret, tableName, cfg);
        ConditionalUpdates updates = new ConditionalUpdates();
        updates.addToConditions(new Condition(new Column(bytes("cf"), bytes("cq"), bytes(""))));
        updates.addToUpdates(column);
        Map<ByteBuffer,ConditionalStatus> status = client.updateRowsConditionally(cwriter,
            Collections.singletonMap(bytes("row"), updates));
        assertEquals(ConditionalStatus.ACCEPTED, status.get(bytes("row")));
        assertEquals(1, count(c, tableName));
        restartTServer();
        assertEquals(1, count(c, tableName));

      } finally {
        proxyServer.stop();
      }
    }
  }

  private void restartTServer() throws Exception {
    for (ProcessReference proc : cluster.getProcesses().get(ServerType.TABLET_SERVER)) {
      cluster.killProcess(ServerType.TABLET_SERVER, proc);
    }
    cluster.start();
  }

  private int count(AccumuloClient client, String tableName) throws Exception {
    return Iterators.size((client.createScanner(tableName, Authorizations.EMPTY)).iterator());
  }

}
