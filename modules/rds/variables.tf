variable "rds-subnet_ids" {
  type = list(any)
}
variable "rds-vpc-security-group-ids" {
  type = list(any)
}

variable "rds-instance-class" {
  type = string
  default = "db.t3.small"
}
variable "rds-instance-name" {
  type = string
  default = "study-db"
}
variable "project" {
  type = string
  default = "learning"
}

variable "application" {
  type = string
  default = "eks"
}

variable "default_tags" {
  type = map(any)
  default = {
    Project     = "Test"
    Automate    = "terraform"
    Team        = "LightIT"
  }
}

locals {
  environment = terraform.workspace
  stack_name  = "${var.project}-${var.application}-${local.environment}"


  env_tags = merge(var.default_tags, tomap({
    "Environment" = local.environment,
    "Name"        = local.stack_name
  }))
}
