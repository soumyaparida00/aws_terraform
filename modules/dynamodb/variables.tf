variable "table_name" {
  description = "The name of the DynamoDB table for Terraform state lock"
}

variable "environment" {
  description = "The environment for which this DynamoDB table is created"
}
