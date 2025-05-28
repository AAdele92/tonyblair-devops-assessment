# ##############################################
# # Create EKS Cluster for app #
# ##############################################

resource "aws_eks_cluster" "tonyblair_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.tonyblair_node_group.arn

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
    security_group_ids = [aws_security_group.eks_cluster.id]
  }

  depends_on = [aws_iam_role_policy_attachment.tonyblair_node_group]
}

resource "aws_eks_node_group" "tonyblair_node_group" {
  cluster_name    = aws_eks_cluster.tonyblair_cluster.name
  node_group_name = "tonyblair_node_group"
  node_role_arn   = aws_iam_role.tonyblair_node_group.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [aws_eks_cluster.tonyblair_cluster]
}