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

Gem::Specification.new do |s|
  s.name        = 'accumulo'
  s.version     = '1.0.0'
  s.date        = '2019-12-18'
  s.summary     = "Accumulo Client library using Proxy"
  s.description = "Code that lets you communicate with Accumulo using the Proxy"
  s.authors     = ["Apache Accumulo committers"]
  s.email       = 'user@accumulo.apache.org'
  s.files       = ["lib/accumulo_proxy.rb", "lib/proxy_types.rb", "lib/proxy_constants.rb"]
  s.homepage    = 'https://github.com/apache/accumulo-proxy'
  s.license     = 'Apache-2.0'
end
