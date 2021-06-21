data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
    ]
  }
}

############
# S3 Bucket
############
module "s3" {
  source  = "app.terraform.io/MEGAZONE-prod/s3/aws"
  version = "1.0.4"

  bucket        = var.bucket
  acl           = "private"
  force_destroy = true

  versioning = var.versioning

  attach_policy = var.attach_policy
  policy        = data.aws_iam_policy_document.bucket_policy.json
  
  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = var.tags
}

