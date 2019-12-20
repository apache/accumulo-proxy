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

[Apache Accumulo][accumulo] Proxy
--
[![Build Status][ti]][tl] [![Maven Central][mi]][ml] [![Javadoc][ji]][jl] [![Apache License][li]][ll]

This application acts as an Apache Accumulo Java client, and exposes its API as
an Apache [Thrift] service so that users can use their preferred programming
language to communicate with Accumulo (provided that language has a supported
Thrift language binding).

# Running the Accumulo proxy

1. Build the proxy tarball and install it.

    ```
    cd /path/to/accumulo-proxy
    mvn clean package -Ptarball
    tar xzvf ./target/accumulo-proxy-2.0.0-SNAPSHOT-bin.tar.gz -C /path/to/install
    ```

2. Edit `proxy.properties` and run the proxy.

    ```
    cd /path/to/install/accumulo-proxy-2.0.0-SNAPSHOT
    ./bin/accumulo-proxy -p conf/proxy.properties
    ```

# Build language specific bindings

Bindings have been built in `src/main/` for Java, Python, and Ruby.

Bindings for other languages can be built using the Thrift compiler. Follow the [Thrift tutorial]
to install a Thrift compiler and use the following command to generate language bindings.

```
thrift -r --gen <language> <Thrift filename>
```

# Create an Accumulo client using Python

Run the commands below to install the Python bindings and create an example Python client:

```bash
mkdir accumulo-client/
cd accumulo-client/
pipenv --python 2.7
pipenv install thrift
pipenv install -e /path/to/accumulo-proxy/src/main/python
cp /path/to/accumulo-proxy/src/main/python/basic_client.py .
# Edit credentials if needed
vim basic_client.py
pipenv run python2 basic_client.py
```

# Create an Accumulo client using Ruby

Run the command below to create an example Ruby client:

```bash
mkdir accumulo-client/
cd accumulo-client/
cp /path/to/accumulo-proxy/src/main/ruby/Gemfile .
vim Gemfile # Set correct path
cp /path/to/accumulo-proxy/src/main/ruby/client.rb .
gem install bundler
bundle install
bundle exec client.rb
```

# Java clients to Proxy

[Java clients] to the Proxy can be written to limit access to the cluster. The proxy can be placed
on a server in the cluster and clients can communicate with proxy from outside of the cluster.

[Java clients]: docs/java_client.md
[accumulo]: https://accumulo.apache.org
[Thrift]: https://thrift.apache.org
[Thrift tutorial]: https://thrift.apache.org/tutorial/
[li]: https://img.shields.io/badge/license-ASL-blue.svg
[ll]: https://www.apache.org/licenses/LICENSE-2.0
[mi]: https://maven-badges.herokuapp.com/maven-central/org.apache.accumulo/accumulo-proxy/badge.svg
[ml]: https://maven-badges.herokuapp.com/maven-central/org.apache.accumulo/accumulo-proxy/
[ji]: https://www.javadoc.io/badge/org.apache.accumulo/accumulo-proxy.svg
[jl]: https://www.javadoc.io/doc/org.apache.accumulo/accumulo-proxy
[ti]: https://travis-ci.org/apache/accumulo-proxy.svg?branch=master
[tl]: https://travis-ci.org/apache/accumulo-proxy
