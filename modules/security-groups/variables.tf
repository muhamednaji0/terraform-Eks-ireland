variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "allowed_ssh_ips" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
