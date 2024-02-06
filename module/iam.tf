resource "aws_iam_role" "sunkenland" {
  name = "${local.name}-server"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_instance_profile" "sunkenland" {
  role = aws_iam_role.sunkenland.name
}

resource "aws_iam_policy" "sunkenland" {
  name        = "${local.name}-server"
  description = "Allows the Sunkenland server to interact with various AWS services"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:Put*",
          "s3:Get*",
          "s3:List*"
        ],
        Resource : [
          "arn:aws:s3:::${aws_s3_bucket.sunkenland.id}",
          "arn:aws:s3:::${aws_s3_bucket.sunkenland.id}/"
        ]
      },
      {
        Effect : "Allow",
        Action : ["ec2:DescribeInstances"],
        Resource : ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sunkenland" {
  role       = aws_iam_role.sunkenland.name
  policy_arn = aws_iam_policy.sunkenland.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.sunkenland.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#tfsec:ignore:aws-iam-enforce-mfa
resource "aws_iam_group" "sunkenland_users" {
  name = "${local.name}-users"
  path = "/users/"
}

resource "aws_iam_policy" "sunkenland_users" {
  #checkov:skip=CKV_AWS_289:sunkenland EC2 instances are dynamic so we cannot avoid a wildcard
  #checkov:skip=CKV_AWS_355:sunkenland EC2 instances are dynamic so we cannot avoid a wildcard
  name        = "${local.name}-user"
  description = "Allows Sunkenland users to start the server"
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        Effect : "Allow",
        Action : ["ec2:StartInstances"],
        Resource : "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:instance/${aws_spot_instance_request.sunkenland.spot_instance_id}",
      },
      {
        Effect : "Allow",
        Action : [
          "cloudwatch:DescribeAlarms",
          "ec2:DescribeAddresses",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstances",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeNetworkInterfaces",
          "iam:ChangePassword"
        ]
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "sunkenland_users" {
  group      = aws_iam_group.sunkenland_users.name
  policy_arn = aws_iam_policy.sunkenland_users.arn
}
