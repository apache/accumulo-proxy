#!/usr/bin/env ruby

require 'rubygems'
require 'thrift'
require 'accumulo_proxy'

server = ARGV[0] || 'localhost'

socket = Thrift::Socket.new(server, 42424, 9001)
transport = Thrift::FramedTransport.new(socket)
proto = Thrift::CompactProtocol.new(transport)
proxy = Accumulo::AccumuloProxy::Client.new(proto)

# open up the connect
transport.open()

# Test if the server is up
login = proxy.login('root', {'password' => 'secret'})

# print out a table list
puts "List of tables: #{proxy.listTables(login).inspect}"

testtable = "rubytest"
proxy.createTable(login, testtable, true, Accumulo::TimeType::MILLIS) unless proxy.tableExists(login,testtable)

update1 = Accumulo::ColumnUpdate.new({'colFamily' => "cf1", 'colQualifier' => "cq1", 'value'=> "a"})
update2 = Accumulo::ColumnUpdate.new({'colFamily' => "cf2", 'colQualifier' => "cq2", 'value'=> "b"})
proxy.updateAndFlush(login,testtable,{'row1' => [update1,update2]})

cookie = proxy.createScanner(login,testtable,nil)
result = proxy.nextK(cookie,10)
result.results.each{ |keyvalue| puts "Key: #{keyvalue.key.inspect} Value: #{keyvalue.value}" }
