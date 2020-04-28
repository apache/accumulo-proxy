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

FROM openjdk:8

EXPOSE 42424

WORKDIR /opt/accumulo-proxy

ARG HADOOP_VERSION=3.2.1
ARG ZOOKEEPER_VERSION=3.5.7
ARG ACCUMULO_VERSION=2.0.0
ARG ACCUMULO_PROXY_VERSION=2.0.0-SNAPSHOT

ARG HADOOP_HASH=a57962a24d178193349917730bf95cdc99bde9df
ARG ZOOKEEPER_HASH=619928c8553b62775119e3d7d143a4714a160365
ARG ACCUMULO_HASH=b72bf5c3dcaa25387933a032925046234f30e17a

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
        echo "${hash}" "/tmp/${f}" | sha1sum -c -; \
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
