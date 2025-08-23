<!--

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

-->

# accumulo-proxy-docker
This documentation covers how to stand up [accumulo-proxy](https://github.com/apache/accumulo-proxy/) within a Docker container.
 
The guide covers:
* Building the image
* Configuring the `proxy.properties` file
* Selecting an appropriate networking choice
* Starting and stopping the container
* Basic troubleshooting tips 

It is not recommended using this guide for a production instance of accumulo-proxy at this time.

## Build the image
Firstly you will need the tarball of accumulo-proxy, this is documented in the [README.md](README.md) but for simplicity run:
```commandline
mvn clean package -Ptarball
```

Once you have the tarball (should be in ./target/ folder) then invoke the Docker build command to create a container image.
```commandline
docker build -t accumulo-proxy:latest .
```

## Default Configuration and Quickstart
By default, the container image expects the following to be true:
1. Your Accumulo instance name is "myinstance"
2. Your ZooKeeper is available (and reachable from the container) at localhost:2181

You can start the proxy using:
```commandline
docker run --rm -d -p 42424:42424 --network="host" --name accumulo-proxy accumulo-proxy:latest;
```

## Custom proxy.properties
If you wish to create advanced proxy.properties configuration changes, you should look to volume mount these in when you invoke the `docker run` command, an example is:
```commandline
docker run --rm -d -p 42424:42424 -v /path/to/proxy.properties:/opt/accumulo-proxy/conf/proxy.properties --network="host" --name accumulo-proxy accumulo-proxy:latest
```

## Networking configuration
Container networking can be a very specialised subject therefore we document two common practices that should cover the majority of use cases for development. 

The proxy container must be able to access both Accumulo and ZooKeeper.

The ZooKeeper location can be configured in the `conf/proxy.properties` file, so you can override this to an acceptable value (see "Custom proxy.properties" section) 

In order to communicate with Accumulo the container will need to be able to resolve the FQDN that the servers have registered in ZooKeeper. If using [fluo-uno](https://github.com/apache/fluo-uno) this is very likely the hostname of your development environment. We'll call this my.host.com and IP 192.168.0.1 for the rest of this document.

### Host networking

Host networking is the simplest mechanism but generally only works for linux hosts where Docker has been installed on 'bare metal' e.g. through an RPM. 

You can test if this will work for you by executing the following steps

Start the accumulo-proxy container and enter it
```commandline
docker run -it --rm -p 42424:42424 --network="host" --name accumulo-proxy accumulo-proxy:latest bash;
```

Once inside the container, execute the curl command to attempt to connect to the monitor webserver:
```commandline
curl my.host.com:9995
```

If the terminal returns an error such as: 
```
curl: (7) Failed to connect to my.host.com 9995: Connection refused
``` 
then your container cannot see the host, and you will need to look at the next section (Non-Host networking).

If you receive the HTML for the monitor web page then host networking will work for you and you can add `--network="host"` to each Docker command going forward.

An example of using host networking:
```commandline
docker run --rm -d -p 42424:42424 --network="host" --name accumulo-proxy accumulo-proxy:latest
```

Note: You do not need to map your ports (-p) if using host networking, but we include it for clarity.

For more details see the official Docker documentation: [Use host Networking](https://docs.docker.com/network/host)

### Non-Host networking
If you run outside of a single node linux installation, e.g. Docker for Mac, Docker for Windows or use a VM to isolate your Docker engine then you will likely need to take this path.

Docker allows you to supply additional addresses to be resolved by the container, and these are automatically added by Docker to the /etc/hosts 

For each host add a `--add-host FQDN:IP` entry to your Docker run command, you can add multiple entries if need to, see the official docs covering [network settings](https://docs.docker.com/engine/reference/run/#network-settings).

An example of using this approach:

```commandline
docker run --rm -d -p 42424:42424 --add-host "my.host.com:192.168.0.1" --name accumulo-proxy accumulo-proxy:latest
```

## Cleanup
Once completed you should stop and remove the container.
```commandline
docker stop accumulo-proxy;
docker rm accumulo-proxy;
```

## Troubleshooting
It can often be difficult to know where to start with troubleshooting inside containers, if you need to enter the container without starting the proxy we support this:
```commandline
docker run -it --rm -p 42424:42424 --network="host" --name accumulo-proxy accumulo-proxy:latest bash
``` 

The container is very slim so if need be you can add additional tools using `apt`. 

If you wish to manually execute the accumulo-proxy in the container you can:
```commandline
/opt/accumulo-proxy/bin/accumulo-proxy -p /opt/accumulo-proxy/conf/proxy.properties
```

Some resources for additional help:
* [Main Accumulo Website](https://accumulo.apache.org/)
* [Contact Us page](https://accumulo.apache.org/contact-us/)
