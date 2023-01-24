# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM openjdk:8-alpine3.9

EXPOSE 42424

ARG HADOOP_VERSION=3.2.1
ARG ZOOKEEPER_VERSION=3.5.7
ARG ACCUMULO_VERSION=2.0.0
ARG ACCUMULO_PROXY_VERSION=2.0.0-SNAPSHOT

ARG HADOOP_SHA512_HASH=d62709c3d7144fcaafc60e18d0fa03d7d477cc813e45526f3646030cd87dbf010aeccf3f4ce795b57b08d2884b3a55f91fe9d74ac144992d2dfe444a4bbf34ee
ARG ZOOKEEPER_SHA512_HASH=b9baa1ecb3d4dc0ef648ce7c74da4c5267ee89534c7614b8f27d3b0bc52004dcfbb8cecec810ffb7c8c45053daf8a5e849ce60ba241280fa1e2ab1d3b4990494
ARG ACCUMULO_SHA512_HASH=1e2b822e0fd6ba5293b09203eb0c5cc230e9f111361634b4d5665b0ddd2b28f42d76699cb08aaeff9b3242efd5fe369bfc871a7dc361e935980889bcb7b4568f

# Download from Apache mirrors instead of archive #9
ENV APACHE_DIST_URLS \
  https://www.apache.org/dyn/closer.cgi?action=download&filename= \
# if the version is outdated (or we're grabbing the .asc file), we might have to pull from the dist/archive :/
  https://www-us.apache.org/dist/ \
  https://www.apache.org/dist/ \
  https://archive.apache.org/dist/

ENV HADOOP_HOME /opt/hadoop
ENV ZOOKEEPER_HOME /opt/apache-zookeeper
ENV ACCUMULO_HOME /opt/accumulo

RUN set -eux; \
  download_verify_and_extract() { \
    local expectedHash="$1"; \
    local distFile="$2"; \
    local extractPath="$3"; \
    local symlinkPath="$4"; \
    local success=; \
    local distUrl=; \
    for distUrl in ${APACHE_DIST_URLS}; do \
      if wget -nv -O "/tmp/download.tar.gz" "${distUrl}${distFile}"; then \
        # Checksum the download
        echo "${expectedHash}  /tmp/download.tar.gz" | sha512sum -c -; \
        # Extract the download
        mkdir "${extractPath}"; \
        tar xzf "/tmp/download.tar.gz" -C "${extractPath}" --strip 1;\
        # Symlink
        ln -s "${extractPath}" "${symlinkPath}"; \
        # Tidy up the download
        rm -f "/tmp/download.tar.gz"; \
        # Set success now we've done all our checks and tidied up
        success=1; \
        break; \
      fi; \
    done; \
    [ -n "${success}" ]; \
  };\
   \
   download_verify_and_extract "${ZOOKEEPER_SHA512_HASH}" "zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz" "/opt/apache-zookeeper-${ZOOKEEPER_VERSION}" "${ZOOKEEPER_HOME}"; \
   download_verify_and_extract "${HADOOP_SHA512_HASH}" "hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz" "/opt/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}"; \
   download_verify_and_extract "${ACCUMULO_SHA512_HASH}" "accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz" "/opt/accumulo-${ACCUMULO_VERSION}" "${ACCUMULO_HOME}" ;

# Fix the ZooKeeper classpath for Accumulo
RUN sed -i 's/\${ZOOKEEPER_HOME}\/\*/\${ZOOKEEPER_HOME}\/\*\:\${ZOOKEEPER_HOME}\/lib\/\*/g' /opt/accumulo/conf/accumulo-env.sh

# Add bash as a dependency for accumulo-proxy and accumulo shell scripts
RUN apk --no-cache add bash

# Add the proxy binary
ENV ACCUMULO_PROXY_HOME /opt/accumulo-proxy
ADD target/accumulo-proxy-${ACCUMULO_PROXY_VERSION}-bin.tar.gz /opt/
RUN ln -s "/opt/accumulo-proxy-${ACCUMULO_PROXY_VERSION}/" "${ACCUMULO_PROXY_HOME}"

# Ensure Accumulo is on the path.
ENV PATH "${PATH}:${ACCUMULO_HOME}/bin"

WORKDIR ${ACCUMULO_PROXY_HOME}

CMD ["/opt/accumulo-proxy/bin/accumulo-proxy", "-p", "/opt/accumulo-proxy/conf/proxy.properties"]
