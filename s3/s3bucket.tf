resource "aws_s3_bucket" "tonyblair-bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_block_access" {
  bucket              = aws_s3_bucket.tonyblair-bucket.id
  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
}