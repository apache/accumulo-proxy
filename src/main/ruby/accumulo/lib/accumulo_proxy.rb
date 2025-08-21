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

require 'thrift'
require 'proxy_types'

module Accumulo
  module AccumuloProxy
    class Client
      include ::Thrift::Client

      def addConstraint(sharedSecret, tableName, constraintClassName)
        send_addConstraint(sharedSecret, tableName, constraintClassName)
        return recv_addConstraint()
      end

      def send_addConstraint(sharedSecret, tableName, constraintClassName)
        send_message('addConstraint', AddConstraint_args, :sharedSecret => sharedSecret, :tableName => tableName, :constraintClassName => constraintClassName)
      end

      def recv_addConstraint()
        result = receive_message(AddConstraint_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'addConstraint failed: unknown result')
      end

      def addSplits(sharedSecret, tableName, splits)
        send_addSplits(sharedSecret, tableName, splits)
        recv_addSplits()
      end

      def send_addSplits(sharedSecret, tableName, splits)
        send_message('addSplits', AddSplits_args, :sharedSecret => sharedSecret, :tableName => tableName, :splits => splits)
      end

      def recv_addSplits()
        result = receive_message(AddSplits_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def attachIterator(sharedSecret, tableName, setting, scopes)
        send_attachIterator(sharedSecret, tableName, setting, scopes)
        recv_attachIterator()
      end

      def send_attachIterator(sharedSecret, tableName, setting, scopes)
        send_message('attachIterator', AttachIterator_args, :sharedSecret => sharedSecret, :tableName => tableName, :setting => setting, :scopes => scopes)
      end

      def recv_attachIterator()
        result = receive_message(AttachIterator_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def checkIteratorConflicts(sharedSecret, tableName, setting, scopes)
        send_checkIteratorConflicts(sharedSecret, tableName, setting, scopes)
        recv_checkIteratorConflicts()
      end

      def send_checkIteratorConflicts(sharedSecret, tableName, setting, scopes)
        send_message('checkIteratorConflicts', CheckIteratorConflicts_args, :sharedSecret => sharedSecret, :tableName => tableName, :setting => setting, :scopes => scopes)
      end

      def recv_checkIteratorConflicts()
        result = receive_message(CheckIteratorConflicts_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def clearLocatorCache(sharedSecret, tableName)
        send_clearLocatorCache(sharedSecret, tableName)
        recv_clearLocatorCache()
      end

      def send_clearLocatorCache(sharedSecret, tableName)
        send_message('clearLocatorCache', ClearLocatorCache_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_clearLocatorCache()
        result = receive_message(ClearLocatorCache_result)
        raise result.ouch1 unless result.ouch1.nil?
        return
      end

      def cloneTable(sharedSecret, tableName, newTableName, flush, propertiesToSet, propertiesToExclude)
        send_cloneTable(sharedSecret, tableName, newTableName, flush, propertiesToSet, propertiesToExclude)
        recv_cloneTable()
      end

      def send_cloneTable(sharedSecret, tableName, newTableName, flush, propertiesToSet, propertiesToExclude)
        send_message('cloneTable', CloneTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :newTableName => newTableName, :flush => flush, :propertiesToSet => propertiesToSet, :propertiesToExclude => propertiesToExclude)
      end

      def recv_cloneTable()
        result = receive_message(CloneTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise result.ouch4 unless result.ouch4.nil?
        return
      end

      def compactTable(sharedSecret, tableName, startRow, endRow, iterators, flush, wait, selectorConfig, configurerConfig)
        send_compactTable(sharedSecret, tableName, startRow, endRow, iterators, flush, wait, selectorConfig, configurerConfig)
        recv_compactTable()
      end

      def send_compactTable(sharedSecret, tableName, startRow, endRow, iterators, flush, wait, selectorConfig, configurerConfig)
        send_message('compactTable', CompactTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :startRow => startRow, :endRow => endRow, :iterators => iterators, :flush => flush, :wait => wait, :selectorConfig => selectorConfig, :configurerConfig => configurerConfig)
      end

      def recv_compactTable()
        result = receive_message(CompactTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def cancelCompaction(sharedSecret, tableName)
        send_cancelCompaction(sharedSecret, tableName)
        recv_cancelCompaction()
      end

      def send_cancelCompaction(sharedSecret, tableName)
        send_message('cancelCompaction', CancelCompaction_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_cancelCompaction()
        result = receive_message(CancelCompaction_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def createTable(sharedSecret, tableName, versioningIter, type)
        send_createTable(sharedSecret, tableName, versioningIter, type)
        recv_createTable()
      end

      def send_createTable(sharedSecret, tableName, versioningIter, type)
        send_message('createTable', CreateTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :versioningIter => versioningIter, :type => type)
      end

      def recv_createTable()
        result = receive_message(CreateTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def deleteTable(sharedSecret, tableName)
        send_deleteTable(sharedSecret, tableName)
        recv_deleteTable()
      end

      def send_deleteTable(sharedSecret, tableName)
        send_message('deleteTable', DeleteTable_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_deleteTable()
        result = receive_message(DeleteTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def deleteRows(sharedSecret, tableName, startRow, endRow)
        send_deleteRows(sharedSecret, tableName, startRow, endRow)
        recv_deleteRows()
      end

      def send_deleteRows(sharedSecret, tableName, startRow, endRow)
        send_message('deleteRows', DeleteRows_args, :sharedSecret => sharedSecret, :tableName => tableName, :startRow => startRow, :endRow => endRow)
      end

      def recv_deleteRows()
        result = receive_message(DeleteRows_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def exportTable(sharedSecret, tableName, exportDir)
        send_exportTable(sharedSecret, tableName, exportDir)
        recv_exportTable()
      end

      def send_exportTable(sharedSecret, tableName, exportDir)
        send_message('exportTable', ExportTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :exportDir => exportDir)
      end

      def recv_exportTable()
        result = receive_message(ExportTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def flushTable(sharedSecret, tableName, startRow, endRow, wait)
        send_flushTable(sharedSecret, tableName, startRow, endRow, wait)
        recv_flushTable()
      end

      def send_flushTable(sharedSecret, tableName, startRow, endRow, wait)
        send_message('flushTable', FlushTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :startRow => startRow, :endRow => endRow, :wait => wait)
      end

      def recv_flushTable()
        result = receive_message(FlushTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def getDiskUsage(sharedSecret, tables)
        send_getDiskUsage(sharedSecret, tables)
        return recv_getDiskUsage()
      end

      def send_getDiskUsage(sharedSecret, tables)
        send_message('getDiskUsage', GetDiskUsage_args, :sharedSecret => sharedSecret, :tables => tables)
      end

      def recv_getDiskUsage()
        result = receive_message(GetDiskUsage_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getDiskUsage failed: unknown result')
      end

      def getLocalityGroups(sharedSecret, tableName)
        send_getLocalityGroups(sharedSecret, tableName)
        return recv_getLocalityGroups()
      end

      def send_getLocalityGroups(sharedSecret, tableName)
        send_message('getLocalityGroups', GetLocalityGroups_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_getLocalityGroups()
        result = receive_message(GetLocalityGroups_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getLocalityGroups failed: unknown result')
      end

      def getIteratorSetting(sharedSecret, tableName, iteratorName, scope)
        send_getIteratorSetting(sharedSecret, tableName, iteratorName, scope)
        return recv_getIteratorSetting()
      end

      def send_getIteratorSetting(sharedSecret, tableName, iteratorName, scope)
        send_message('getIteratorSetting', GetIteratorSetting_args, :sharedSecret => sharedSecret, :tableName => tableName, :iteratorName => iteratorName, :scope => scope)
      end

      def recv_getIteratorSetting()
        result = receive_message(GetIteratorSetting_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getIteratorSetting failed: unknown result')
      end

      def getMaxRow(sharedSecret, tableName, auths, startRow, startInclusive, endRow, endInclusive)
        send_getMaxRow(sharedSecret, tableName, auths, startRow, startInclusive, endRow, endInclusive)
        return recv_getMaxRow()
      end

      def send_getMaxRow(sharedSecret, tableName, auths, startRow, startInclusive, endRow, endInclusive)
        send_message('getMaxRow', GetMaxRow_args, :sharedSecret => sharedSecret, :tableName => tableName, :auths => auths, :startRow => startRow, :startInclusive => startInclusive, :endRow => endRow, :endInclusive => endInclusive)
      end

      def recv_getMaxRow()
        result = receive_message(GetMaxRow_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getMaxRow failed: unknown result')
      end

      def getTableProperties(sharedSecret, tableName)
        send_getTableProperties(sharedSecret, tableName)
        return recv_getTableProperties()
      end

      def send_getTableProperties(sharedSecret, tableName)
        send_message('getTableProperties', GetTableProperties_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_getTableProperties()
        result = receive_message(GetTableProperties_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getTableProperties failed: unknown result')
      end

      def importDirectory(sharedSecret, tableName, importDir, failureDir, setTime)
        send_importDirectory(sharedSecret, tableName, importDir, failureDir, setTime)
        recv_importDirectory()
      end

      def send_importDirectory(sharedSecret, tableName, importDir, failureDir, setTime)
        send_message('importDirectory', ImportDirectory_args, :sharedSecret => sharedSecret, :tableName => tableName, :importDir => importDir, :failureDir => failureDir, :setTime => setTime)
      end

      def recv_importDirectory()
        result = receive_message(ImportDirectory_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise result.ouch4 unless result.ouch4.nil?
        return
      end

      def importTable(sharedSecret, tableName, importDir)
        send_importTable(sharedSecret, tableName, importDir)
        recv_importTable()
      end

      def send_importTable(sharedSecret, tableName, importDir)
        send_message('importTable', ImportTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :importDir => importDir)
      end

      def recv_importTable()
        result = receive_message(ImportTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def listSplits(sharedSecret, tableName, maxSplits)
        send_listSplits(sharedSecret, tableName, maxSplits)
        return recv_listSplits()
      end

      def send_listSplits(sharedSecret, tableName, maxSplits)
        send_message('listSplits', ListSplits_args, :sharedSecret => sharedSecret, :tableName => tableName, :maxSplits => maxSplits)
      end

      def recv_listSplits()
        result = receive_message(ListSplits_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listSplits failed: unknown result')
      end

      def listTables(sharedSecret)
        send_listTables(sharedSecret)
        return recv_listTables()
      end

      def send_listTables(sharedSecret)
        send_message('listTables', ListTables_args, :sharedSecret => sharedSecret)
      end

      def recv_listTables()
        result = receive_message(ListTables_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listTables failed: unknown result')
      end

      def listIterators(sharedSecret, tableName)
        send_listIterators(sharedSecret, tableName)
        return recv_listIterators()
      end

      def send_listIterators(sharedSecret, tableName)
        send_message('listIterators', ListIterators_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_listIterators()
        result = receive_message(ListIterators_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listIterators failed: unknown result')
      end

      def listConstraints(sharedSecret, tableName)
        send_listConstraints(sharedSecret, tableName)
        return recv_listConstraints()
      end

      def send_listConstraints(sharedSecret, tableName)
        send_message('listConstraints', ListConstraints_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_listConstraints()
        result = receive_message(ListConstraints_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listConstraints failed: unknown result')
      end

      def mergeTablets(sharedSecret, tableName, startRow, endRow)
        send_mergeTablets(sharedSecret, tableName, startRow, endRow)
        recv_mergeTablets()
      end

      def send_mergeTablets(sharedSecret, tableName, startRow, endRow)
        send_message('mergeTablets', MergeTablets_args, :sharedSecret => sharedSecret, :tableName => tableName, :startRow => startRow, :endRow => endRow)
      end

      def recv_mergeTablets()
        result = receive_message(MergeTablets_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def offlineTable(sharedSecret, tableName, wait)
        send_offlineTable(sharedSecret, tableName, wait)
        recv_offlineTable()
      end

      def send_offlineTable(sharedSecret, tableName, wait)
        send_message('offlineTable', OfflineTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :wait => wait)
      end

      def recv_offlineTable()
        result = receive_message(OfflineTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def onlineTable(sharedSecret, tableName, wait)
        send_onlineTable(sharedSecret, tableName, wait)
        recv_onlineTable()
      end

      def send_onlineTable(sharedSecret, tableName, wait)
        send_message('onlineTable', OnlineTable_args, :sharedSecret => sharedSecret, :tableName => tableName, :wait => wait)
      end

      def recv_onlineTable()
        result = receive_message(OnlineTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def removeConstraint(sharedSecret, tableName, constraint)
        send_removeConstraint(sharedSecret, tableName, constraint)
        recv_removeConstraint()
      end

      def send_removeConstraint(sharedSecret, tableName, constraint)
        send_message('removeConstraint', RemoveConstraint_args, :sharedSecret => sharedSecret, :tableName => tableName, :constraint => constraint)
      end

      def recv_removeConstraint()
        result = receive_message(RemoveConstraint_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def removeIterator(sharedSecret, tableName, iterName, scopes)
        send_removeIterator(sharedSecret, tableName, iterName, scopes)
        recv_removeIterator()
      end

      def send_removeIterator(sharedSecret, tableName, iterName, scopes)
        send_message('removeIterator', RemoveIterator_args, :sharedSecret => sharedSecret, :tableName => tableName, :iterName => iterName, :scopes => scopes)
      end

      def recv_removeIterator()
        result = receive_message(RemoveIterator_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def removeTableProperty(sharedSecret, tableName, property)
        send_removeTableProperty(sharedSecret, tableName, property)
        recv_removeTableProperty()
      end

      def send_removeTableProperty(sharedSecret, tableName, property)
        send_message('removeTableProperty', RemoveTableProperty_args, :sharedSecret => sharedSecret, :tableName => tableName, :property => property)
      end

      def recv_removeTableProperty()
        result = receive_message(RemoveTableProperty_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def renameTable(sharedSecret, oldTableName, newTableName)
        send_renameTable(sharedSecret, oldTableName, newTableName)
        recv_renameTable()
      end

      def send_renameTable(sharedSecret, oldTableName, newTableName)
        send_message('renameTable', RenameTable_args, :sharedSecret => sharedSecret, :oldTableName => oldTableName, :newTableName => newTableName)
      end

      def recv_renameTable()
        result = receive_message(RenameTable_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise result.ouch4 unless result.ouch4.nil?
        return
      end

      def setLocalityGroups(sharedSecret, tableName, groups)
        send_setLocalityGroups(sharedSecret, tableName, groups)
        recv_setLocalityGroups()
      end

      def send_setLocalityGroups(sharedSecret, tableName, groups)
        send_message('setLocalityGroups', SetLocalityGroups_args, :sharedSecret => sharedSecret, :tableName => tableName, :groups => groups)
      end

      def recv_setLocalityGroups()
        result = receive_message(SetLocalityGroups_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def setTableProperty(sharedSecret, tableName, property, value)
        send_setTableProperty(sharedSecret, tableName, property, value)
        recv_setTableProperty()
      end

      def send_setTableProperty(sharedSecret, tableName, property, value)
        send_message('setTableProperty', SetTableProperty_args, :sharedSecret => sharedSecret, :tableName => tableName, :property => property, :value => value)
      end

      def recv_setTableProperty()
        result = receive_message(SetTableProperty_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def splitRangeByTablets(sharedSecret, tableName, range, maxSplits)
        send_splitRangeByTablets(sharedSecret, tableName, range, maxSplits)
        return recv_splitRangeByTablets()
      end

      def send_splitRangeByTablets(sharedSecret, tableName, range, maxSplits)
        send_message('splitRangeByTablets', SplitRangeByTablets_args, :sharedSecret => sharedSecret, :tableName => tableName, :range => range, :maxSplits => maxSplits)
      end

      def recv_splitRangeByTablets()
        result = receive_message(SplitRangeByTablets_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'splitRangeByTablets failed: unknown result')
      end

      def tableExists(sharedSecret, tableName)
        send_tableExists(sharedSecret, tableName)
        return recv_tableExists()
      end

      def send_tableExists(sharedSecret, tableName)
        send_message('tableExists', TableExists_args, :sharedSecret => sharedSecret, :tableName => tableName)
      end

      def recv_tableExists()
        result = receive_message(TableExists_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'tableExists failed: unknown result')
      end

      def tableIdMap(sharedSecret)
        send_tableIdMap(sharedSecret)
        return recv_tableIdMap()
      end

      def send_tableIdMap(sharedSecret)
        send_message('tableIdMap', TableIdMap_args, :sharedSecret => sharedSecret)
      end

      def recv_tableIdMap()
        result = receive_message(TableIdMap_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'tableIdMap failed: unknown result')
      end

      def testTableClassLoad(sharedSecret, tableName, className, asTypeName)
        send_testTableClassLoad(sharedSecret, tableName, className, asTypeName)
        return recv_testTableClassLoad()
      end

      def send_testTableClassLoad(sharedSecret, tableName, className, asTypeName)
        send_message('testTableClassLoad', TestTableClassLoad_args, :sharedSecret => sharedSecret, :tableName => tableName, :className => className, :asTypeName => asTypeName)
      end

      def recv_testTableClassLoad()
        result = receive_message(TestTableClassLoad_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'testTableClassLoad failed: unknown result')
      end

      def pingTabletServer(sharedSecret, tserver)
        send_pingTabletServer(sharedSecret, tserver)
        recv_pingTabletServer()
      end

      def send_pingTabletServer(sharedSecret, tserver)
        send_message('pingTabletServer', PingTabletServer_args, :sharedSecret => sharedSecret, :tserver => tserver)
      end

      def recv_pingTabletServer()
        result = receive_message(PingTabletServer_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def getActiveScans(sharedSecret, tserver)
        send_getActiveScans(sharedSecret, tserver)
        return recv_getActiveScans()
      end

      def send_getActiveScans(sharedSecret, tserver)
        send_message('getActiveScans', GetActiveScans_args, :sharedSecret => sharedSecret, :tserver => tserver)
      end

      def recv_getActiveScans()
        result = receive_message(GetActiveScans_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getActiveScans failed: unknown result')
      end

      def getActiveCompactions(sharedSecret, tserver)
        send_getActiveCompactions(sharedSecret, tserver)
        return recv_getActiveCompactions()
      end

      def send_getActiveCompactions(sharedSecret, tserver)
        send_message('getActiveCompactions', GetActiveCompactions_args, :sharedSecret => sharedSecret, :tserver => tserver)
      end

      def recv_getActiveCompactions()
        result = receive_message(GetActiveCompactions_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getActiveCompactions failed: unknown result')
      end

      def getSiteConfiguration(sharedSecret)
        send_getSiteConfiguration(sharedSecret)
        return recv_getSiteConfiguration()
      end

      def send_getSiteConfiguration(sharedSecret)
        send_message('getSiteConfiguration', GetSiteConfiguration_args, :sharedSecret => sharedSecret)
      end

      def recv_getSiteConfiguration()
        result = receive_message(GetSiteConfiguration_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getSiteConfiguration failed: unknown result')
      end

      def getSystemConfiguration(sharedSecret)
        send_getSystemConfiguration(sharedSecret)
        return recv_getSystemConfiguration()
      end

      def send_getSystemConfiguration(sharedSecret)
        send_message('getSystemConfiguration', GetSystemConfiguration_args, :sharedSecret => sharedSecret)
      end

      def recv_getSystemConfiguration()
        result = receive_message(GetSystemConfiguration_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getSystemConfiguration failed: unknown result')
      end

      def getTabletServers(sharedSecret)
        send_getTabletServers(sharedSecret)
        return recv_getTabletServers()
      end

      def send_getTabletServers(sharedSecret)
        send_message('getTabletServers', GetTabletServers_args, :sharedSecret => sharedSecret)
      end

      def recv_getTabletServers()
        result = receive_message(GetTabletServers_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getTabletServers failed: unknown result')
      end

      def removeProperty(sharedSecret, property)
        send_removeProperty(sharedSecret, property)
        recv_removeProperty()
      end

      def send_removeProperty(sharedSecret, property)
        send_message('removeProperty', RemoveProperty_args, :sharedSecret => sharedSecret, :property => property)
      end

      def recv_removeProperty()
        result = receive_message(RemoveProperty_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def setProperty(sharedSecret, property, value)
        send_setProperty(sharedSecret, property, value)
        recv_setProperty()
      end

      def send_setProperty(sharedSecret, property, value)
        send_message('setProperty', SetProperty_args, :sharedSecret => sharedSecret, :property => property, :value => value)
      end

      def recv_setProperty()
        result = receive_message(SetProperty_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def testClassLoad(sharedSecret, className, asTypeName)
        send_testClassLoad(sharedSecret, className, asTypeName)
        return recv_testClassLoad()
      end

      def send_testClassLoad(sharedSecret, className, asTypeName)
        send_message('testClassLoad', TestClassLoad_args, :sharedSecret => sharedSecret, :className => className, :asTypeName => asTypeName)
      end

      def recv_testClassLoad()
        result = receive_message(TestClassLoad_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'testClassLoad failed: unknown result')
      end

      def authenticateUser(sharedSecret, user, properties)
        send_authenticateUser(sharedSecret, user, properties)
        return recv_authenticateUser()
      end

      def send_authenticateUser(sharedSecret, user, properties)
        send_message('authenticateUser', AuthenticateUser_args, :sharedSecret => sharedSecret, :user => user, :properties => properties)
      end

      def recv_authenticateUser()
        result = receive_message(AuthenticateUser_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'authenticateUser failed: unknown result')
      end

      def changeUserAuthorizations(sharedSecret, user, authorizations)
        send_changeUserAuthorizations(sharedSecret, user, authorizations)
        recv_changeUserAuthorizations()
      end

      def send_changeUserAuthorizations(sharedSecret, user, authorizations)
        send_message('changeUserAuthorizations', ChangeUserAuthorizations_args, :sharedSecret => sharedSecret, :user => user, :authorizations => authorizations)
      end

      def recv_changeUserAuthorizations()
        result = receive_message(ChangeUserAuthorizations_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def changeLocalUserPassword(sharedSecret, user, password)
        send_changeLocalUserPassword(sharedSecret, user, password)
        recv_changeLocalUserPassword()
      end

      def send_changeLocalUserPassword(sharedSecret, user, password)
        send_message('changeLocalUserPassword', ChangeLocalUserPassword_args, :sharedSecret => sharedSecret, :user => user, :password => password)
      end

      def recv_changeLocalUserPassword()
        result = receive_message(ChangeLocalUserPassword_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def createLocalUser(sharedSecret, user, password)
        send_createLocalUser(sharedSecret, user, password)
        recv_createLocalUser()
      end

      def send_createLocalUser(sharedSecret, user, password)
        send_message('createLocalUser', CreateLocalUser_args, :sharedSecret => sharedSecret, :user => user, :password => password)
      end

      def recv_createLocalUser()
        result = receive_message(CreateLocalUser_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def dropLocalUser(sharedSecret, user)
        send_dropLocalUser(sharedSecret, user)
        recv_dropLocalUser()
      end

      def send_dropLocalUser(sharedSecret, user)
        send_message('dropLocalUser', DropLocalUser_args, :sharedSecret => sharedSecret, :user => user)
      end

      def recv_dropLocalUser()
        result = receive_message(DropLocalUser_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def getUserAuthorizations(sharedSecret, user)
        send_getUserAuthorizations(sharedSecret, user)
        return recv_getUserAuthorizations()
      end

      def send_getUserAuthorizations(sharedSecret, user)
        send_message('getUserAuthorizations', GetUserAuthorizations_args, :sharedSecret => sharedSecret, :user => user)
      end

      def recv_getUserAuthorizations()
        result = receive_message(GetUserAuthorizations_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getUserAuthorizations failed: unknown result')
      end

      def grantSystemPermission(sharedSecret, user, perm)
        send_grantSystemPermission(sharedSecret, user, perm)
        recv_grantSystemPermission()
      end

      def send_grantSystemPermission(sharedSecret, user, perm)
        send_message('grantSystemPermission', GrantSystemPermission_args, :sharedSecret => sharedSecret, :user => user, :perm => perm)
      end

      def recv_grantSystemPermission()
        result = receive_message(GrantSystemPermission_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def grantTablePermission(sharedSecret, user, table, perm)
        send_grantTablePermission(sharedSecret, user, table, perm)
        recv_grantTablePermission()
      end

      def send_grantTablePermission(sharedSecret, user, table, perm)
        send_message('grantTablePermission', GrantTablePermission_args, :sharedSecret => sharedSecret, :user => user, :table => table, :perm => perm)
      end

      def recv_grantTablePermission()
        result = receive_message(GrantTablePermission_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def hasSystemPermission(sharedSecret, user, perm)
        send_hasSystemPermission(sharedSecret, user, perm)
        return recv_hasSystemPermission()
      end

      def send_hasSystemPermission(sharedSecret, user, perm)
        send_message('hasSystemPermission', HasSystemPermission_args, :sharedSecret => sharedSecret, :user => user, :perm => perm)
      end

      def recv_hasSystemPermission()
        result = receive_message(HasSystemPermission_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'hasSystemPermission failed: unknown result')
      end

      def hasTablePermission(sharedSecret, user, table, perm)
        send_hasTablePermission(sharedSecret, user, table, perm)
        return recv_hasTablePermission()
      end

      def send_hasTablePermission(sharedSecret, user, table, perm)
        send_message('hasTablePermission', HasTablePermission_args, :sharedSecret => sharedSecret, :user => user, :table => table, :perm => perm)
      end

      def recv_hasTablePermission()
        result = receive_message(HasTablePermission_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'hasTablePermission failed: unknown result')
      end

      def listLocalUsers(sharedSecret)
        send_listLocalUsers(sharedSecret)
        return recv_listLocalUsers()
      end

      def send_listLocalUsers(sharedSecret)
        send_message('listLocalUsers', ListLocalUsers_args, :sharedSecret => sharedSecret)
      end

      def recv_listLocalUsers()
        result = receive_message(ListLocalUsers_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listLocalUsers failed: unknown result')
      end

      def revokeSystemPermission(sharedSecret, user, perm)
        send_revokeSystemPermission(sharedSecret, user, perm)
        recv_revokeSystemPermission()
      end

      def send_revokeSystemPermission(sharedSecret, user, perm)
        send_message('revokeSystemPermission', RevokeSystemPermission_args, :sharedSecret => sharedSecret, :user => user, :perm => perm)
      end

      def recv_revokeSystemPermission()
        result = receive_message(RevokeSystemPermission_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def revokeTablePermission(sharedSecret, user, table, perm)
        send_revokeTablePermission(sharedSecret, user, table, perm)
        recv_revokeTablePermission()
      end

      def send_revokeTablePermission(sharedSecret, user, table, perm)
        send_message('revokeTablePermission', RevokeTablePermission_args, :sharedSecret => sharedSecret, :user => user, :table => table, :perm => perm)
      end

      def recv_revokeTablePermission()
        result = receive_message(RevokeTablePermission_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def grantNamespacePermission(sharedSecret, user, namespaceName, perm)
        send_grantNamespacePermission(sharedSecret, user, namespaceName, perm)
        recv_grantNamespacePermission()
      end

      def send_grantNamespacePermission(sharedSecret, user, namespaceName, perm)
        send_message('grantNamespacePermission', GrantNamespacePermission_args, :sharedSecret => sharedSecret, :user => user, :namespaceName => namespaceName, :perm => perm)
      end

      def recv_grantNamespacePermission()
        result = receive_message(GrantNamespacePermission_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def hasNamespacePermission(sharedSecret, user, namespaceName, perm)
        send_hasNamespacePermission(sharedSecret, user, namespaceName, perm)
        return recv_hasNamespacePermission()
      end

      def send_hasNamespacePermission(sharedSecret, user, namespaceName, perm)
        send_message('hasNamespacePermission', HasNamespacePermission_args, :sharedSecret => sharedSecret, :user => user, :namespaceName => namespaceName, :perm => perm)
      end

      def recv_hasNamespacePermission()
        result = receive_message(HasNamespacePermission_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'hasNamespacePermission failed: unknown result')
      end

      def revokeNamespacePermission(sharedSecret, user, namespaceName, perm)
        send_revokeNamespacePermission(sharedSecret, user, namespaceName, perm)
        recv_revokeNamespacePermission()
      end

      def send_revokeNamespacePermission(sharedSecret, user, namespaceName, perm)
        send_message('revokeNamespacePermission', RevokeNamespacePermission_args, :sharedSecret => sharedSecret, :user => user, :namespaceName => namespaceName, :perm => perm)
      end

      def recv_revokeNamespacePermission()
        result = receive_message(RevokeNamespacePermission_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def createBatchScanner(sharedSecret, tableName, options)
        send_createBatchScanner(sharedSecret, tableName, options)
        return recv_createBatchScanner()
      end

      def send_createBatchScanner(sharedSecret, tableName, options)
        send_message('createBatchScanner', CreateBatchScanner_args, :sharedSecret => sharedSecret, :tableName => tableName, :options => options)
      end

      def recv_createBatchScanner()
        result = receive_message(CreateBatchScanner_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'createBatchScanner failed: unknown result')
      end

      def createScanner(sharedSecret, tableName, options)
        send_createScanner(sharedSecret, tableName, options)
        return recv_createScanner()
      end

      def send_createScanner(sharedSecret, tableName, options)
        send_message('createScanner', CreateScanner_args, :sharedSecret => sharedSecret, :tableName => tableName, :options => options)
      end

      def recv_createScanner()
        result = receive_message(CreateScanner_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'createScanner failed: unknown result')
      end

      def hasNext(scanner)
        send_hasNext(scanner)
        return recv_hasNext()
      end

      def send_hasNext(scanner)
        send_message('hasNext', HasNext_args, :scanner => scanner)
      end

      def recv_hasNext()
        result = receive_message(HasNext_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'hasNext failed: unknown result')
      end

      def nextEntry(scanner)
        send_nextEntry(scanner)
        return recv_nextEntry()
      end

      def send_nextEntry(scanner)
        send_message('nextEntry', NextEntry_args, :scanner => scanner)
      end

      def recv_nextEntry()
        result = receive_message(NextEntry_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'nextEntry failed: unknown result')
      end

      def nextK(scanner, k)
        send_nextK(scanner, k)
        return recv_nextK()
      end

      def send_nextK(scanner, k)
        send_message('nextK', NextK_args, :scanner => scanner, :k => k)
      end

      def recv_nextK()
        result = receive_message(NextK_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'nextK failed: unknown result')
      end

      def closeScanner(scanner)
        send_closeScanner(scanner)
        recv_closeScanner()
      end

      def send_closeScanner(scanner)
        send_message('closeScanner', CloseScanner_args, :scanner => scanner)
      end

      def recv_closeScanner()
        result = receive_message(CloseScanner_result)
        raise result.ouch1 unless result.ouch1.nil?
        return
      end

      def updateAndFlush(sharedSecret, tableName, cells)
        send_updateAndFlush(sharedSecret, tableName, cells)
        recv_updateAndFlush()
      end

      def send_updateAndFlush(sharedSecret, tableName, cells)
        send_message('updateAndFlush', UpdateAndFlush_args, :sharedSecret => sharedSecret, :tableName => tableName, :cells => cells)
      end

      def recv_updateAndFlush()
        result = receive_message(UpdateAndFlush_result)
        raise result.outch1 unless result.outch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise result.ouch4 unless result.ouch4.nil?
        return
      end

      def createWriter(sharedSecret, tableName, opts)
        send_createWriter(sharedSecret, tableName, opts)
        return recv_createWriter()
      end

      def send_createWriter(sharedSecret, tableName, opts)
        send_message('createWriter', CreateWriter_args, :sharedSecret => sharedSecret, :tableName => tableName, :opts => opts)
      end

      def recv_createWriter()
        result = receive_message(CreateWriter_result)
        return result.success unless result.success.nil?
        raise result.outch1 unless result.outch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'createWriter failed: unknown result')
      end

      def update(writer, cells)
        send_update(writer, cells)
      end

      def send_update(writer, cells)
        send_oneway_message('update', Update_args, :writer => writer, :cells => cells)
      end
      def flush(writer)
        send_flush(writer)
        recv_flush()
      end

      def send_flush(writer)
        send_message('flush', Flush_args, :writer => writer)
      end

      def recv_flush()
        result = receive_message(Flush_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def closeWriter(writer)
        send_closeWriter(writer)
        recv_closeWriter()
      end

      def send_closeWriter(writer)
        send_message('closeWriter', CloseWriter_args, :writer => writer)
      end

      def recv_closeWriter()
        result = receive_message(CloseWriter_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        return
      end

      def updateRowConditionally(sharedSecret, tableName, row, updates)
        send_updateRowConditionally(sharedSecret, tableName, row, updates)
        return recv_updateRowConditionally()
      end

      def send_updateRowConditionally(sharedSecret, tableName, row, updates)
        send_message('updateRowConditionally', UpdateRowConditionally_args, :sharedSecret => sharedSecret, :tableName => tableName, :row => row, :updates => updates)
      end

      def recv_updateRowConditionally()
        result = receive_message(UpdateRowConditionally_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'updateRowConditionally failed: unknown result')
      end

      def createConditionalWriter(sharedSecret, tableName, options)
        send_createConditionalWriter(sharedSecret, tableName, options)
        return recv_createConditionalWriter()
      end

      def send_createConditionalWriter(sharedSecret, tableName, options)
        send_message('createConditionalWriter', CreateConditionalWriter_args, :sharedSecret => sharedSecret, :tableName => tableName, :options => options)
      end

      def recv_createConditionalWriter()
        result = receive_message(CreateConditionalWriter_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'createConditionalWriter failed: unknown result')
      end

      def updateRowsConditionally(conditionalWriter, updates)
        send_updateRowsConditionally(conditionalWriter, updates)
        return recv_updateRowsConditionally()
      end

      def send_updateRowsConditionally(conditionalWriter, updates)
        send_message('updateRowsConditionally', UpdateRowsConditionally_args, :conditionalWriter => conditionalWriter, :updates => updates)
      end

      def recv_updateRowsConditionally()
        result = receive_message(UpdateRowsConditionally_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'updateRowsConditionally failed: unknown result')
      end

      def closeConditionalWriter(conditionalWriter)
        send_closeConditionalWriter(conditionalWriter)
        recv_closeConditionalWriter()
      end

      def send_closeConditionalWriter(conditionalWriter)
        send_message('closeConditionalWriter', CloseConditionalWriter_args, :conditionalWriter => conditionalWriter)
      end

      def recv_closeConditionalWriter()
        result = receive_message(CloseConditionalWriter_result)
        return
      end

      def getRowRange(row)
        send_getRowRange(row)
        return recv_getRowRange()
      end

      def send_getRowRange(row)
        send_message('getRowRange', GetRowRange_args, :row => row)
      end

      def recv_getRowRange()
        result = receive_message(GetRowRange_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getRowRange failed: unknown result')
      end

      def getFollowing(key, part)
        send_getFollowing(key, part)
        return recv_getFollowing()
      end

      def send_getFollowing(key, part)
        send_message('getFollowing', GetFollowing_args, :key => key, :part => part)
      end

      def recv_getFollowing()
        result = receive_message(GetFollowing_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getFollowing failed: unknown result')
      end

      def systemNamespace()
        send_systemNamespace()
        return recv_systemNamespace()
      end

      def send_systemNamespace()
        send_message('systemNamespace', SystemNamespace_args)
      end

      def recv_systemNamespace()
        result = receive_message(SystemNamespace_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'systemNamespace failed: unknown result')
      end

      def defaultNamespace()
        send_defaultNamespace()
        return recv_defaultNamespace()
      end

      def send_defaultNamespace()
        send_message('defaultNamespace', DefaultNamespace_args)
      end

      def recv_defaultNamespace()
        result = receive_message(DefaultNamespace_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'defaultNamespace failed: unknown result')
      end

      def listNamespaces(sharedSecret)
        send_listNamespaces(sharedSecret)
        return recv_listNamespaces()
      end

      def send_listNamespaces(sharedSecret)
        send_message('listNamespaces', ListNamespaces_args, :sharedSecret => sharedSecret)
      end

      def recv_listNamespaces()
        result = receive_message(ListNamespaces_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listNamespaces failed: unknown result')
      end

      def namespaceExists(sharedSecret, namespaceName)
        send_namespaceExists(sharedSecret, namespaceName)
        return recv_namespaceExists()
      end

      def send_namespaceExists(sharedSecret, namespaceName)
        send_message('namespaceExists', NamespaceExists_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName)
      end

      def recv_namespaceExists()
        result = receive_message(NamespaceExists_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'namespaceExists failed: unknown result')
      end

      def createNamespace(sharedSecret, namespaceName)
        send_createNamespace(sharedSecret, namespaceName)
        recv_createNamespace()
      end

      def send_createNamespace(sharedSecret, namespaceName)
        send_message('createNamespace', CreateNamespace_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName)
      end

      def recv_createNamespace()
        result = receive_message(CreateNamespace_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def deleteNamespace(sharedSecret, namespaceName)
        send_deleteNamespace(sharedSecret, namespaceName)
        recv_deleteNamespace()
      end

      def send_deleteNamespace(sharedSecret, namespaceName)
        send_message('deleteNamespace', DeleteNamespace_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName)
      end

      def recv_deleteNamespace()
        result = receive_message(DeleteNamespace_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise result.ouch4 unless result.ouch4.nil?
        return
      end

      def renameNamespace(sharedSecret, oldNamespaceName, newNamespaceName)
        send_renameNamespace(sharedSecret, oldNamespaceName, newNamespaceName)
        recv_renameNamespace()
      end

      def send_renameNamespace(sharedSecret, oldNamespaceName, newNamespaceName)
        send_message('renameNamespace', RenameNamespace_args, :sharedSecret => sharedSecret, :oldNamespaceName => oldNamespaceName, :newNamespaceName => newNamespaceName)
      end

      def recv_renameNamespace()
        result = receive_message(RenameNamespace_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise result.ouch4 unless result.ouch4.nil?
        return
      end

      def setNamespaceProperty(sharedSecret, namespaceName, property, value)
        send_setNamespaceProperty(sharedSecret, namespaceName, property, value)
        recv_setNamespaceProperty()
      end

      def send_setNamespaceProperty(sharedSecret, namespaceName, property, value)
        send_message('setNamespaceProperty', SetNamespaceProperty_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :property => property, :value => value)
      end

      def recv_setNamespaceProperty()
        result = receive_message(SetNamespaceProperty_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def removeNamespaceProperty(sharedSecret, namespaceName, property)
        send_removeNamespaceProperty(sharedSecret, namespaceName, property)
        recv_removeNamespaceProperty()
      end

      def send_removeNamespaceProperty(sharedSecret, namespaceName, property)
        send_message('removeNamespaceProperty', RemoveNamespaceProperty_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :property => property)
      end

      def recv_removeNamespaceProperty()
        result = receive_message(RemoveNamespaceProperty_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def getNamespaceProperties(sharedSecret, namespaceName)
        send_getNamespaceProperties(sharedSecret, namespaceName)
        return recv_getNamespaceProperties()
      end

      def send_getNamespaceProperties(sharedSecret, namespaceName)
        send_message('getNamespaceProperties', GetNamespaceProperties_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName)
      end

      def recv_getNamespaceProperties()
        result = receive_message(GetNamespaceProperties_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getNamespaceProperties failed: unknown result')
      end

      def namespaceIdMap(sharedSecret)
        send_namespaceIdMap(sharedSecret)
        return recv_namespaceIdMap()
      end

      def send_namespaceIdMap(sharedSecret)
        send_message('namespaceIdMap', NamespaceIdMap_args, :sharedSecret => sharedSecret)
      end

      def recv_namespaceIdMap()
        result = receive_message(NamespaceIdMap_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'namespaceIdMap failed: unknown result')
      end

      def attachNamespaceIterator(sharedSecret, namespaceName, setting, scopes)
        send_attachNamespaceIterator(sharedSecret, namespaceName, setting, scopes)
        recv_attachNamespaceIterator()
      end

      def send_attachNamespaceIterator(sharedSecret, namespaceName, setting, scopes)
        send_message('attachNamespaceIterator', AttachNamespaceIterator_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :setting => setting, :scopes => scopes)
      end

      def recv_attachNamespaceIterator()
        result = receive_message(AttachNamespaceIterator_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def removeNamespaceIterator(sharedSecret, namespaceName, name, scopes)
        send_removeNamespaceIterator(sharedSecret, namespaceName, name, scopes)
        recv_removeNamespaceIterator()
      end

      def send_removeNamespaceIterator(sharedSecret, namespaceName, name, scopes)
        send_message('removeNamespaceIterator', RemoveNamespaceIterator_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :name => name, :scopes => scopes)
      end

      def recv_removeNamespaceIterator()
        result = receive_message(RemoveNamespaceIterator_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def getNamespaceIteratorSetting(sharedSecret, namespaceName, name, scope)
        send_getNamespaceIteratorSetting(sharedSecret, namespaceName, name, scope)
        return recv_getNamespaceIteratorSetting()
      end

      def send_getNamespaceIteratorSetting(sharedSecret, namespaceName, name, scope)
        send_message('getNamespaceIteratorSetting', GetNamespaceIteratorSetting_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :name => name, :scope => scope)
      end

      def recv_getNamespaceIteratorSetting()
        result = receive_message(GetNamespaceIteratorSetting_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'getNamespaceIteratorSetting failed: unknown result')
      end

      def listNamespaceIterators(sharedSecret, namespaceName)
        send_listNamespaceIterators(sharedSecret, namespaceName)
        return recv_listNamespaceIterators()
      end

      def send_listNamespaceIterators(sharedSecret, namespaceName)
        send_message('listNamespaceIterators', ListNamespaceIterators_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName)
      end

      def recv_listNamespaceIterators()
        result = receive_message(ListNamespaceIterators_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listNamespaceIterators failed: unknown result')
      end

      def checkNamespaceIteratorConflicts(sharedSecret, namespaceName, setting, scopes)
        send_checkNamespaceIteratorConflicts(sharedSecret, namespaceName, setting, scopes)
        recv_checkNamespaceIteratorConflicts()
      end

      def send_checkNamespaceIteratorConflicts(sharedSecret, namespaceName, setting, scopes)
        send_message('checkNamespaceIteratorConflicts', CheckNamespaceIteratorConflicts_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :setting => setting, :scopes => scopes)
      end

      def recv_checkNamespaceIteratorConflicts()
        result = receive_message(CheckNamespaceIteratorConflicts_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def addNamespaceConstraint(sharedSecret, namespaceName, constraintClassName)
        send_addNamespaceConstraint(sharedSecret, namespaceName, constraintClassName)
        return recv_addNamespaceConstraint()
      end

      def send_addNamespaceConstraint(sharedSecret, namespaceName, constraintClassName)
        send_message('addNamespaceConstraint', AddNamespaceConstraint_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :constraintClassName => constraintClassName)
      end

      def recv_addNamespaceConstraint()
        result = receive_message(AddNamespaceConstraint_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'addNamespaceConstraint failed: unknown result')
      end

      def removeNamespaceConstraint(sharedSecret, namespaceName, id)
        send_removeNamespaceConstraint(sharedSecret, namespaceName, id)
        recv_removeNamespaceConstraint()
      end

      def send_removeNamespaceConstraint(sharedSecret, namespaceName, id)
        send_message('removeNamespaceConstraint', RemoveNamespaceConstraint_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :id => id)
      end

      def recv_removeNamespaceConstraint()
        result = receive_message(RemoveNamespaceConstraint_result)
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        return
      end

      def listNamespaceConstraints(sharedSecret, namespaceName)
        send_listNamespaceConstraints(sharedSecret, namespaceName)
        return recv_listNamespaceConstraints()
      end

      def send_listNamespaceConstraints(sharedSecret, namespaceName)
        send_message('listNamespaceConstraints', ListNamespaceConstraints_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName)
      end

      def recv_listNamespaceConstraints()
        result = receive_message(ListNamespaceConstraints_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'listNamespaceConstraints failed: unknown result')
      end

      def testNamespaceClassLoad(sharedSecret, namespaceName, className, asTypeName)
        send_testNamespaceClassLoad(sharedSecret, namespaceName, className, asTypeName)
        return recv_testNamespaceClassLoad()
      end

      def send_testNamespaceClassLoad(sharedSecret, namespaceName, className, asTypeName)
        send_message('testNamespaceClassLoad', TestNamespaceClassLoad_args, :sharedSecret => sharedSecret, :namespaceName => namespaceName, :className => className, :asTypeName => asTypeName)
      end

      def recv_testNamespaceClassLoad()
        result = receive_message(TestNamespaceClassLoad_result)
        return result.success unless result.success.nil?
        raise result.ouch1 unless result.ouch1.nil?
        raise result.ouch2 unless result.ouch2.nil?
        raise result.ouch3 unless result.ouch3.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'testNamespaceClassLoad failed: unknown result')
      end

    end

    class Processor
      include ::Thrift::Processor

      def process_addConstraint(seqid, iprot, oprot)
        args = read_args(iprot, AddConstraint_args)
        result = AddConstraint_result.new()
        begin
          result.success = @handler.addConstraint(args.sharedSecret, args.tableName, args.constraintClassName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'addConstraint', seqid)
      end

      def process_addSplits(seqid, iprot, oprot)
        args = read_args(iprot, AddSplits_args)
        result = AddSplits_result.new()
        begin
          @handler.addSplits(args.sharedSecret, args.tableName, args.splits)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'addSplits', seqid)
      end

      def process_attachIterator(seqid, iprot, oprot)
        args = read_args(iprot, AttachIterator_args)
        result = AttachIterator_result.new()
        begin
          @handler.attachIterator(args.sharedSecret, args.tableName, args.setting, args.scopes)
        rescue ::Accumulo::AccumuloSecurityException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'attachIterator', seqid)
      end

      def process_checkIteratorConflicts(seqid, iprot, oprot)
        args = read_args(iprot, CheckIteratorConflicts_args)
        result = CheckIteratorConflicts_result.new()
        begin
          @handler.checkIteratorConflicts(args.sharedSecret, args.tableName, args.setting, args.scopes)
        rescue ::Accumulo::AccumuloSecurityException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'checkIteratorConflicts', seqid)
      end

      def process_clearLocatorCache(seqid, iprot, oprot)
        args = read_args(iprot, ClearLocatorCache_args)
        result = ClearLocatorCache_result.new()
        begin
          @handler.clearLocatorCache(args.sharedSecret, args.tableName)
        rescue ::Accumulo::TableNotFoundException => ouch1
          result.ouch1 = ouch1
        end
        write_result(result, oprot, 'clearLocatorCache', seqid)
      end

      def process_cloneTable(seqid, iprot, oprot)
        args = read_args(iprot, CloneTable_args)
        result = CloneTable_result.new()
        begin
          @handler.cloneTable(args.sharedSecret, args.tableName, args.newTableName, args.flush, args.propertiesToSet, args.propertiesToExclude)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        rescue ::Accumulo::TableExistsException => ouch4
          result.ouch4 = ouch4
        end
        write_result(result, oprot, 'cloneTable', seqid)
      end

      def process_compactTable(seqid, iprot, oprot)
        args = read_args(iprot, CompactTable_args)
        result = CompactTable_result.new()
        begin
          @handler.compactTable(args.sharedSecret, args.tableName, args.startRow, args.endRow, args.iterators, args.flush, args.wait, args.selectorConfig, args.configurerConfig)
        rescue ::Accumulo::AccumuloSecurityException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::TableNotFoundException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::AccumuloException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'compactTable', seqid)
      end

      def process_cancelCompaction(seqid, iprot, oprot)
        args = read_args(iprot, CancelCompaction_args)
        result = CancelCompaction_result.new()
        begin
          @handler.cancelCompaction(args.sharedSecret, args.tableName)
        rescue ::Accumulo::AccumuloSecurityException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::TableNotFoundException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::AccumuloException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'cancelCompaction', seqid)
      end

      def process_createTable(seqid, iprot, oprot)
        args = read_args(iprot, CreateTable_args)
        result = CreateTable_result.new()
        begin
          @handler.createTable(args.sharedSecret, args.tableName, args.versioningIter, args.type)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableExistsException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'createTable', seqid)
      end

      def process_deleteTable(seqid, iprot, oprot)
        args = read_args(iprot, DeleteTable_args)
        result = DeleteTable_result.new()
        begin
          @handler.deleteTable(args.sharedSecret, args.tableName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'deleteTable', seqid)
      end

      def process_deleteRows(seqid, iprot, oprot)
        args = read_args(iprot, DeleteRows_args)
        result = DeleteRows_result.new()
        begin
          @handler.deleteRows(args.sharedSecret, args.tableName, args.startRow, args.endRow)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'deleteRows', seqid)
      end

      def process_exportTable(seqid, iprot, oprot)
        args = read_args(iprot, ExportTable_args)
        result = ExportTable_result.new()
        begin
          @handler.exportTable(args.sharedSecret, args.tableName, args.exportDir)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'exportTable', seqid)
      end

      def process_flushTable(seqid, iprot, oprot)
        args = read_args(iprot, FlushTable_args)
        result = FlushTable_result.new()
        begin
          @handler.flushTable(args.sharedSecret, args.tableName, args.startRow, args.endRow, args.wait)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'flushTable', seqid)
      end

      def process_getDiskUsage(seqid, iprot, oprot)
        args = read_args(iprot, GetDiskUsage_args)
        result = GetDiskUsage_result.new()
        begin
          result.success = @handler.getDiskUsage(args.sharedSecret, args.tables)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getDiskUsage', seqid)
      end

      def process_getLocalityGroups(seqid, iprot, oprot)
        args = read_args(iprot, GetLocalityGroups_args)
        result = GetLocalityGroups_result.new()
        begin
          result.success = @handler.getLocalityGroups(args.sharedSecret, args.tableName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getLocalityGroups', seqid)
      end

      def process_getIteratorSetting(seqid, iprot, oprot)
        args = read_args(iprot, GetIteratorSetting_args)
        result = GetIteratorSetting_result.new()
        begin
          result.success = @handler.getIteratorSetting(args.sharedSecret, args.tableName, args.iteratorName, args.scope)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getIteratorSetting', seqid)
      end

      def process_getMaxRow(seqid, iprot, oprot)
        args = read_args(iprot, GetMaxRow_args)
        result = GetMaxRow_result.new()
        begin
          result.success = @handler.getMaxRow(args.sharedSecret, args.tableName, args.auths, args.startRow, args.startInclusive, args.endRow, args.endInclusive)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getMaxRow', seqid)
      end

      def process_getTableProperties(seqid, iprot, oprot)
        args = read_args(iprot, GetTableProperties_args)
        result = GetTableProperties_result.new()
        begin
          result.success = @handler.getTableProperties(args.sharedSecret, args.tableName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getTableProperties', seqid)
      end

      def process_importDirectory(seqid, iprot, oprot)
        args = read_args(iprot, ImportDirectory_args)
        result = ImportDirectory_result.new()
        begin
          @handler.importDirectory(args.sharedSecret, args.tableName, args.importDir, args.failureDir, args.setTime)
        rescue ::Accumulo::TableNotFoundException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloException => ouch3
          result.ouch3 = ouch3
        rescue ::Accumulo::AccumuloSecurityException => ouch4
          result.ouch4 = ouch4
        end
        write_result(result, oprot, 'importDirectory', seqid)
      end

      def process_importTable(seqid, iprot, oprot)
        args = read_args(iprot, ImportTable_args)
        result = ImportTable_result.new()
        begin
          @handler.importTable(args.sharedSecret, args.tableName, args.importDir)
        rescue ::Accumulo::TableExistsException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::AccumuloSecurityException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'importTable', seqid)
      end

      def process_listSplits(seqid, iprot, oprot)
        args = read_args(iprot, ListSplits_args)
        result = ListSplits_result.new()
        begin
          result.success = @handler.listSplits(args.sharedSecret, args.tableName, args.maxSplits)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'listSplits', seqid)
      end

      def process_listTables(seqid, iprot, oprot)
        args = read_args(iprot, ListTables_args)
        result = ListTables_result.new()
        result.success = @handler.listTables(args.sharedSecret)
        write_result(result, oprot, 'listTables', seqid)
      end

      def process_listIterators(seqid, iprot, oprot)
        args = read_args(iprot, ListIterators_args)
        result = ListIterators_result.new()
        begin
          result.success = @handler.listIterators(args.sharedSecret, args.tableName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'listIterators', seqid)
      end

      def process_listConstraints(seqid, iprot, oprot)
        args = read_args(iprot, ListConstraints_args)
        result = ListConstraints_result.new()
        begin
          result.success = @handler.listConstraints(args.sharedSecret, args.tableName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'listConstraints', seqid)
      end

      def process_mergeTablets(seqid, iprot, oprot)
        args = read_args(iprot, MergeTablets_args)
        result = MergeTablets_result.new()
        begin
          @handler.mergeTablets(args.sharedSecret, args.tableName, args.startRow, args.endRow)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'mergeTablets', seqid)
      end

      def process_offlineTable(seqid, iprot, oprot)
        args = read_args(iprot, OfflineTable_args)
        result = OfflineTable_result.new()
        begin
          @handler.offlineTable(args.sharedSecret, args.tableName, args.wait)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'offlineTable', seqid)
      end

      def process_onlineTable(seqid, iprot, oprot)
        args = read_args(iprot, OnlineTable_args)
        result = OnlineTable_result.new()
        begin
          @handler.onlineTable(args.sharedSecret, args.tableName, args.wait)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'onlineTable', seqid)
      end

      def process_removeConstraint(seqid, iprot, oprot)
        args = read_args(iprot, RemoveConstraint_args)
        result = RemoveConstraint_result.new()
        begin
          @handler.removeConstraint(args.sharedSecret, args.tableName, args.constraint)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'removeConstraint', seqid)
      end

      def process_removeIterator(seqid, iprot, oprot)
        args = read_args(iprot, RemoveIterator_args)
        result = RemoveIterator_result.new()
        begin
          @handler.removeIterator(args.sharedSecret, args.tableName, args.iterName, args.scopes)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'removeIterator', seqid)
      end

      def process_removeTableProperty(seqid, iprot, oprot)
        args = read_args(iprot, RemoveTableProperty_args)
        result = RemoveTableProperty_result.new()
        begin
          @handler.removeTableProperty(args.sharedSecret, args.tableName, args.property)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'removeTableProperty', seqid)
      end

      def process_renameTable(seqid, iprot, oprot)
        args = read_args(iprot, RenameTable_args)
        result = RenameTable_result.new()
        begin
          @handler.renameTable(args.sharedSecret, args.oldTableName, args.newTableName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        rescue ::Accumulo::TableExistsException => ouch4
          result.ouch4 = ouch4
        end
        write_result(result, oprot, 'renameTable', seqid)
      end

      def process_setLocalityGroups(seqid, iprot, oprot)
        args = read_args(iprot, SetLocalityGroups_args)
        result = SetLocalityGroups_result.new()
        begin
          @handler.setLocalityGroups(args.sharedSecret, args.tableName, args.groups)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'setLocalityGroups', seqid)
      end

      def process_setTableProperty(seqid, iprot, oprot)
        args = read_args(iprot, SetTableProperty_args)
        result = SetTableProperty_result.new()
        begin
          @handler.setTableProperty(args.sharedSecret, args.tableName, args.property, args.value)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'setTableProperty', seqid)
      end

      def process_splitRangeByTablets(seqid, iprot, oprot)
        args = read_args(iprot, SplitRangeByTablets_args)
        result = SplitRangeByTablets_result.new()
        begin
          result.success = @handler.splitRangeByTablets(args.sharedSecret, args.tableName, args.range, args.maxSplits)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'splitRangeByTablets', seqid)
      end

      def process_tableExists(seqid, iprot, oprot)
        args = read_args(iprot, TableExists_args)
        result = TableExists_result.new()
        result.success = @handler.tableExists(args.sharedSecret, args.tableName)
        write_result(result, oprot, 'tableExists', seqid)
      end

      def process_tableIdMap(seqid, iprot, oprot)
        args = read_args(iprot, TableIdMap_args)
        result = TableIdMap_result.new()
        result.success = @handler.tableIdMap(args.sharedSecret)
        write_result(result, oprot, 'tableIdMap', seqid)
      end

      def process_testTableClassLoad(seqid, iprot, oprot)
        args = read_args(iprot, TestTableClassLoad_args)
        result = TestTableClassLoad_result.new()
        begin
          result.success = @handler.testTableClassLoad(args.sharedSecret, args.tableName, args.className, args.asTypeName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'testTableClassLoad', seqid)
      end

      def process_pingTabletServer(seqid, iprot, oprot)
        args = read_args(iprot, PingTabletServer_args)
        result = PingTabletServer_result.new()
        begin
          @handler.pingTabletServer(args.sharedSecret, args.tserver)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'pingTabletServer', seqid)
      end

      def process_getActiveScans(seqid, iprot, oprot)
        args = read_args(iprot, GetActiveScans_args)
        result = GetActiveScans_result.new()
        begin
          result.success = @handler.getActiveScans(args.sharedSecret, args.tserver)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'getActiveScans', seqid)
      end

      def process_getActiveCompactions(seqid, iprot, oprot)
        args = read_args(iprot, GetActiveCompactions_args)
        result = GetActiveCompactions_result.new()
        begin
          result.success = @handler.getActiveCompactions(args.sharedSecret, args.tserver)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'getActiveCompactions', seqid)
      end

      def process_getSiteConfiguration(seqid, iprot, oprot)
        args = read_args(iprot, GetSiteConfiguration_args)
        result = GetSiteConfiguration_result.new()
        begin
          result.success = @handler.getSiteConfiguration(args.sharedSecret)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'getSiteConfiguration', seqid)
      end

      def process_getSystemConfiguration(seqid, iprot, oprot)
        args = read_args(iprot, GetSystemConfiguration_args)
        result = GetSystemConfiguration_result.new()
        begin
          result.success = @handler.getSystemConfiguration(args.sharedSecret)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'getSystemConfiguration', seqid)
      end

      def process_getTabletServers(seqid, iprot, oprot)
        args = read_args(iprot, GetTabletServers_args)
        result = GetTabletServers_result.new()
        result.success = @handler.getTabletServers(args.sharedSecret)
        write_result(result, oprot, 'getTabletServers', seqid)
      end

      def process_removeProperty(seqid, iprot, oprot)
        args = read_args(iprot, RemoveProperty_args)
        result = RemoveProperty_result.new()
        begin
          @handler.removeProperty(args.sharedSecret, args.property)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'removeProperty', seqid)
      end

      def process_setProperty(seqid, iprot, oprot)
        args = read_args(iprot, SetProperty_args)
        result = SetProperty_result.new()
        begin
          @handler.setProperty(args.sharedSecret, args.property, args.value)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'setProperty', seqid)
      end

      def process_testClassLoad(seqid, iprot, oprot)
        args = read_args(iprot, TestClassLoad_args)
        result = TestClassLoad_result.new()
        begin
          result.success = @handler.testClassLoad(args.sharedSecret, args.className, args.asTypeName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'testClassLoad', seqid)
      end

      def process_authenticateUser(seqid, iprot, oprot)
        args = read_args(iprot, AuthenticateUser_args)
        result = AuthenticateUser_result.new()
        begin
          result.success = @handler.authenticateUser(args.sharedSecret, args.user, args.properties)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'authenticateUser', seqid)
      end

      def process_changeUserAuthorizations(seqid, iprot, oprot)
        args = read_args(iprot, ChangeUserAuthorizations_args)
        result = ChangeUserAuthorizations_result.new()
        begin
          @handler.changeUserAuthorizations(args.sharedSecret, args.user, args.authorizations)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'changeUserAuthorizations', seqid)
      end

      def process_changeLocalUserPassword(seqid, iprot, oprot)
        args = read_args(iprot, ChangeLocalUserPassword_args)
        result = ChangeLocalUserPassword_result.new()
        begin
          @handler.changeLocalUserPassword(args.sharedSecret, args.user, args.password)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'changeLocalUserPassword', seqid)
      end

      def process_createLocalUser(seqid, iprot, oprot)
        args = read_args(iprot, CreateLocalUser_args)
        result = CreateLocalUser_result.new()
        begin
          @handler.createLocalUser(args.sharedSecret, args.user, args.password)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'createLocalUser', seqid)
      end

      def process_dropLocalUser(seqid, iprot, oprot)
        args = read_args(iprot, DropLocalUser_args)
        result = DropLocalUser_result.new()
        begin
          @handler.dropLocalUser(args.sharedSecret, args.user)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'dropLocalUser', seqid)
      end

      def process_getUserAuthorizations(seqid, iprot, oprot)
        args = read_args(iprot, GetUserAuthorizations_args)
        result = GetUserAuthorizations_result.new()
        begin
          result.success = @handler.getUserAuthorizations(args.sharedSecret, args.user)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'getUserAuthorizations', seqid)
      end

      def process_grantSystemPermission(seqid, iprot, oprot)
        args = read_args(iprot, GrantSystemPermission_args)
        result = GrantSystemPermission_result.new()
        begin
          @handler.grantSystemPermission(args.sharedSecret, args.user, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'grantSystemPermission', seqid)
      end

      def process_grantTablePermission(seqid, iprot, oprot)
        args = read_args(iprot, GrantTablePermission_args)
        result = GrantTablePermission_result.new()
        begin
          @handler.grantTablePermission(args.sharedSecret, args.user, args.table, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'grantTablePermission', seqid)
      end

      def process_hasSystemPermission(seqid, iprot, oprot)
        args = read_args(iprot, HasSystemPermission_args)
        result = HasSystemPermission_result.new()
        begin
          result.success = @handler.hasSystemPermission(args.sharedSecret, args.user, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'hasSystemPermission', seqid)
      end

      def process_hasTablePermission(seqid, iprot, oprot)
        args = read_args(iprot, HasTablePermission_args)
        result = HasTablePermission_result.new()
        begin
          result.success = @handler.hasTablePermission(args.sharedSecret, args.user, args.table, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'hasTablePermission', seqid)
      end

      def process_listLocalUsers(seqid, iprot, oprot)
        args = read_args(iprot, ListLocalUsers_args)
        result = ListLocalUsers_result.new()
        begin
          result.success = @handler.listLocalUsers(args.sharedSecret)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'listLocalUsers', seqid)
      end

      def process_revokeSystemPermission(seqid, iprot, oprot)
        args = read_args(iprot, RevokeSystemPermission_args)
        result = RevokeSystemPermission_result.new()
        begin
          @handler.revokeSystemPermission(args.sharedSecret, args.user, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'revokeSystemPermission', seqid)
      end

      def process_revokeTablePermission(seqid, iprot, oprot)
        args = read_args(iprot, RevokeTablePermission_args)
        result = RevokeTablePermission_result.new()
        begin
          @handler.revokeTablePermission(args.sharedSecret, args.user, args.table, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'revokeTablePermission', seqid)
      end

      def process_grantNamespacePermission(seqid, iprot, oprot)
        args = read_args(iprot, GrantNamespacePermission_args)
        result = GrantNamespacePermission_result.new()
        begin
          @handler.grantNamespacePermission(args.sharedSecret, args.user, args.namespaceName, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'grantNamespacePermission', seqid)
      end

      def process_hasNamespacePermission(seqid, iprot, oprot)
        args = read_args(iprot, HasNamespacePermission_args)
        result = HasNamespacePermission_result.new()
        begin
          result.success = @handler.hasNamespacePermission(args.sharedSecret, args.user, args.namespaceName, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'hasNamespacePermission', seqid)
      end

      def process_revokeNamespacePermission(seqid, iprot, oprot)
        args = read_args(iprot, RevokeNamespacePermission_args)
        result = RevokeNamespacePermission_result.new()
        begin
          @handler.revokeNamespacePermission(args.sharedSecret, args.user, args.namespaceName, args.perm)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'revokeNamespacePermission', seqid)
      end

      def process_createBatchScanner(seqid, iprot, oprot)
        args = read_args(iprot, CreateBatchScanner_args)
        result = CreateBatchScanner_result.new()
        begin
          result.success = @handler.createBatchScanner(args.sharedSecret, args.tableName, args.options)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'createBatchScanner', seqid)
      end

      def process_createScanner(seqid, iprot, oprot)
        args = read_args(iprot, CreateScanner_args)
        result = CreateScanner_result.new()
        begin
          result.success = @handler.createScanner(args.sharedSecret, args.tableName, args.options)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'createScanner', seqid)
      end

      def process_hasNext(seqid, iprot, oprot)
        args = read_args(iprot, HasNext_args)
        result = HasNext_result.new()
        begin
          result.success = @handler.hasNext(args.scanner)
        rescue ::Accumulo::UnknownScanner => ouch1
          result.ouch1 = ouch1
        end
        write_result(result, oprot, 'hasNext', seqid)
      end

      def process_nextEntry(seqid, iprot, oprot)
        args = read_args(iprot, NextEntry_args)
        result = NextEntry_result.new()
        begin
          result.success = @handler.nextEntry(args.scanner)
        rescue ::Accumulo::NoMoreEntriesException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::UnknownScanner => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::AccumuloSecurityException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'nextEntry', seqid)
      end

      def process_nextK(seqid, iprot, oprot)
        args = read_args(iprot, NextK_args)
        result = NextK_result.new()
        begin
          result.success = @handler.nextK(args.scanner, args.k)
        rescue ::Accumulo::NoMoreEntriesException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::UnknownScanner => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::AccumuloSecurityException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'nextK', seqid)
      end

      def process_closeScanner(seqid, iprot, oprot)
        args = read_args(iprot, CloseScanner_args)
        result = CloseScanner_result.new()
        begin
          @handler.closeScanner(args.scanner)
        rescue ::Accumulo::UnknownScanner => ouch1
          result.ouch1 = ouch1
        end
        write_result(result, oprot, 'closeScanner', seqid)
      end

      def process_updateAndFlush(seqid, iprot, oprot)
        args = read_args(iprot, UpdateAndFlush_args)
        result = UpdateAndFlush_result.new()
        begin
          @handler.updateAndFlush(args.sharedSecret, args.tableName, args.cells)
        rescue ::Accumulo::AccumuloException => outch1
          result.outch1 = outch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        rescue ::Accumulo::MutationsRejectedException => ouch4
          result.ouch4 = ouch4
        end
        write_result(result, oprot, 'updateAndFlush', seqid)
      end

      def process_createWriter(seqid, iprot, oprot)
        args = read_args(iprot, CreateWriter_args)
        result = CreateWriter_result.new()
        begin
          result.success = @handler.createWriter(args.sharedSecret, args.tableName, args.opts)
        rescue ::Accumulo::AccumuloException => outch1
          result.outch1 = outch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'createWriter', seqid)
      end

      def process_update(seqid, iprot, oprot)
        args = read_args(iprot, Update_args)
        @handler.update(args.writer, args.cells)
        return
      end

      def process_flush(seqid, iprot, oprot)
        args = read_args(iprot, Flush_args)
        result = Flush_result.new()
        begin
          @handler.flush(args.writer)
        rescue ::Accumulo::UnknownWriter => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::MutationsRejectedException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'flush', seqid)
      end

      def process_closeWriter(seqid, iprot, oprot)
        args = read_args(iprot, CloseWriter_args)
        result = CloseWriter_result.new()
        begin
          @handler.closeWriter(args.writer)
        rescue ::Accumulo::UnknownWriter => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::MutationsRejectedException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'closeWriter', seqid)
      end

      def process_updateRowConditionally(seqid, iprot, oprot)
        args = read_args(iprot, UpdateRowConditionally_args)
        result = UpdateRowConditionally_result.new()
        begin
          result.success = @handler.updateRowConditionally(args.sharedSecret, args.tableName, args.row, args.updates)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'updateRowConditionally', seqid)
      end

      def process_createConditionalWriter(seqid, iprot, oprot)
        args = read_args(iprot, CreateConditionalWriter_args)
        result = CreateConditionalWriter_result.new()
        begin
          result.success = @handler.createConditionalWriter(args.sharedSecret, args.tableName, args.options)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::TableNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'createConditionalWriter', seqid)
      end

      def process_updateRowsConditionally(seqid, iprot, oprot)
        args = read_args(iprot, UpdateRowsConditionally_args)
        result = UpdateRowsConditionally_result.new()
        begin
          result.success = @handler.updateRowsConditionally(args.conditionalWriter, args.updates)
        rescue ::Accumulo::UnknownWriter => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::AccumuloSecurityException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'updateRowsConditionally', seqid)
      end

      def process_closeConditionalWriter(seqid, iprot, oprot)
        args = read_args(iprot, CloseConditionalWriter_args)
        result = CloseConditionalWriter_result.new()
        @handler.closeConditionalWriter(args.conditionalWriter)
        write_result(result, oprot, 'closeConditionalWriter', seqid)
      end

      def process_getRowRange(seqid, iprot, oprot)
        args = read_args(iprot, GetRowRange_args)
        result = GetRowRange_result.new()
        result.success = @handler.getRowRange(args.row)
        write_result(result, oprot, 'getRowRange', seqid)
      end

      def process_getFollowing(seqid, iprot, oprot)
        args = read_args(iprot, GetFollowing_args)
        result = GetFollowing_result.new()
        result.success = @handler.getFollowing(args.key, args.part)
        write_result(result, oprot, 'getFollowing', seqid)
      end

      def process_systemNamespace(seqid, iprot, oprot)
        args = read_args(iprot, SystemNamespace_args)
        result = SystemNamespace_result.new()
        result.success = @handler.systemNamespace()
        write_result(result, oprot, 'systemNamespace', seqid)
      end

      def process_defaultNamespace(seqid, iprot, oprot)
        args = read_args(iprot, DefaultNamespace_args)
        result = DefaultNamespace_result.new()
        result.success = @handler.defaultNamespace()
        write_result(result, oprot, 'defaultNamespace', seqid)
      end

      def process_listNamespaces(seqid, iprot, oprot)
        args = read_args(iprot, ListNamespaces_args)
        result = ListNamespaces_result.new()
        begin
          result.success = @handler.listNamespaces(args.sharedSecret)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'listNamespaces', seqid)
      end

      def process_namespaceExists(seqid, iprot, oprot)
        args = read_args(iprot, NamespaceExists_args)
        result = NamespaceExists_result.new()
        begin
          result.success = @handler.namespaceExists(args.sharedSecret, args.namespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'namespaceExists', seqid)
      end

      def process_createNamespace(seqid, iprot, oprot)
        args = read_args(iprot, CreateNamespace_args)
        result = CreateNamespace_result.new()
        begin
          @handler.createNamespace(args.sharedSecret, args.namespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceExistsException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'createNamespace', seqid)
      end

      def process_deleteNamespace(seqid, iprot, oprot)
        args = read_args(iprot, DeleteNamespace_args)
        result = DeleteNamespace_result.new()
        begin
          @handler.deleteNamespace(args.sharedSecret, args.namespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        rescue ::Accumulo::NamespaceNotEmptyException => ouch4
          result.ouch4 = ouch4
        end
        write_result(result, oprot, 'deleteNamespace', seqid)
      end

      def process_renameNamespace(seqid, iprot, oprot)
        args = read_args(iprot, RenameNamespace_args)
        result = RenameNamespace_result.new()
        begin
          @handler.renameNamespace(args.sharedSecret, args.oldNamespaceName, args.newNamespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        rescue ::Accumulo::NamespaceExistsException => ouch4
          result.ouch4 = ouch4
        end
        write_result(result, oprot, 'renameNamespace', seqid)
      end

      def process_setNamespaceProperty(seqid, iprot, oprot)
        args = read_args(iprot, SetNamespaceProperty_args)
        result = SetNamespaceProperty_result.new()
        begin
          @handler.setNamespaceProperty(args.sharedSecret, args.namespaceName, args.property, args.value)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'setNamespaceProperty', seqid)
      end

      def process_removeNamespaceProperty(seqid, iprot, oprot)
        args = read_args(iprot, RemoveNamespaceProperty_args)
        result = RemoveNamespaceProperty_result.new()
        begin
          @handler.removeNamespaceProperty(args.sharedSecret, args.namespaceName, args.property)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'removeNamespaceProperty', seqid)
      end

      def process_getNamespaceProperties(seqid, iprot, oprot)
        args = read_args(iprot, GetNamespaceProperties_args)
        result = GetNamespaceProperties_result.new()
        begin
          result.success = @handler.getNamespaceProperties(args.sharedSecret, args.namespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getNamespaceProperties', seqid)
      end

      def process_namespaceIdMap(seqid, iprot, oprot)
        args = read_args(iprot, NamespaceIdMap_args)
        result = NamespaceIdMap_result.new()
        begin
          result.success = @handler.namespaceIdMap(args.sharedSecret)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        end
        write_result(result, oprot, 'namespaceIdMap', seqid)
      end

      def process_attachNamespaceIterator(seqid, iprot, oprot)
        args = read_args(iprot, AttachNamespaceIterator_args)
        result = AttachNamespaceIterator_result.new()
        begin
          @handler.attachNamespaceIterator(args.sharedSecret, args.namespaceName, args.setting, args.scopes)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'attachNamespaceIterator', seqid)
      end

      def process_removeNamespaceIterator(seqid, iprot, oprot)
        args = read_args(iprot, RemoveNamespaceIterator_args)
        result = RemoveNamespaceIterator_result.new()
        begin
          @handler.removeNamespaceIterator(args.sharedSecret, args.namespaceName, args.name, args.scopes)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'removeNamespaceIterator', seqid)
      end

      def process_getNamespaceIteratorSetting(seqid, iprot, oprot)
        args = read_args(iprot, GetNamespaceIteratorSetting_args)
        result = GetNamespaceIteratorSetting_result.new()
        begin
          result.success = @handler.getNamespaceIteratorSetting(args.sharedSecret, args.namespaceName, args.name, args.scope)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'getNamespaceIteratorSetting', seqid)
      end

      def process_listNamespaceIterators(seqid, iprot, oprot)
        args = read_args(iprot, ListNamespaceIterators_args)
        result = ListNamespaceIterators_result.new()
        begin
          result.success = @handler.listNamespaceIterators(args.sharedSecret, args.namespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'listNamespaceIterators', seqid)
      end

      def process_checkNamespaceIteratorConflicts(seqid, iprot, oprot)
        args = read_args(iprot, CheckNamespaceIteratorConflicts_args)
        result = CheckNamespaceIteratorConflicts_result.new()
        begin
          @handler.checkNamespaceIteratorConflicts(args.sharedSecret, args.namespaceName, args.setting, args.scopes)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'checkNamespaceIteratorConflicts', seqid)
      end

      def process_addNamespaceConstraint(seqid, iprot, oprot)
        args = read_args(iprot, AddNamespaceConstraint_args)
        result = AddNamespaceConstraint_result.new()
        begin
          result.success = @handler.addNamespaceConstraint(args.sharedSecret, args.namespaceName, args.constraintClassName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'addNamespaceConstraint', seqid)
      end

      def process_removeNamespaceConstraint(seqid, iprot, oprot)
        args = read_args(iprot, RemoveNamespaceConstraint_args)
        result = RemoveNamespaceConstraint_result.new()
        begin
          @handler.removeNamespaceConstraint(args.sharedSecret, args.namespaceName, args.id)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'removeNamespaceConstraint', seqid)
      end

      def process_listNamespaceConstraints(seqid, iprot, oprot)
        args = read_args(iprot, ListNamespaceConstraints_args)
        result = ListNamespaceConstraints_result.new()
        begin
          result.success = @handler.listNamespaceConstraints(args.sharedSecret, args.namespaceName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'listNamespaceConstraints', seqid)
      end

      def process_testNamespaceClassLoad(seqid, iprot, oprot)
        args = read_args(iprot, TestNamespaceClassLoad_args)
        result = TestNamespaceClassLoad_result.new()
        begin
          result.success = @handler.testNamespaceClassLoad(args.sharedSecret, args.namespaceName, args.className, args.asTypeName)
        rescue ::Accumulo::AccumuloException => ouch1
          result.ouch1 = ouch1
        rescue ::Accumulo::AccumuloSecurityException => ouch2
          result.ouch2 = ouch2
        rescue ::Accumulo::NamespaceNotFoundException => ouch3
          result.ouch3 = ouch3
        end
        write_result(result, oprot, 'testNamespaceClassLoad', seqid)
      end

    end

    # HELPER FUNCTIONS AND STRUCTURES

    class AddConstraint_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      CONSTRAINTCLASSNAME = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        CONSTRAINTCLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'constraintClassName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AddConstraint_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::I32, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AddSplits_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      SPLITS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        SPLITS => {:type => ::Thrift::Types::SET, :name => 'splits', :element => {:type => ::Thrift::Types::STRING, :binary => true}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AddSplits_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AttachIterator_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      SETTING = 3
      SCOPES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        SETTING => {:type => ::Thrift::Types::STRUCT, :name => 'setting', :class => ::Accumulo::IteratorSetting},
        SCOPES => {:type => ::Thrift::Types::SET, :name => 'scopes', :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AttachIterator_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloSecurityException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CheckIteratorConflicts_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      SETTING = 3
      SCOPES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        SETTING => {:type => ::Thrift::Types::STRUCT, :name => 'setting', :class => ::Accumulo::IteratorSetting},
        SCOPES => {:type => ::Thrift::Types::SET, :name => 'scopes', :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CheckIteratorConflicts_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloSecurityException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ClearLocatorCache_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ClearLocatorCache_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloneTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      NEWTABLENAME = 3
      FLUSH = 4
      PROPERTIESTOSET = 5
      PROPERTIESTOEXCLUDE = 6

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        NEWTABLENAME => {:type => ::Thrift::Types::STRING, :name => 'newTableName'},
        FLUSH => {:type => ::Thrift::Types::BOOL, :name => 'flush'},
        PROPERTIESTOSET => {:type => ::Thrift::Types::MAP, :name => 'propertiesToSet', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}},
        PROPERTIESTOEXCLUDE => {:type => ::Thrift::Types::SET, :name => 'propertiesToExclude', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloneTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3
      OUCH4 = 4

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException},
        OUCH4 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch4', :class => ::Accumulo::TableExistsException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CompactTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      STARTROW = 3
      ENDROW = 4
      ITERATORS = 5
      FLUSH = 6
      WAIT = 7
      SELECTORCONFIG = 8
      CONFIGURERCONFIG = 9

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        STARTROW => {:type => ::Thrift::Types::STRING, :name => 'startRow', :binary => true},
        ENDROW => {:type => ::Thrift::Types::STRING, :name => 'endRow', :binary => true},
        ITERATORS => {:type => ::Thrift::Types::LIST, :name => 'iterators', :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::IteratorSetting}},
        FLUSH => {:type => ::Thrift::Types::BOOL, :name => 'flush'},
        WAIT => {:type => ::Thrift::Types::BOOL, :name => 'wait'},
        SELECTORCONFIG => {:type => ::Thrift::Types::STRUCT, :name => 'selectorConfig', :class => ::Accumulo::PluginConfig},
        CONFIGURERCONFIG => {:type => ::Thrift::Types::STRUCT, :name => 'configurerConfig', :class => ::Accumulo::PluginConfig}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CompactTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloSecurityException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::TableNotFoundException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CancelCompaction_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CancelCompaction_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloSecurityException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::TableNotFoundException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      VERSIONINGITER = 3
      TYPE = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        VERSIONINGITER => {:type => ::Thrift::Types::BOOL, :name => 'versioningIter'},
        TYPE => {:type => ::Thrift::Types::I32, :name => 'type', :enum_class => ::Accumulo::TimeType}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @type.nil? || ::Accumulo::TimeType::VALID_VALUES.include?(@type)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field type!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableExistsException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DeleteTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DeleteTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DeleteRows_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      STARTROW = 3
      ENDROW = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        STARTROW => {:type => ::Thrift::Types::STRING, :name => 'startRow', :binary => true},
        ENDROW => {:type => ::Thrift::Types::STRING, :name => 'endRow', :binary => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DeleteRows_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ExportTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      EXPORTDIR = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        EXPORTDIR => {:type => ::Thrift::Types::STRING, :name => 'exportDir'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ExportTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class FlushTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      STARTROW = 3
      ENDROW = 4
      WAIT = 5

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        STARTROW => {:type => ::Thrift::Types::STRING, :name => 'startRow', :binary => true},
        ENDROW => {:type => ::Thrift::Types::STRING, :name => 'endRow', :binary => true},
        WAIT => {:type => ::Thrift::Types::BOOL, :name => 'wait'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class FlushTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetDiskUsage_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLES = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLES => {:type => ::Thrift::Types::SET, :name => 'tables', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetDiskUsage_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::DiskUsage}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetLocalityGroups_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetLocalityGroups_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::STRING}}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetIteratorSetting_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      ITERATORNAME = 3
      SCOPE = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        ITERATORNAME => {:type => ::Thrift::Types::STRING, :name => 'iteratorName'},
        SCOPE => {:type => ::Thrift::Types::I32, :name => 'scope', :enum_class => ::Accumulo::IteratorScope}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @scope.nil? || ::Accumulo::IteratorScope::VALID_VALUES.include?(@scope)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field scope!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetIteratorSetting_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::Accumulo::IteratorSetting},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetMaxRow_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      AUTHS = 3
      STARTROW = 4
      STARTINCLUSIVE = 5
      ENDROW = 6
      ENDINCLUSIVE = 7

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        AUTHS => {:type => ::Thrift::Types::SET, :name => 'auths', :element => {:type => ::Thrift::Types::STRING, :binary => true}},
        STARTROW => {:type => ::Thrift::Types::STRING, :name => 'startRow', :binary => true},
        STARTINCLUSIVE => {:type => ::Thrift::Types::BOOL, :name => 'startInclusive'},
        ENDROW => {:type => ::Thrift::Types::STRING, :name => 'endRow', :binary => true},
        ENDINCLUSIVE => {:type => ::Thrift::Types::BOOL, :name => 'endInclusive'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetMaxRow_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success', :binary => true},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetTableProperties_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetTableProperties_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ImportDirectory_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      IMPORTDIR = 3
      FAILUREDIR = 4
      SETTIME = 5

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        IMPORTDIR => {:type => ::Thrift::Types::STRING, :name => 'importDir'},
        FAILUREDIR => {:type => ::Thrift::Types::STRING, :name => 'failureDir'},
        SETTIME => {:type => ::Thrift::Types::BOOL, :name => 'setTime'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ImportDirectory_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH3 = 2
      OUCH4 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::TableNotFoundException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloException},
        OUCH4 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch4', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ImportTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      IMPORTDIR = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        IMPORTDIR => {:type => ::Thrift::Types::STRING, :name => 'importDir'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ImportTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::TableExistsException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListSplits_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      MAXSPLITS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        MAXSPLITS => {:type => ::Thrift::Types::I32, :name => 'maxSplits'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListSplits_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRING, :binary => true}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListTables_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListTables_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::SET, :name => 'success', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListIterators_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListIterators_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListConstraints_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListConstraints_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::I32}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class MergeTablets_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      STARTROW = 3
      ENDROW = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        STARTROW => {:type => ::Thrift::Types::STRING, :name => 'startRow', :binary => true},
        ENDROW => {:type => ::Thrift::Types::STRING, :name => 'endRow', :binary => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class MergeTablets_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class OfflineTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      WAIT = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        WAIT => {:type => ::Thrift::Types::BOOL, :name => 'wait', :default => false}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class OfflineTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class OnlineTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      WAIT = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        WAIT => {:type => ::Thrift::Types::BOOL, :name => 'wait', :default => false}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class OnlineTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveConstraint_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      CONSTRAINT = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        CONSTRAINT => {:type => ::Thrift::Types::I32, :name => 'constraint'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveConstraint_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveIterator_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      ITERNAME = 3
      SCOPES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        ITERNAME => {:type => ::Thrift::Types::STRING, :name => 'iterName'},
        SCOPES => {:type => ::Thrift::Types::SET, :name => 'scopes', :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveIterator_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveTableProperty_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      PROPERTY = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        PROPERTY => {:type => ::Thrift::Types::STRING, :name => 'property'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveTableProperty_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RenameTable_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      OLDTABLENAME = 2
      NEWTABLENAME = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        OLDTABLENAME => {:type => ::Thrift::Types::STRING, :name => 'oldTableName'},
        NEWTABLENAME => {:type => ::Thrift::Types::STRING, :name => 'newTableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RenameTable_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3
      OUCH4 = 4

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException},
        OUCH4 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch4', :class => ::Accumulo::TableExistsException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetLocalityGroups_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      GROUPS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        GROUPS => {:type => ::Thrift::Types::MAP, :name => 'groups', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::STRING}}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetLocalityGroups_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetTableProperty_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      PROPERTY = 3
      VALUE = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        PROPERTY => {:type => ::Thrift::Types::STRING, :name => 'property'},
        VALUE => {:type => ::Thrift::Types::STRING, :name => 'value'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetTableProperty_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SplitRangeByTablets_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      RANGE = 3
      MAXSPLITS = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        RANGE => {:type => ::Thrift::Types::STRUCT, :name => 'range', :class => ::Accumulo::Range},
        MAXSPLITS => {:type => ::Thrift::Types::I32, :name => 'maxSplits'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SplitRangeByTablets_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::SET, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::Range}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TableExists_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TableExists_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TableIdMap_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TableIdMap_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TestTableClassLoad_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      CLASSNAME = 3
      ASTYPENAME = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        CLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'className'},
        ASTYPENAME => {:type => ::Thrift::Types::STRING, :name => 'asTypeName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TestTableClassLoad_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class PingTabletServer_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TSERVER = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TSERVER => {:type => ::Thrift::Types::STRING, :name => 'tserver'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class PingTabletServer_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetActiveScans_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TSERVER = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TSERVER => {:type => ::Thrift::Types::STRING, :name => 'tserver'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetActiveScans_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::ActiveScan}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetActiveCompactions_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TSERVER = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TSERVER => {:type => ::Thrift::Types::STRING, :name => 'tserver'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetActiveCompactions_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::ActiveCompaction}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetSiteConfiguration_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetSiteConfiguration_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetSystemConfiguration_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetSystemConfiguration_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetTabletServers_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetTabletServers_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveProperty_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      PROPERTY = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        PROPERTY => {:type => ::Thrift::Types::STRING, :name => 'property'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveProperty_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetProperty_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      PROPERTY = 2
      VALUE = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        PROPERTY => {:type => ::Thrift::Types::STRING, :name => 'property'},
        VALUE => {:type => ::Thrift::Types::STRING, :name => 'value'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetProperty_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TestClassLoad_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      CLASSNAME = 2
      ASTYPENAME = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        CLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'className'},
        ASTYPENAME => {:type => ::Thrift::Types::STRING, :name => 'asTypeName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TestClassLoad_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AuthenticateUser_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      PROPERTIES = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        PROPERTIES => {:type => ::Thrift::Types::MAP, :name => 'properties', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AuthenticateUser_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ChangeUserAuthorizations_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      AUTHORIZATIONS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        AUTHORIZATIONS => {:type => ::Thrift::Types::SET, :name => 'authorizations', :element => {:type => ::Thrift::Types::STRING, :binary => true}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ChangeUserAuthorizations_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ChangeLocalUserPassword_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      PASSWORD = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        PASSWORD => {:type => ::Thrift::Types::STRING, :name => 'password', :binary => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ChangeLocalUserPassword_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateLocalUser_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      PASSWORD = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        PASSWORD => {:type => ::Thrift::Types::STRING, :name => 'password', :binary => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateLocalUser_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DropLocalUser_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DropLocalUser_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetUserAuthorizations_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetUserAuthorizations_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRING, :binary => true}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GrantSystemPermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      PERM = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::SystemPermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::SystemPermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GrantSystemPermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GrantTablePermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      TABLE = 3
      PERM = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        TABLE => {:type => ::Thrift::Types::STRING, :name => 'table'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::TablePermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::TablePermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GrantTablePermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasSystemPermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      PERM = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::SystemPermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::SystemPermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasSystemPermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasTablePermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      TABLE = 3
      PERM = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        TABLE => {:type => ::Thrift::Types::STRING, :name => 'table'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::TablePermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::TablePermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasTablePermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListLocalUsers_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListLocalUsers_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::SET, :name => 'success', :element => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RevokeSystemPermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      PERM = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::SystemPermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::SystemPermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RevokeSystemPermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RevokeTablePermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      TABLE = 3
      PERM = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        TABLE => {:type => ::Thrift::Types::STRING, :name => 'table'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::TablePermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::TablePermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RevokeTablePermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GrantNamespacePermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      NAMESPACENAME = 3
      PERM = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::NamespacePermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::NamespacePermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GrantNamespacePermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasNamespacePermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      NAMESPACENAME = 3
      PERM = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::NamespacePermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::NamespacePermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasNamespacePermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RevokeNamespacePermission_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      USER = 2
      NAMESPACENAME = 3
      PERM = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        USER => {:type => ::Thrift::Types::STRING, :name => 'user'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        PERM => {:type => ::Thrift::Types::I32, :name => 'perm', :enum_class => ::Accumulo::NamespacePermission}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @perm.nil? || ::Accumulo::NamespacePermission::VALID_VALUES.include?(@perm)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field perm!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RevokeNamespacePermission_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateBatchScanner_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      OPTIONS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        OPTIONS => {:type => ::Thrift::Types::STRUCT, :name => 'options', :class => ::Accumulo::BatchScanOptions}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateBatchScanner_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateScanner_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      OPTIONS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        OPTIONS => {:type => ::Thrift::Types::STRUCT, :name => 'options', :class => ::Accumulo::ScanOptions}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateScanner_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasNext_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SCANNER = 1

      FIELDS = {
        SCANNER => {:type => ::Thrift::Types::STRING, :name => 'scanner'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class HasNext_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::UnknownScanner}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NextEntry_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SCANNER = 1

      FIELDS = {
        SCANNER => {:type => ::Thrift::Types::STRING, :name => 'scanner'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NextEntry_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::Accumulo::KeyValueAndPeek},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::NoMoreEntriesException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::UnknownScanner},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NextK_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SCANNER = 1
      K = 2

      FIELDS = {
        SCANNER => {:type => ::Thrift::Types::STRING, :name => 'scanner'},
        K => {:type => ::Thrift::Types::I32, :name => 'k'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NextK_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::Accumulo::ScanResult},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::NoMoreEntriesException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::UnknownScanner},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloseScanner_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SCANNER = 1

      FIELDS = {
        SCANNER => {:type => ::Thrift::Types::STRING, :name => 'scanner'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloseScanner_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::UnknownScanner}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class UpdateAndFlush_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      CELLS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        CELLS => {:type => ::Thrift::Types::MAP, :name => 'cells', :key => {:type => ::Thrift::Types::STRING, :binary => true}, :value => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::ColumnUpdate}}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class UpdateAndFlush_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUTCH1 = 1
      OUCH2 = 2
      OUCH3 = 3
      OUCH4 = 4

      FIELDS = {
        OUTCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'outch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException},
        OUCH4 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch4', :class => ::Accumulo::MutationsRejectedException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateWriter_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      OPTS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        OPTS => {:type => ::Thrift::Types::STRUCT, :name => 'opts', :class => ::Accumulo::WriterOptions}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateWriter_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUTCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'},
        OUTCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'outch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class Update_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      WRITER = 1
      CELLS = 2

      FIELDS = {
        WRITER => {:type => ::Thrift::Types::STRING, :name => 'writer'},
        CELLS => {:type => ::Thrift::Types::MAP, :name => 'cells', :key => {:type => ::Thrift::Types::STRING, :binary => true}, :value => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::ColumnUpdate}}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class Update_result
      include ::Thrift::Struct, ::Thrift::Struct_Union

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class Flush_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      WRITER = 1

      FIELDS = {
        WRITER => {:type => ::Thrift::Types::STRING, :name => 'writer'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class Flush_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::UnknownWriter},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::MutationsRejectedException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloseWriter_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      WRITER = 1

      FIELDS = {
        WRITER => {:type => ::Thrift::Types::STRING, :name => 'writer'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloseWriter_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::UnknownWriter},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::MutationsRejectedException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class UpdateRowConditionally_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      ROW = 3
      UPDATES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        ROW => {:type => ::Thrift::Types::STRING, :name => 'row', :binary => true},
        UPDATES => {:type => ::Thrift::Types::STRUCT, :name => 'updates', :class => ::Accumulo::ConditionalUpdates}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class UpdateRowConditionally_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::I32, :name => 'success', :enum_class => ::Accumulo::ConditionalStatus},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @success.nil? || ::Accumulo::ConditionalStatus::VALID_VALUES.include?(@success)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field success!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateConditionalWriter_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      TABLENAME = 2
      OPTIONS = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName'},
        OPTIONS => {:type => ::Thrift::Types::STRUCT, :name => 'options', :class => ::Accumulo::ConditionalWriterOptions}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateConditionalWriter_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::TableNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class UpdateRowsConditionally_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      CONDITIONALWRITER = 1
      UPDATES = 2

      FIELDS = {
        CONDITIONALWRITER => {:type => ::Thrift::Types::STRING, :name => 'conditionalWriter'},
        UPDATES => {:type => ::Thrift::Types::MAP, :name => 'updates', :key => {:type => ::Thrift::Types::STRING, :binary => true}, :value => {:type => ::Thrift::Types::STRUCT, :class => ::Accumulo::ConditionalUpdates}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class UpdateRowsConditionally_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING, :binary => true}, :value => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::ConditionalStatus}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::UnknownWriter},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloseConditionalWriter_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      CONDITIONALWRITER = 1

      FIELDS = {
        CONDITIONALWRITER => {:type => ::Thrift::Types::STRING, :name => 'conditionalWriter'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CloseConditionalWriter_result
      include ::Thrift::Struct, ::Thrift::Struct_Union

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetRowRange_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      ROW = 1

      FIELDS = {
        ROW => {:type => ::Thrift::Types::STRING, :name => 'row', :binary => true}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetRowRange_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::Accumulo::Range}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetFollowing_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      KEY = 1
      PART = 2

      FIELDS = {
        KEY => {:type => ::Thrift::Types::STRUCT, :name => 'key', :class => ::Accumulo::Key},
        PART => {:type => ::Thrift::Types::I32, :name => 'part', :enum_class => ::Accumulo::PartialKey}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @part.nil? || ::Accumulo::PartialKey::VALID_VALUES.include?(@part)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field part!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetFollowing_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::Accumulo::Key}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SystemNamespace_args
      include ::Thrift::Struct, ::Thrift::Struct_Union

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SystemNamespace_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DefaultNamespace_args
      include ::Thrift::Struct, ::Thrift::Struct_Union

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DefaultNamespace_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListNamespaces_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListNamespaces_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NamespaceExists_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NamespaceExists_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateNamespace_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CreateNamespace_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceExistsException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DeleteNamespace_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class DeleteNamespace_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3
      OUCH4 = 4

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException},
        OUCH4 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch4', :class => ::Accumulo::NamespaceNotEmptyException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RenameNamespace_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      OLDNAMESPACENAME = 2
      NEWNAMESPACENAME = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        OLDNAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'oldNamespaceName'},
        NEWNAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'newNamespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RenameNamespace_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3
      OUCH4 = 4

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException},
        OUCH4 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch4', :class => ::Accumulo::NamespaceExistsException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetNamespaceProperty_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      PROPERTY = 3
      VALUE = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        PROPERTY => {:type => ::Thrift::Types::STRING, :name => 'property'},
        VALUE => {:type => ::Thrift::Types::STRING, :name => 'value'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class SetNamespaceProperty_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveNamespaceProperty_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      PROPERTY = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        PROPERTY => {:type => ::Thrift::Types::STRING, :name => 'property'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveNamespaceProperty_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetNamespaceProperties_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetNamespaceProperties_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NamespaceIdMap_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class NamespaceIdMap_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AttachNamespaceIterator_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      SETTING = 3
      SCOPES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        SETTING => {:type => ::Thrift::Types::STRUCT, :name => 'setting', :class => ::Accumulo::IteratorSetting},
        SCOPES => {:type => ::Thrift::Types::SET, :name => 'scopes', :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AttachNamespaceIterator_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveNamespaceIterator_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      NAME = 3
      SCOPES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
        SCOPES => {:type => ::Thrift::Types::SET, :name => 'scopes', :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveNamespaceIterator_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetNamespaceIteratorSetting_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      NAME = 3
      SCOPE = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
        SCOPE => {:type => ::Thrift::Types::I32, :name => 'scope', :enum_class => ::Accumulo::IteratorScope}
      }

      def struct_fields; FIELDS; end

      def validate
        unless @scope.nil? || ::Accumulo::IteratorScope::VALID_VALUES.include?(@scope)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field scope!')
        end
      end

      ::Thrift::Struct.generate_accessors self
    end

    class GetNamespaceIteratorSetting_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ::Accumulo::IteratorSetting},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListNamespaceIterators_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListNamespaceIterators_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::SET, :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CheckNamespaceIteratorConflicts_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      SETTING = 3
      SCOPES = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        SETTING => {:type => ::Thrift::Types::STRUCT, :name => 'setting', :class => ::Accumulo::IteratorSetting},
        SCOPES => {:type => ::Thrift::Types::SET, :name => 'scopes', :element => {:type => ::Thrift::Types::I32, :enum_class => ::Accumulo::IteratorScope}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class CheckNamespaceIteratorConflicts_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AddNamespaceConstraint_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      CONSTRAINTCLASSNAME = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        CONSTRAINTCLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'constraintClassName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class AddNamespaceConstraint_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::I32, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveNamespaceConstraint_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      ID = 3

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        ID => {:type => ::Thrift::Types::I32, :name => 'id'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class RemoveNamespaceConstraint_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListNamespaceConstraints_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class ListNamespaceConstraints_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::I32}},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TestNamespaceClassLoad_args
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SHAREDSECRET = 1
      NAMESPACENAME = 2
      CLASSNAME = 3
      ASTYPENAME = 4

      FIELDS = {
        SHAREDSECRET => {:type => ::Thrift::Types::STRING, :name => 'sharedSecret'},
        NAMESPACENAME => {:type => ::Thrift::Types::STRING, :name => 'namespaceName'},
        CLASSNAME => {:type => ::Thrift::Types::STRING, :name => 'className'},
        ASTYPENAME => {:type => ::Thrift::Types::STRING, :name => 'asTypeName'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

    class TestNamespaceClassLoad_result
      include ::Thrift::Struct, ::Thrift::Struct_Union
      SUCCESS = 0
      OUCH1 = 1
      OUCH2 = 2
      OUCH3 = 3

      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::BOOL, :name => 'success'},
        OUCH1 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch1', :class => ::Accumulo::AccumuloException},
        OUCH2 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch2', :class => ::Accumulo::AccumuloSecurityException},
        OUCH3 => {:type => ::Thrift::Types::STRUCT, :name => 'ouch3', :class => ::Accumulo::NamespaceNotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

      ::Thrift::Struct.generate_accessors self
    end

  end

end
