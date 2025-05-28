variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "eu-west-2"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "tonyblair-cluster"
  
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
  default     = "tonyblair-bucket"
}

variable "ecr_repository_name" {
  type        = string
  description = "ECR repository name"
  default     = "tonyblair-repository"
  
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}