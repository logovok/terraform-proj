data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role" "ec2_s3_readonly_role" {
  name = "ec2_s3_readonly_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "s3_readonly_access" {
  name       = "s3_readonly_access"
  roles      = [aws_iam_role.ec2_s3_readonly_role.name]
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}

resource "aws_iam_instance_profile" "iam-profile" {
  name = "demo_profile"
  role = aws_iam_role.ec2_s3_readonly_role.name
}

output "iam-profile_name" {
  value = aws_iam_instance_profile.iam-profile.name
}