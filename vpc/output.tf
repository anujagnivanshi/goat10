output "vlan-pub" {
    value = "${aws_subnet.sub-pub.id}"
}
output "vlan-pri" {
  value = "${aws_subnet.sub-pri.id}"
}
output "sg-link-pub" {
  value = "${aws_security_group.public-sg.id}"
}
output "sg-link-pri" {
  value = "${aws_security_group.private-sg.id}"
}
output "vpc-link" {
  value = "${aws_vpc.nw.id}"
}



