# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
resource "aws_kms_key" "aft" {
  description         = "AFT KMS key"
  enable_key_rotation = "true"
}
resource "aws_kms_alias" "aft" {
  name          = "alias/aft"
  target_key_id = aws_kms_key.aft.key_id
}

resource "aws_kms_key" "aft_key_log" {
  description         = "KMS key for encrypt/decrypt log files"
  enable_key_rotation = "true"
  policy = templatefile("${path.module}/kms/key-policies/log-key.tpl", {
    account_id                           = data.aws_caller_identity.current.account_id
    data_aws_partition_current_partition = data.aws_partition.current.partition
  })
}

resource "aws_kms_alias" "aft_key_log_alias" {
  name          = "alias/aft-log"
  target_key_id = aws_kms_key.aft_key_log.key_id
}
