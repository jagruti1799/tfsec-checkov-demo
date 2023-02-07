resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "demobucket" {
  bucket = "tfsec-checkov-demo"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# resource "aws_s3_bucket_public_access_block" "block_access" {
#    bucket                  = aws_s3_bucket.demobucket.id
#    restrict_public_buckets = true
#    block_public_policy     = true
#    ignore_public_acls      = true
#    block_public_acls       = true
#  }

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.demobucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.demobucket.id

  target_bucket = aws_s3_bucket.demobucket.id
  target_prefix = "log/"
}

