output "iam_access_key" {
  value = aws_iam_access_key.bootstrap[*].id
}

output "encrypted_iam_access_secret" {
  value = aws_iam_access_key.bootstrap[*].encrypted_secret
}

output "tf_state_bucket" {
  value = aws_s3_bucket.terraform_state_bucket
}

output "tf_state_lock" {
  value = aws_dynamodb_table.terraform_state_lock
}
