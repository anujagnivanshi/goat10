resource "aws_instance" "web-server" {
  ami = "${var.image_id}"
  iam_instance_profile = "${var.iam_role}"
  subnet_id = "${var.subnet}"
  key_name = "${var.keypair_name}"
  instance_initiated_shutdown_behavior = "stop"
  vpc_security_group_ids = ["${var.sec_group}"]

  tags = {
      Name = "web-instance"
  }

  root_block_device {
      volume_size = "${var.ebs_size}"
      volume_type = "${var.ebs_type}"
  }
  instance_type = "${var.machine_type}"
  


}
