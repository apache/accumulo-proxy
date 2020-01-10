<!--
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# Java client

After initiating a connection to the Proxy (see Apache Thrift's documentation for examples
of connecting to a Thrift service), the methods on the proxy client will be available. The
first thing to do is log in:

```java
Map password = new HashMap<String,String>();
password.put("password", "secret");
ByteBuffer token = client.login("root", password);
```

Once logged in, the token returned will be used for most subsequent calls to the client.
Let's create a table, add some data, scan the table, and delete it.

First, create a table.

```java
client.createTable(token, "myTable", true, TimeType.MILLIS);
```

Next, add some data:

```java
// first, create a writer on the server
String writer = client.createWriter(token, "myTable", new WriterOptions());

//rowid
ByteBuffer rowid = ByteBuffer.wrap("UUID".getBytes());

//mutation like class
ColumnUpdate cu = new ColumnUpdate();
cu.setColFamily("MyFamily".getBytes());
cu.setColQualifier("MyQualifier".getBytes());
cu.setColVisibility("VisLabel".getBytes());
cu.setValue("Some Value.".getBytes());

List<ColumnUpdate> updates = new ArrayList<ColumnUpdate>();
updates.add(cu);

// build column updates
Map<ByteBuffer, List<ColumnUpdate>> cellsToUpdate = new HashMap<ByteBuffer, List<ColumnUpdate>>();
cellsToUpdate.put(rowid, updates);

// send updates to the server
client.updateAndFlush(writer, "myTable", cellsToUpdate);

client.closeWriter(writer);
```

Scan for the data and batch the return of the results on the server:

```java
String scanner = client.createScanner(token, "myTable", new ScanOptions());
ScanResult results = client.nextK(scanner, 100);

for(KeyValue keyValue : results.getResultsIterator()) {
  // do something with results
}

client.closeScanner(scanner);
```

