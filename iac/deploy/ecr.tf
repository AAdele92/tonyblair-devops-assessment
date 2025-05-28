##############################################
# Create ECR repos for storing Docker images #
##############################################

resource "aws_ecr_repository" "tonyblair_repository" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

