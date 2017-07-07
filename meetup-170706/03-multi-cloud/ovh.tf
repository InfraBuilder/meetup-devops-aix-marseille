# Create a web server
resource "openstack_compute_instance_v2" "meetup-ovh" {
  name            = "meetup-ovh"
  image_id        = "959f78b0-0254-416d-8abc-1b0f691d1be4"
  flavor_name       = "s1-2"
  key_pair        = "aducastel"
  security_groups = ["default"]
  region      = "GRA3"

  network {
    name = "Ext-Net"
  }
}
