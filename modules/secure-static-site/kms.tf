resource "aws_kms_key" "default_s3" {
  description             = "Bucket encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}