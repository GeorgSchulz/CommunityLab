#!/bin/bash

export HCLOUD_TOKEN={{ hetzner_token }}
JUPYTERHUB_FLOATING_IP_ID=`hcloud floating-ip list | grep {{ jupyterhub_domain_ip_address.stdout }} | awk {'print $1'}`

# assign floating ip of domain jupyterhub.{{ domain }}
hcloud floating-ip assign $JUPYTERHUB_FLOATING_IP_ID {{ inventory_hostname_short }}
