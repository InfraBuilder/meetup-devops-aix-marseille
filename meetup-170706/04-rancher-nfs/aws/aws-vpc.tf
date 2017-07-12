# Create a VPC
resource "aws_vpc" "vpc_meetup" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags {
    Name = "vpc_meetup"
  }
}

resource "aws_internet_gateway" "meetup-gw" {
  vpc_id = "${aws_vpc.vpc_meetup.id}"

  tags {
    Name = "meetup-gw"
  }
}

# Create a subnet
resource "aws_subnet" "meetup_1a" {
  vpc_id            = "${aws_vpc.vpc_meetup.id}"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.0.1.0/24"
  tags {
    Name = "meetup_1a"
  }
}
resource "aws_subnet" "meetup_1b" {
  vpc_id            = "${aws_vpc.vpc_meetup.id}"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = "true"
  cidr_block        = "10.0.2.0/24"
  tags {
    Name = "meetup_1b"
  }
}

resource "aws_route" "route" {
  route_table_id            = "${aws_vpc.vpc_meetup.default_route_table_id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.meetup-gw.id}"
}

resource "aws_security_group" "rancher_server" {
  name        = "rancher_server"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.vpc_meetup.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rancher_node" {
  name        = "rancher_node"
  description = "Allow nfs inbound from "
  vpc_id      = "${aws_vpc.vpc_meetup.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["${aws_vpc.vpc_meetup.cidr_block}"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["${aws_vpc.vpc_meetup.cidr_block}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a rancher server
resource "aws_instance" "rancher_server" {
  ami                    = "${var.ami-ubuntu-1604}"
  instance_type          = "t2.small"
  tags                   = { Name="rancher_server" }
  key_name	             = "ibeaute"
  user_data              = "${file("install-rancher_server.sh")}"
  vpc_security_group_ids = ["${aws_security_group.rancher_server.id}"]
  subnet_id              = "${aws_subnet.meetup_1a.id}"
  count                  = "1"
}

# Create a rancher node
resource "aws_instance" "rancher_node" {
  ami                    = "${var.ami-ubuntu-1604}"
  instance_type          = "t2.micro"
  tags                   = { Name="rancher_node" }
  key_name	             = "ibeaute"
  user_data              = "${file("install-docker.sh")}"
  vpc_security_group_ids = ["${aws_security_group.rancher_node.id}"]
  subnet_id              = "${element(list("${aws_subnet.meetup_1a.id}", "${aws_subnet.meetup_1b.id}"), count.index)}"
  count                  = "2"
}
