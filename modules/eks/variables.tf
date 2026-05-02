variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "cluster_security_group_id" {
  type = string
}

variable "node_security_group_id" {
  type = string
}

variable "node_group_desired_size" {
  type = number
}

variable "node_group_min_size" {
  type = number
}

variable "node_group_max_size" {
  type = number
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_disk_size" {
  type = number
}

variable "enable_cluster_encryption" {
  type    = bool
  default = true
}

variable "cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
