resource "aws_s3_bucket" "artifacts_bucket" {
  count = var.bucket_id == "" ? 1 : 0
  bucket = var.bucket 
  tags = {
    Project = "vprofile"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  count = var.bucket_id == "" ? 0 : 1
  bucket = aws_s3_bucket.artifacts_bucket[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  count = var.bucket_id == "" ? 0 : 1
  depends_on = [aws_s3_bucket_ownership_controls.s3_ownership]

  bucket = aws_s3_bucket.artifacts_bucket[0].id
  acl    = "private"
}

resource "aws_s3_object" "object" {
  bucket = var.bucket_id == "" ? aws_s3_bucket.artifacts_bucket[0].id : var.bucket_id
  key    = var.artifact_key
  acl    = "private"
  source = var.artifact_source

  etag = filemd5("${var.artifact_source}")

}