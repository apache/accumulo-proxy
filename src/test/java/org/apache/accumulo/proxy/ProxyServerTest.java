/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.accumulo.proxy;

import static org.junit.jupiter.api.Assertions.assertThrows;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.accumulo.core.client.BatchWriter;
import org.apache.accumulo.core.client.MutationsRejectedException;
import org.apache.accumulo.proxy.ProxyServer.BatchWriterPlusProblem;
import org.apache.accumulo.proxy.thrift.ColumnUpdate;
import org.apache.accumulo.proxy.thrift.WriterOptions;
import org.easymock.EasyMock;
import org.junit.jupiter.api.Test;

public class ProxyServerTest {

  @Test
  public void updateAndFlushClosesWriterOnExceptionFromAddCells() throws Exception {
    ProxyServer server = EasyMock.createMockBuilder(ProxyServer.class)
        .addMockedMethod("getWriter", String.class, String.class, WriterOptions.class)
        .addMockedMethod("addCellsToWriter", Map.class, BatchWriterPlusProblem.class).createMock();
    BatchWriter writer = EasyMock.createMock(BatchWriter.class);
    BatchWriterPlusProblem bwpe = new BatchWriterPlusProblem();
    bwpe.writer = writer;
    MutationsRejectedException mre = EasyMock.createMock(MutationsRejectedException.class);

    final String sharedSecret = "proxy_secret";
    final String tableName = "table1";
    final Map<ByteBuffer,List<ColumnUpdate>> cells = new HashMap<>();

    EasyMock.expect(server.getWriter(sharedSecret, tableName, null)).andReturn(bwpe);
    server.addCellsToWriter(cells, bwpe);
    EasyMock.expectLastCall();

    // Set the exception
    bwpe.exception = mre;

    writer.close();
    EasyMock.expectLastCall();

    EasyMock.replay(server, writer, mre);

    assertThrows(org.apache.accumulo.proxy.thrift.MutationsRejectedException.class,
        () -> server.updateAndFlush(sharedSecret, tableName, cells));

    EasyMock.verify(server, writer, mre);
  }

  @Test
  public void updateAndFlushClosesWriterOnExceptionFromFlush() throws Exception {
    ProxyServer server = EasyMock.createMockBuilder(ProxyServer.class)
        .addMockedMethod("getWriter", String.class, String.class, WriterOptions.class)
        .addMockedMethod("addCellsToWriter", Map.class, BatchWriterPlusProblem.class).createMock();
    BatchWriter writer = EasyMock.createMock(BatchWriter.class);
    BatchWriterPlusProblem bwpe = new BatchWriterPlusProblem();
    bwpe.writer = writer;
    MutationsRejectedException mre = EasyMock.createMock(MutationsRejectedException.class);

    final String sharedSecret = "proxy_secret";
    final String tableName = "table1";
    final Map<ByteBuffer,List<ColumnUpdate>> cells = new HashMap<>();

    EasyMock.expect(server.getWriter(sharedSecret, tableName, null)).andReturn(bwpe);
    server.addCellsToWriter(cells, bwpe);
    EasyMock.expectLastCall();

    // No exception throw adding the cells
    bwpe.exception = null;

    writer.flush();
    EasyMock.expectLastCall().andThrow(mre);

    writer.close();
    EasyMock.expectLastCall();

    EasyMock.replay(server, writer, mre);

    assertThrows(org.apache.accumulo.proxy.thrift.MutationsRejectedException.class,
        () -> server.updateAndFlush(sharedSecret, tableName, cells));

    EasyMock.verify(server, writer, mre);
  }

}
