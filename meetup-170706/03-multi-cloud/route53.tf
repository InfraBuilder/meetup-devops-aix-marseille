data "aws_route53_zone" "ibdnet" {
  name = "infrabuilder.net"
}

resource "aws_route53_record" "aws" {
  zone_id = "${data.aws_route53_zone.ibdnet.zone_id}"
  name    = "meetup-aws.infrabuilder.net"
  type    = "A"
  ttl     = "60"
  records = ["${aws_eip.meetup-aws-eip.public_ip}"]
}

resource "aws_route53_record" "ovh" {
  zone_id = "${data.aws_route53_zone.ibdnet.zone_id}"
  name    = "meetup-ovh.infrabuilder.net"
  type    = "A"
  ttl     = "60"
  records = ["${openstack_compute_instance_v2.meetup-ovh.network.0.fixed_ip_v4}"]
}

resource "aws_route53_record" "digitalocean" {
  zone_id = "${data.aws_route53_zone.ibdnet.zone_id}"
  name    = "meetup-do.infrabuilder.net"
  type    = "A"
  ttl     = "60"
  records = ["${digitalocean_droplet.meetup-do.ipv4_address}"]
}


