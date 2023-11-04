resource "aws_s3_bucket" "games" {
  bucket = "${var.project}-games"
}

resource "aws_s3_bucket_acl" "games_acl" {
  bucket = aws_s3_bucket.games.id
  acl    = "private"
}

resource "aws_s3_bucket" "site" {
  bucket = "${var.project}-site"
}

resource "aws_s3_bucket_acl" "site_acl" {
  bucket = aws_s3_bucket.site.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "site_website_config" {
  bucket = aws_s3_bucket.site.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "games_bucket" {}
resource "aws_cloudfront_origin_access_identity" "site_bucket" {}

data "aws_iam_policy_document" "games_bucket_policy" {
  statement {
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.games_bucket.iam_arn]
    }
    resources = ["${aws_s3_bucket.games.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "games_bucket_policy" {
  bucket = aws_s3_bucket.games.id
  policy = data.aws_iam_policy_document.games_bucket_policy.json
}

data "aws_iam_policy_document" "site_bucket_policy" {
  statement {
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.site_bucket.iam_arn]
    }
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.site_bucket_policy.json
}