variable "aws_access_key_id" {
  type        = string
  description = "AWS access key used to create infrastructure"
}
variable "aws_secret_access_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}
variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}
variable "ssh_key_file_name" {
  type        = string
  description = "File path and name of SSH private key used for infrastructure and RKE"
  default     = "~/.ssh/id_rsa"
}
variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "mak3r"
}

variable "instance_type" {
  type = string
  description = "The aws model name for the k3s host instances"
  default = "db.t2.micro"
}

variable "rancher_subdomain" {
	type = string
	description = "The subdomain for this rancher installation"
	default = "demo"
}

variable "domain" {
	type = string
	description = "The domain to attach this rancher url onto"
	default = "mak3r.design."
}

variable "downstream_count" {
	type = number
	description = "The number of downstream instances to create"
	default = 0
}

variable "rancher_node_count" {
	type = number
	description = "The number of nodes to use for the rancher cluster"
	default = 1
}

variable "make_rds" {
	type = bool
	description = "if true, make the rds database"
	default = false
}

variable "rancher_access_token" {
	type = string
	description = "The Rancher API access token"
	default = ""
}