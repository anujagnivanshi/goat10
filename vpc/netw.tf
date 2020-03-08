#----Description
# In VPC Block we should define VPC, internetgateway, route_tables, subnets, route_association and security_groups ...
resource "aws_vpc" "nw" {
  cidr_block = "${var.vpc_range}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
      Name = "CI-VPC"
  }
}
resource "aws_internet_gateway" "ci-igw" {
  vpc_id = "${aws_vpc.nw.id}"

  tags = {
      Name = "igw-pipeline"
  }
}
resource "aws_route_table" "routes" {
  vpc_id = "${aws_vpc.nw.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.ci-igw.id}"
  }
}
resource "aws_default_route_table" "default_route" {
    default_route_table_id = "${aws_vpc.nw.default_route_table_id}"
  
}
data "aws_availability_zones" "az" {
    state = "available"
}
resource "aws_subnet" "sub-pub" {
    vpc_id = "${aws_vpc.nw.id}"
    cidr_block = "${var.pub_range}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.az.names[0]}"

    tags = {
        Name = "Public Subnet"
    }
    
}
resource "aws_route_table_association" "pub-route" {
  route_table_id ="${aws_route_table.routes.id}"
  subnet_id = "${aws_subnet.sub-pub.id}"
}
resource "aws_subnet" "sub-pri" {
    vpc_id = "${aws_vpc.nw.id}"
    cidr_block = "${var.pri_range}"
    map_public_ip_on_launch = false
    availability_zone = "${data.aws_availability_zones.az.names[1]}"

    tags = {
        Name = "Private Subnet"
    }
    
}
resource "aws_route_table_association" "pri-route" {
  subnet_id      = "${aws_subnet.sub-pri.id}"
  route_table_id = "${aws_default_route_table.default_route.id}"
}
resource "aws_security_group" "public-sg" {
    name = "public-security-group"
    vpc_id = "${aws_vpc.nw.id}"

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["${var.local_ip}"]
    }
    
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }  
}
resource "aws_security_group" "private-sg" {
    name = "private-security-group"
    vpc_id = "${aws_vpc.nw.id}"

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        security_groups = ["${aws_security_group.public-sg.id}"]
    }
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }  
  
}









