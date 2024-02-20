variable "cluster_name" {
  type = string
  default = "learning-cluster"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(any)
}
variable "self_managed_node_groups_name"{
  type = string
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
  self_managed_node_groups_instance_type = "t3.medium"

  env_tags = merge(var.default_tags, tomap({
    "Environment" = local.environment,
    "Name"        = local.stack_name
  }))
}
