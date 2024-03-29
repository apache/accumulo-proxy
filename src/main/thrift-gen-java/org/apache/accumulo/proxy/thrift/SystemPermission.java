/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
/**
 * Autogenerated by Thrift Compiler (0.17.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
package org.apache.accumulo.proxy.thrift;


public enum SystemPermission implements org.apache.thrift.TEnum {
  GRANT(0),
  CREATE_TABLE(1),
  DROP_TABLE(2),
  ALTER_TABLE(3),
  CREATE_USER(4),
  DROP_USER(5),
  ALTER_USER(6),
  SYSTEM(7),
  CREATE_NAMESPACE(8),
  DROP_NAMESPACE(9),
  ALTER_NAMESPACE(10),
  OBTAIN_DELEGATION_TOKEN(11);

  private final int value;

  private SystemPermission(int value) {
    this.value = value;
  }

  /**
   * Get the integer value of this enum value, as defined in the Thrift IDL.
   */
  @Override
  public int getValue() {
    return value;
  }

  /**
   * Find a the enum type by its integer value, as defined in the Thrift IDL.
   * @return null if the value is not found.
   */
  @org.apache.thrift.annotation.Nullable
  public static SystemPermission findByValue(int value) { 
    switch (value) {
      case 0:
        return GRANT;
      case 1:
        return CREATE_TABLE;
      case 2:
        return DROP_TABLE;
      case 3:
        return ALTER_TABLE;
      case 4:
        return CREATE_USER;
      case 5:
        return DROP_USER;
      case 6:
        return ALTER_USER;
      case 7:
        return SYSTEM;
      case 8:
        return CREATE_NAMESPACE;
      case 9:
        return DROP_NAMESPACE;
      case 10:
        return ALTER_NAMESPACE;
      case 11:
        return OBTAIN_DELEGATION_TOKEN;
      default:
        return null;
    }
  }
}
