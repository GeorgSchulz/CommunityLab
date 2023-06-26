# Create VMs in Hetzner Cloud

resource "hcloud_server" "hub1" {
  name        = "hub1"
  image       = "${var.os_type}"
  server_type = "${var.server_type_hub}"
  location    = "${var.location}"
  ssh_keys    = [hcloud_ssh_key.communitylab_ssh_key.id]
  user_data   = "${file("user_data.yml")}"
}

resource "hcloud_server" "master1" {
  name        = "master1"
  image       = "${var.os_type}"
  server_type = "${var.server_type_master}"
  location    = "${var.location}"
  ssh_keys    = [hcloud_ssh_key.communitylab_ssh_key.id]
  user_data   = "${file("user_data.yml")}"
}

resource "hcloud_server" "worker1" {
  name        = "worker1"
  image       = "${var.os_type}"
  server_type = "${var.server_type_worker}"
  location    = "${var.location}"
  ssh_keys    = [hcloud_ssh_key.communitylab_ssh_key.id]
  user_data   = "${file("user_data.yml")}"
}

resource "hcloud_server" "worker2" {
  name        = "worker2"
  image       = "${var.os_type}"
  server_type = "${var.server_type_worker}"
  location    = "${var.location}"
  ssh_keys    = [hcloud_ssh_key.communitylab_ssh_key.id]
  user_data   = "${file("user_data.yml")}"
}

resource "hcloud_server" "worker3" {
  name        = "worker3"
  image       = "${var.os_type}"
  server_type = "${var.server_type_worker}"
  location    = "${var.location}"
  ssh_keys    = [hcloud_ssh_key.communitylab_ssh_key.id]
  user_data   = "${file("user_data.yml")}"
}

resource "hcloud_server" "security1" {
  name        = "security1"
  image       = "${var.os_type}"
  server_type = "${var.server_type_security}"
  location    = "${var.location}"
  ssh_keys    = [hcloud_ssh_key.communitylab_ssh_key.id]
  user_data   = "${file("user_data.yml")}"
}

# Create A-Records in Hetzner Cloud

resource "hetznerdns_record" "hub1_record" {
  zone_id = data.hetznerdns_zone.communitylab_zone.id
  name    = "hub1"
  value   = hcloud_server.hub1.ipv4_address
  type    = "A"
  ttl     = "${var.a_record_ttl}"
}

resource "hetznerdns_record" "master1_record" {
  zone_id = data.hetznerdns_zone.communitylab_zone.id
  name    = "master1"
  value   = hcloud_server.master1.ipv4_address
  type    = "A"
  ttl     = "${var.a_record_ttl}"
}

resource "hetznerdns_record" "worker1_record" {
  zone_id = data.hetznerdns_zone.communitylab_zone.id
  name    = "worker1"
  value   = hcloud_server.worker1.ipv4_address
  type    = "A"
  ttl     = "${var.a_record_ttl}"
}

resource "hetznerdns_record" "worker2_record" {
  zone_id = data.hetznerdns_zone.communitylab_zone.id
  name    = "worker2"
  value   = hcloud_server.worker2.ipv4_address
  type    = "A"
  ttl     = "${var.a_record_ttl}"
}

resource "hetznerdns_record" "worker3_record" {
  zone_id = data.hetznerdns_zone.communitylab_zone.id
  name    = "worker3"
  value   = hcloud_server.worker3.ipv4_address
  type    = "A"
  ttl     = "${var.a_record_ttl}"
}

resource "hetznerdns_record" "security1_record" {
  zone_id = data.hetznerdns_zone.communitylab_zone.id
  name    = "security1"
  value   = hcloud_server.security1.ipv4_address
  type    = "A"
  ttl     = "${var.a_record_ttl}"
}

# Configure reverse DNS for created VMs in Hetzner Cloud

resource "hcloud_rdns" "hub1" {
  server_id  = hcloud_server.hub1.id
  ip_address = hcloud_server.hub1.ipv4_address
  dns_ptr    = "hub1.${var.domain}"
}

resource "hcloud_rdns" "master1" {
  server_id  = hcloud_server.master1.id
  ip_address = hcloud_server.master1.ipv4_address
  dns_ptr    = "master1.${var.domain}"
}

resource "hcloud_rdns" "worker1" {
  server_id  = hcloud_server.worker1.id
  ip_address = hcloud_server.worker1.ipv4_address
  dns_ptr    = "worker1.${var.domain}"
}

resource "hcloud_rdns" "worker2" {
  server_id  = hcloud_server.worker2.id
  ip_address = hcloud_server.worker2.ipv4_address
  dns_ptr    = "worker2.${var.domain}"
}

resource "hcloud_rdns" "worker3" {
  server_id  = hcloud_server.worker3.id
  ip_address = hcloud_server.worker3.ipv4_address
  dns_ptr    = "worker3.${var.domain}"
}

resource "hcloud_rdns" "security1" {
  server_id  = hcloud_server.security1.id
  ip_address = hcloud_server.security1.ipv4_address
  dns_ptr    = "security1.${var.domain}"
}
