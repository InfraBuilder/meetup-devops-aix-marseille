variable "ami-ubuntu-1604" {
        default = "ami-a8d2d7ce"
}

resource "aws_security_group" "ssh_wan" {
  name        = "ssh_wan"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
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
  instance_type = "t2.nano"
  security_groups = ["${aws_security_group.ssh_wan.name}"]  
  tags          = { Name="meetup-aws" }
  key_name	= "aducastel"
  count         = "1"
}

resource "aws_eip" "meetup-aws-eip" {
  instance = "${aws_instance.meetup-aws.0.id}"
}

