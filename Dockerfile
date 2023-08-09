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

FROM openjdk:11

EXPOSE 42424

WORKDIR /opt/accumulo-proxy

ARG HADOOP_VERSION=3.3.4
ARG ZOOKEEPER_VERSION=3.8.0
ARG ACCUMULO_VERSION=2.1.1
ARG ACCUMULO_PROXY_VERSION=2.0.0-SNAPSHOT

ARG HADOOP_HASH=ca5e12625679ca95b8fd7bb7babc2a8dcb2605979b901df9ad137178718821097b67555115fafc6dbf6bb32b61864ccb6786dbc555e589694a22bf69147780b4
ARG ZOOKEEPER_HASH=d66e3a40451f840406901b2cd940992b001f92049a372ae48d8b420891605871cd1ae5f6cceb3b10665491e7abef36a4078dace158bd1e0938fcd3567b5234ca
ARG ACCUMULO_HASH=adb23e56362c2e3e813d07791389b8ca2d5976df8b00a29b607e6ae05ea465eff80ada6d1ec9a9c596df8b4066c51078cd5a4006dc78568ac38f638a1d3895be

# Download from Apache mirrors instead of archive #9
ENV APACHE_DIST_URLS \
  https://www.apache.org/dyn/closer.cgi?action=download&filename= \
# if the version is outdated (or we're grabbing the .asc file), we might have to pull from the dist/archive :/
  https://www-us.apache.org/dist/ \
  https://www.apache.org/dist/ \
  https://archive.apache.org/dist/

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

ENV HADOOP_HOME /opt/hadoop
ENV ZOOKEEPER_HOME /opt/apache-zookeeper
ENV ACCUMULO_HOME /opt/accumulo

# Add the proxy binary
COPY target/accumulo-proxy-${ACCUMULO_PROXY_VERSION}-bin.tar.gz /tmp/
RUN tar xzf /tmp/accumulo-proxy-${ACCUMULO_PROXY_VERSION}-bin.tar.gz -C /opt/accumulo-proxy --strip 1
ENV ACCUMULO_PROXY_HOME /opt/accumulo-proxy

# Ensure Accumulo is on the path.
ENV PATH "${PATH}:${ACCUMULO_HOME}/bin"

CMD ["/opt/accumulo-proxy/bin/accumulo-proxy", "-p", "/opt/accumulo-proxy/conf/proxy.properties"]
