# Create a web server
resource "digitalocean_droplet" "meetup-do" {
  image  = "ubuntu-16-04-x64"
  name   = "web-1"
  region = "lon1"
  size   = "512mb"
  ssh_keys = ["XXX-YOUR-SSH-FINGERPRINT-FORMATTED-LIKE-xx:xx:xx:xx:...:xx:xx-XXX"]
}
