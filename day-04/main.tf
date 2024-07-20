# Main Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.aws_s3_bucket_name

  tags = {
    Name = var.aws_s3_bucket_name
  }
}

resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership_controls" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_ownership_controls.my_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.my_bucket_public_access_block
  ]
}

resource "aws_s3_object" "s3_object" {
  for_each = {
    "index.html"       = { key = "index.html", source = "web/home/index.html", content_type = "text/html" }
    "styles_home.css"  = { key = "styles_home.css", source = "web/home/styles.css", content_type = "text/css" }
    "error.html"       = { key = "error.html", source = "web/error/error.html", content_type = "text/html" }
    "styles_error.css" = { key = "styles_error.css", source = "web/error/styles.css", content_type = "text/css" }
  }

  bucket       = aws_s3_bucket.my_bucket.id
  key          = each.value.key
  source       = "${path.module}/${each.value.source}"
  acl          = "public-read"
  content_type = each.value.content_type
}

resource "aws_s3_bucket_website_configuration" "my_bucket_website_configuration" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.my_bucket_acl]
}


# Log Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.aws_s3_bucket_name}-logs"
}

resource "aws_s3_bucket_ownership_controls" "log_bucket_ownership_controls" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"

  depends_on = [
    aws_s3_bucket_ownership_controls.log_bucket_ownership_controls
  ]
}

resource "aws_s3_bucket_logging" "log_bucket_logging" {
  bucket = aws_s3_bucket.my_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}



