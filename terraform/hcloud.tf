# Configure the Hetzner Cloud Provider

provider "hcloud" {
  token = "${var.hetzner_token}"
}

provider "hetznerdns" {
  apitoken = "${var.hetznerdns_token}"
}

# Create SSH Key in Hetzner Cloud using local public SSH key

resource "hcloud_ssh_key" "communitylab_ssh_key" {
  name       = "CommunityLab"
  public_key = file("${var.ssh_key_file}")
}

# Define variables

locals {
  user_data_config = <<-EOT
    #cloud-config
    users:
      - name: "${var.user}"
        groups: users, admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - "${hcloud_ssh_key.communitylab_ssh_key.public_key}"
  EOT
  
  terraform_resource_file = var.ide_ha_setup == true ? "resources_ha_ide.tpl" : "resources_non_ha_ide.tpl"
  ansible_inventory_file  = var.ide_ha_setup == true ? "inventory_ha_ide.tpl" : "inventory_non_ha_ide.tpl"
}

# Create local resource file for IDE in Hetzner Cloud

resource "local_file" "resource_file" {
  source   = "${path.module}/${local.terraform_resource_file}"
  filename = "${path.module}/communitylab_resources.tf"
}

# Create local user_data.yml for resource file

resource "local_file" "user_data" {
  content  = local.user_data_config
  filename = "${path.module}/user_data.yml"
}

# Create local Ansible inventory file for IDE in Hetzner Cloud

resource "local_file" "ansible_inventory" {
  content   = templatefile("${local.ansible_inventory_file}", { domain = var.domain })
  filename = "../inventory"
}
