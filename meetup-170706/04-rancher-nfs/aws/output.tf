output "ip_rancher_master" {
  value = "${join(",", aws_instance.rancher_server.*.public_ip)}"
}

output "ip_rancher_node" {
  value = "${join(",", aws_instance.rancher_node.*.public_ip)}"
}

output "efs_dns_name" {
  value = "${aws_efs_mount_target.mount_b.dns_name}"
}
