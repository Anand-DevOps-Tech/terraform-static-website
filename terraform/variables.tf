variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "app_name" {
  description = "Application name tag"
  type        = string
  default     = "oxer-web-host"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
  default     = "project"
}

variable "git_repo_url" {
  description = "Git repository URL containing static website files (HTML, CSS, JS, Images)"
  type        = string
  default     = "https://github.com/Anand-DevOps-Tech/terraform-static-website.git"
}

