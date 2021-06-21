
############
# S3 Bucket
############
module "s3" {
  source  = "app.terraform.io/MEGAZONE-prod/s3/aws"
  version = "1.0.0"

  bucket        = var.bucket
  acl           = "private"
  force_destroy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = var.tags
}