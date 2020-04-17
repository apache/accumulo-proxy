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

# accumulo-proxy-docker

A temporary guide on how to run this up in Docker.

## Build the image using
Invoke the docker build command to create a container image.
```commandline
docker build -t accumulo-proxy:latest .
```

## Default Configuration
By default, the container image expects the following to be true:
1. Your accumulo instance is named "myinstance"
2. Your zookeeper is available (and reachable from the container) at localhost:2181

## Custom proxy.properties
If you wish to create advanced proxy.properties configuration changes, you should look to volume mount these in when you invoke the `docker run` command, an example is:
```commandline
docker run --rm -d -p 42424:42424 -v /path/to/proxy.properties:/opt/accumulo-proxy/conf/proxy.properties --add-host"FQDN:IP" --name accumulo-proxy accumulo-proxy:latest
```

## Accumulo Instance Configuration
In order for Thrift to communicate with the Accumulo instance you will need to provide the container with the FQDN and IP of the Accumulo instance and its relevant servers (e.g. tservers) to allow it to resolve the required DNS.

If you are running an Accumulo instance with more than one tserver you should add each tserver's entry with a new `--add-host "FQDN:IP"` entry.

```commandline
docker run --rm -d -p 42424:42424 --add-host "FQDN:IP" --name accumulo-proxy accumulo-proxy:latest
```

If you run your Accumulo instance inside a container you can link the containers together using the legacy `--link` approach or place them in the same network ([see official docs](https://docs.docker.com/network/links/))

Cleanup using:
```commandline
docker stop accumulo-proxy;
```