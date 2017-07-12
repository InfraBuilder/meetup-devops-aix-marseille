output "ip_rancher_master_public" {
  value = "${aws_instance.rancher_server.*.public_ip}"
}

output "ip_rancher_master_private" {
  value = "${aws_instance.rancher_server.private_ip}"
}

output "ip_rancher_node" {
  value = "${join(",", aws_instance.rancher_node.*.public_ip)}"
}

output "efs_dns" {
  value = "${aws_efs_mount_target.mount_a.dns_name}"
}
