resource "aws_db_subnet_group" "this" {
  name       = "node-app-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "node-app-subnet-group"
  }
}
resource "aws_db_instance" "this" {
  allocated_storage       = var.allocated_storage
  engine                  = "postgres"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  name                    = var.db_name
  username                = var.username
  password                = var.password
  parameter_group_name    = var.parameter_group_name
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.this.name
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = var.tags
}

