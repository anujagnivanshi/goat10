output "IP" {
    value = "${aws_instance.web-server.public_ip}"
}

