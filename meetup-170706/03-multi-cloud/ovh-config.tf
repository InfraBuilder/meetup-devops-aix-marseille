provider "openstack" {
  user_name   = "XXX-OVH-PUBLIC-CLOUD-USER-XXX"
  tenant_name = "XXX-OVH-PUBLIC-CLOUD-TENANT-NAME-XXX"
  password    = "${var.ovh-secret-key}"
  auth_url    = "https://auth.cloud.ovh.net/v2.0"
  tenant_id   = "XXX-OVH-PUBLIC-CLOUD-TENANT-ID-XXX"
}

