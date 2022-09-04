
resource "random_string" "random" {
  length  = 6
  special = false
  lower   = true
  upper   = false
  numeric = false
}

resource "aws_iam_role" "fortigate_role" {
  name = "fortigate_role-${var.iam_role_name}-${random_string.random.result}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "fortigate_role-${var.iam_role_name}-${random_string.random.result}"cccccbcbu
  }
}

resource "aws_iam_instance_profile" "fortigate_profile" {
  name = "fortigate_profile-${var.iam_role_name}-${random_string.random.result}"
  role = aws_iam_role.fortigate_role.name
}

resource "aws_iam_role_policy" "fortigate_policy" {
  name = "fortigate_policy-${var.iam_role_name}-${random_string.random.result}"
  role = aws_iam_role.fortigate_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "ec2:AssociateAddress",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses",
        "ec2:ReplaceRoute",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}