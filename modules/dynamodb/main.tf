resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = var.environment
  }
}
