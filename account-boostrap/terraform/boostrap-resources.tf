data "aws_caller_identity" "current" {}

locals {
  bucket_name = "terraform-state-${data.aws_caller_identity.current.account_id}"
  table_name  = "terraform-state-lock-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    name       = local.bucket_name
    created_by = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = local.table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name       = local.table_name
    created_by = "terraform"
  }
}
