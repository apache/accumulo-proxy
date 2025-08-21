#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM openjdk:11

EXPOSE 42424

WORKDIR /opt/accumulo-proxy

ARG HADOOP_VERSION=3.3.6
ARG ZOOKEEPER_VERSION=3.9.2
ARG ACCUMULO_VERSION=2.1.3
ARG ACCUMULO_PROXY_VERSION=2.0.0-SNAPSHOT

ARG HADOOP_HASH=de3eaca2e0517e4b569a88b63c89fae19cb8ac6c01ff990f1ff8f0cc0f3128c8e8a23db01577ca562a0e0bb1b4a3889f8c74384e609cd55e537aada3dcaa9f8a
ARG ZOOKEEPER_HASH=2b5ae02d618a27ca8cd54924855d5344263b7d9dee760181f9d66bafa9230324d2ad31786895f0654c969dc38d4a3d0077f74cc376b58b5fa2fb94beb1ab445f
ARG ACCUMULO_HASH=1a27a144dc31f55ccc8e081b6c1bc6cc0362a8391838c53c166cb45291ff8f35867fd8e4729aa7b2c540f8b721f8c6953281bf589fc7fe320e4dc4d20b87abc4

# Download from Apache mirrors instead of archive #9
ENV APACHE_DIST_URLS="\
  https://www.apache.org/dyn/closer.cgi?action=download&filename= \
# if the version is outdated (or we're grabbing the .asc file), we might have to pull from the dist/archive :/
  https://www-us.apache.org/dist/ \
  https://www.apache.org/dist/ \
  https://archive.apache.org/dist/"

RUN set -eux; \
  download_bin() { \
    local f="$1"; shift; \
    local hash="$1"; shift; \
    local distFile="$1"; shift; \
    local success=; \
    local distUrl=; \ 
    for distUrl in ${APACHE_DIST_URLS}; do \
      if wget -nv -O "/tmp/${f}" "${distUrl}${distFile}"; then \
        success=1; \
        # Checksum the download
        echo "${hash}" "/tmp/${f}" | sha512sum -c -; \
        break; \
      fi; \
    done; \
    [ -n "${success}" ]; \
  };\
   \
   download_bin "apache-zookeeper.tar.gz" "${ZOOKEEPER_HASH}" "zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz"; \
   download_bin "hadoop.tar.gz" "$HADOOP_HASH" "hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz"; \
   download_bin "accumulo.tar.gz" "${ACCUMULO_HASH}" "accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz";

# Install the dependencies into /opt/
RUN tar xzf /tmp/hadoop.tar.gz -C /opt/ && ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop
RUN tar xzf /tmp/apache-zookeeper.tar.gz -C /opt/ && ln -s /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin /opt/apache-zookeeper
RUN tar xzf /tmp/accumulo.tar.gz -C /opt/ && ln -s /opt/accumulo-${ACCUMULO_VERSION} /opt/accumulo && sed -i 's/\${ZOOKEEPER_HOME}\/\*/\${ZOOKEEPER_HOME}\/\*\:\${ZOOKEEPER_HOME}\/lib\/\*/g' /opt/accumulo/conf/accumulo-env.sh

ENV HADOOP_HOME=/opt/hadoop
ENV ZOOKEEPER_HOME=/opt/apache-zookeeper
ENV ACCUMULO_HOME=/opt/accumulo

# Add the proxy binary
COPY target/accumulo-proxy-${ACCUMULO_PROXY_VERSION}-bin.tar.gz /tmp/
RUN tar xzf /tmp/accumulo-proxy-${ACCUMULO_PROXY_VERSION}-bin.tar.gz -C /opt/accumulo-proxy --strip 1
ENV ACCUMULO_PROXY_HOME=/opt/accumulo-proxy

# Ensure Accumulo is on the path.
ENV PATH="${PATH}:${ACCUMULO_HOME}/bin"

CMD ["/opt/accumulo-proxy/bin/accumulo-proxy", "-p", "/opt/accumulo-proxy/conf/proxy.properties"]
