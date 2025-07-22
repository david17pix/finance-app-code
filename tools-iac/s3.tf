resource "aws_s3_bucket" "data" {
  # bucket is public
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-data"
  force_destroy = true

  tags = {
    yor_trace            = "2b6f6f17-4b98-4749-9cc4-ca3728ce4ffd"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/s3.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_s3_bucket_object" "data_object" {
  bucket = aws_s3_bucket.data.id
  key    = "customer-master.xlsx"
  source = "resources/customer-master.xlsx"

  tags = {
    yor_trace            = "fb8ef786-468f-4348-af5d-94168858ac3b"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/s3.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_s3_bucket" "financials" {
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-financials"
  acl           = "private"
  force_destroy = true


  tags = {
    yor_trace            = "2884646f-9ca5-4fd1-9917-8dcb99b8173c"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/s3.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_s3_bucket" "operations" {
  # bucket is not encrypted
  # bucket does not have access logs
  bucket = "${local.resource_prefix.value}-operations"
  acl    = "private"
  versioning {
    enabled = true
  }
  force_destroy = true

  tags = {
    yor_trace            = "4968a964-2c99-465a-aa96-451bc4fc4227"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/s3.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_s3_bucket" "data_science" {
  # bucket is not encrypted
  bucket = "${local.resource_prefix.value}-data-science"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "log/"
  }
  force_destroy = true

  tags = {
    yor_trace            = "9a0c2cb0-7ce7-4c8c-b81b-c9f3de8c5485"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/s3.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "${local.resource_prefix.value}-logs"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${aws_kms_key.logs_key.arn}"
      }
    }
  }
  force_destroy = true

  tags = {
    yor_trace            = "77d1071e-ea20-4f7c-b92a-e9956477b024"
    git_commit           = "dfe8ef7ec68b78d635210337672664207d6db71b"
    git_file             = "tools-iac/s3.tf"
    git_last_modified_at = "2023-05-15 17:49:51"
    git_last_modified_by = "ricardo@lab.com"
    git_modifiers        = "v"
    git_org              = "ricardo7364"
    git_repo             = "database-app"
  }
}

