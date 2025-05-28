# ##############################################
# # Security group for EKS cluster #
# ##############################################

resource "aws_security_group" "eks_cluster" {
  name        = "eks_cluster_sg"
  description = "EKS cluster security group"
  vpc_id      = aws_vpc.main.id

  // Example: allow all traffic within the security group
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tonyblair_sg"
  }
}