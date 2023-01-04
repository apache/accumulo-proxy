/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.accumulo.proxy;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.accumulo.core.client.admin.compaction.CompactableFile;
import org.apache.accumulo.core.client.admin.compaction.CompactionSelector;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Select half of the files to compact
 */
public class SelectHalfSelector implements CompactionSelector {
  public final Logger log = LoggerFactory.getLogger(SelectHalfSelector.class);

  @Override
  public void init(InitParameters iparams) {}

  @Override
  public Selection select(SelectionParameters sparams) {
    log.info(sparams.getAvailableFiles().toString());
    Collection<CompactableFile> totalFiles = sparams.getAvailableFiles();
    final int fileCount = totalFiles.size();

    if (fileCount < 1) {
      return new Selection(List.of());
    }

    final int numToCompact = fileCount / 2;

    List<CompactableFile> toCompact = totalFiles.stream().limit(numToCompact)
        .collect(Collectors.toList());

    log.info("files to select: {}", toCompact);
    return new Selection(toCompact);
  }

}
