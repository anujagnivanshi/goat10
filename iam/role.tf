resource "aws_iam_instance_profile" "s3_access" {
  name = "${format("%s","${var.env}-${var.service}-access-profile")}"
  role = "${aws_iam_role.s3_role.name}"
}
resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_role.name}"

  policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "s3:*",
              "Resource": "*"
          }
      ]
  }
  EOF

}
resource "aws_iam_role" "s3_role" {
  name = "s3_role"
  
  assume_role_policy = <<-EOF
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
}

output "profile_iam" {
  value = "${aws_iam_instance_profile.s3_access.id}"
}



