

variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}


variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "aws_key_pair_name" {
  type        = string
  description = "AWS Key Pair Name"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "database_name" {
  description = "Database Name"
}

variable "database_password" {
  description = "Database Password"
}