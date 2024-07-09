variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "node-app"
}

variable "username" {
  description = "The master username for the database"
  type        = string
}

variable "password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate"
  type        = string
  default     = "default.postgres12"
}

variable "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to be used by the DB subnet group"
  type        = list(string)
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "The identifier for the final snapshot"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
