resource "aws_instance" "meetup-aws-simple" {
  ami           = "${var.ami-ubuntu-1604}"
  instance_type = "t2.micro"
  tags          = { Name="meetup" }
  key_name	= "aducastel"
}

