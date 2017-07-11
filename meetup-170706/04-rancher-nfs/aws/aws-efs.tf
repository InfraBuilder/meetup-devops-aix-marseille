resource "aws_security_group" "nfs" {
  name        = "nfs"
  description = "Allow nfs inbound from the meetup VPC"
  vpc_id      = "${aws_vpc.vpc_meetup.id}"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.vpc_meetup.cidr_block}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create an EFS
resource "aws_efs_file_system" "efs_meetup" {
  creation_token = "meetup-devops"

  tags {
    Name = "meetup-devops"
  }
}

# Attach mount-target to the EFS
resource "aws_efs_mount_target" "mount_a" {
  file_system_id  = "${aws_efs_file_system.efs_meetup.id}"
  subnet_id       = "${aws_subnet.meetup_1a.id}"
  security_groups = ["${aws_security_group.nfs.id}"]
}
resource "aws_efs_mount_target" "mount_b" {
  file_system_id = "${aws_efs_file_system.efs_meetup.id}"
  subnet_id      = "${aws_subnet.meetup_1b.id}"
  security_groups = ["${aws_security_group.nfs.id}"]

  provisioner "local-exec" {
    command = "sed -i '/NFS_SERVER=/ c\vNFS_SERVER=${aws_efs_mount_target.mount_b.dns_name}' ../rancher/rancher-nfs.txt"
  }
}
