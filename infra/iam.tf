data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::864981717146:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:dwarakabitsolutions/terraform-aws-cicd:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "GitHubActionsTerraformRole"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

resource "aws_iam_role_policy" "terraform_policy" {
  name   = "TerraformPolicy"
  role   = aws_iam_role.github_actions.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::pss-terraform-state-bucket",
          "arn:aws:s3:::pss-terraform-state-bucket/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem"
        ],
        Resource = "arn:aws:dynamodb:us-west-2:864981717146:table/terraform-locks"
      },
      {
        Effect   = "Allow",
        Action   = "s3:CreateBucket",
        Resource = "arn:aws:s3:::tf-cicd-*"
      }
    ]
  })
}