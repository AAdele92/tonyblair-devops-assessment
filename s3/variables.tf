variable "bucket_name" {
  type        = string
  description = "s3 bucket"
  default     = "tonyblair-bucket"
}

variable "block_public_acls" {
  type        = bool
  description = "access control list to block public"
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "this is policy to block public access"
  default     = true
}

variable "region" {
  type        = string
  description = "region to deploy"
  default     = "eu-west-2"
}