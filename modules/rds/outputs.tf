output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_port" {
  value = aws_db_instance.this.port
}

output "rds_instance_id" {
  value = aws_db_instance.this.id
}
