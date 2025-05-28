#########################################################
# IAM Policy for Terraform backend to tony blair user  #
#########################################################

resource "aws_iam_user" "cd" {
  name = "tonyblair-cd"
}

resource "aws_iam_access_key" "cd" {
  user = aws_iam_user.cd.name
}

data "aws_iam_policy_document" "cd" {

  statement {
    effect = "Allow"
    actions = [
      "iam:ListInstanceProfilesForRole",
      "iam:ListAttachedRolePolicies",
      "iam:DeleteRole",
      "iam:ListPolicyVersions",
      "iam:DeletePolicy",
      "iam:DetachRolePolicy",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:GetPolicyVersion",
      "iam:GetPolicy",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:AttachRolePolicy",
      "iam:TagRole",
      "iam:TagPolicy",
      "iam:PassRole",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:AttachRolePolicy",
      "logs:CreateLogGroup",
      "logs:ListTagsForResource",
      "ecs:CreateCluster",
      "rds:CreateDBSubnetGroup"
    ]
    resources = ["*"]
  }
  
}


resource "aws_iam_user_policy_attachment" "iam" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.cd.arn
}


resource "aws_iam_policy" "cd" {
  name        = "${aws_iam_user.cd.name}-iam"
  description = "Allow user to manage IAM resources"
  policy      = data.aws_iam_policy_document.cd.json
}
resource "aws_iam_user_policy_attachment" "cd" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.cd.arn
}

resource "aws_iam_role" "tonyblair_node_group" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "tonyblair_node_group" {
  role       = aws_iam_role.tonyblair_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

