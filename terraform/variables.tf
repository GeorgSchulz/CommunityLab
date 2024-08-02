terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.2.0"
    }
  }
  required_version = ">= 0.13"
}

variable "hetzner_token" {
  description = "Hetzner Cloud Token"
  type        = string
}

variable "hetznerdns_token" {
  description = "Hetzner DNS Token"
  type        = string
}

variable "location" {
  description = "Hetzner Cloud data center, available are: FI Helsinki (hel1), DE Falkenstein (fsn1), DE Nuremberg (nbg1), US Ashburn (ash) and US Hillsboro (hil)"
  type        = string
  default     = "hel1"
}

variable "os_type" {
  description = "OS image type for created VMs"
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_private_key_file" {
  description = "Location of SSH Private Key on local notebook"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_public_key_file" {
  description = "Location of SSH Public Key on local notebook"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "user" {
  description = "Executing user on notebook"
  type        = string
  default     = "georg"
}

variable "domain" {
  description = "Used domain for IDE deployment"
  type        = string
  default     = "example.com"
}

variable "ide_ha_setup" {
  description = "Variable to decide for IDE Non-HA or IDE HA setup, set to true for IDE HA setup"
  type        = bool
  default     = false
}

# To scale IDE change below values

variable "server_type_security" {
  description = "Server type of security server"
  type        = string
  default     = "cpx11"
}

variable "server_type_hub" {
  description = "Server type of hub server"
  type        = string
  default     = "cpx31"
}

variable "server_type_master" {
  description = "Server type of master server"
  type        = string
  default     = "cpx41"
}

variable "server_type_worker" {
  description = "Server type of worker server"
  type        = string
  default     = "cpx51"
}

variable "a_record_ttl" {
  description = "TTL for created A-records in Hetzner Cloud"
  type        = number
  default     = 600
}
