data "aws_route53_zone" "ibdnet" {
  name = "infrabuilder.net"
}

resource "aws_security_group" "ssh_wan" {
  name        = "terra_ssh_wan"
  description = "Used in the terraform"

  # SSH access from anywhere
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

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "meetup-aws" {
  ami           = "${var.ami-ubuntu-1604}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.ssh_wan.name}"]  
  tags          = { Name="meetup-aws" }
  key_name	= "aducastel"
  user_data     = "${file("userdata.sh")}"
  count         = "1"
}

resource "aws_eip" "meetup-eip" {
  instance = "${aws_instance.meetup-aws.0.id}"
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.ibdnet.zone_id}"
  name    = "terra.infrabuilder.net"
  type    = "A"
  ttl     = "60"
  records = ["${aws_eip.meetup-eip.public_ip}"]
}

output "ip" {
  value = "${aws_eip.meetup-eip.public_ip}"
}

