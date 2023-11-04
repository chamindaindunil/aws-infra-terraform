output "s3_bucket_name" {
  value = [aws_s3_bucket.main.bucket_domain_name, aws_s3_bucket.main.id]
}