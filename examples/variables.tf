terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.1.0"
    }
  }
  required_version = ">= 0.13"
}

variable "hetzner_token" {
  default = "YOUR_HETZNER_CLOUD_TOKEN"
}

variable "hetznerdns_token" {
  default = "YOUR_HETZNER_DNS_TOKEN"
}

variable "location" {
  # Hetzner Cloud data center, available are: FI Helsinki (hel1), DE Falkenstein (fsn1), DE Nuremberg (nbg1), US Ashburn (ash) and US Hillsboro (hil)
  default = "hel1"
}

variable "os_type" {
  default = "ubuntu-22.04"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "user" {
  # executing user on notebook
  default = "georg"
}

variable "domain" {
  default = "example.com"
}

variable "ide_ha_setup" {
  # Variable to decide for IDE Non-HA or IDE HA setup, set to true for IDE HA setup
  default = false
}

# To scale IDE change below values

variable "server_type_security" {
  default = "cpx11"
}

variable "server_type_hub" {
  default = "cpx31"
}

variable "server_type_master" {
  default = "cpx41"
}

variable "server_type_worker" {
  default = "cpx51"
}

# TTL for created A-records

variable "a_record_ttl" {
  default = 600
}
