#tfsec:ignore:AWS018
resource "aws_security_group" "ingress" {
  #checkov:skip=CKV2_AWS_5:Broken - https://github.com/bridgecrewio/checkov/issues/1203
  name        = "${local.name}-ingress"
  description = "Security group allowing inbound traffic to the Sunkenland server"
}

resource "aws_security_group_rule" "sunkenland_ingress" {
  type              = "ingress"
  from_port         = 2456
  to_port           = 2458
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  security_group_id = aws_security_group.ingress.id
  description       = "Allows traffic to the Sunkenland server"
}

resource "aws_security_group_rule" "netdata" {
  type              = "ingress"
  from_port         = 19999
  to_port           = 19999
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  security_group_id = aws_security_group.ingress.id
  description       = "Allows traffic to the Netdata dashboard"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  security_group_id = aws_security_group.ingress.id
  description       = "Allow all egress rule for the Sunkenland server"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.*-amd64-server-*"]
  }
}

resource "aws_spot_instance_request" "sunkenland" {
  #checkov:skip=CKV_AWS_126:Detailed monitoring is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_8:This is not a launch configuration
  #checkov:skip=CKV2_AWS_17:This instance will be placed in the default VPC deliberately
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  ebs_optimized = true
  user_data = templatefile("${path.module}/local/userdata.sh", {
    host_username = local.host_username
    bucket        = aws_s3_bucket.sunkenland.id
  })
  iam_instance_profile           = aws_iam_instance_profile.sunkenland.name
  vpc_security_group_ids         = [aws_security_group.ingress.id]
  wait_for_fulfillment           = true
  instance_interruption_behavior = "stop"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = local.ec2_tags

  depends_on = [
    aws_s3_object.install_sunkenland,
    aws_s3_object.start_sunkenland,
    aws_s3_object.backup_sunkenland,
    aws_s3_object.crontab,
    aws_s3_object.sunkenland_service
  ]
}

resource "aws_ec2_tag" "sunkenland" {
  for_each = local.ec2_tags

  resource_id = aws_spot_instance_request.sunkenland.spot_instance_id
  key         = each.key
  value       = each.value
}
