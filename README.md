# CommunityLab

_CommunityLab_ is an Open-Source ready to use configuration system like Amazon Elastic MapReduce and Azure Hadoop Insight.

Build your own high available and scalable Open-Source IDE in the Hetzner Cloud. If you want to use a different Cloud provider or On-Premises machines you can specify a custom ansible inventory file (see step 6).

High-level design:

![High-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/HLD.bmp?raw=True)

The IDE can be installed as high available system but also in Non-HA mode. As default Non-HA mode is used to save costs when installing and running the IDE in a Cloud environment. If you want to setup the IDE in HA mode see step 5.

Low-level design (Non-HA setup):

![Low-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_Non_HA.bmp?raw=True)

Low-level design (HA setup):

![Low-level design HA](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_HA.bmp?raw=True)

If you are german speaking you may be interested in my academic work: [Thesis.pdf](Thesis.pdf)

## 1. Prerequisites
## required
- Ubuntu (was tested on Ubuntu 20.04.4 LTS)
- Ansible (was tested on Ansible version 2.12.1)
- Python (was tested on Python version 3.9.9)

## optional
- A valid domain name
- Hetzner Account and Hetzner API Token (Read/Write)

The installation process was tested on Ubuntu 20.04.4 LTS and Windows Ubuntu Subsystem.

## 2. Install Ansible on your local machine if not present
```console
georg@notebook:~/git/CommunityLab$ bash requirements.sh 
```

## 3. Setup repository for your custom environment by editing group_vars/all.yml
```console
georg@notebook:~/git/CommunityLab$ vim group_vars/all.yml
```

## 4. Install and configure the IDE in the Hetzner Cloud
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```

## 5. Install and configure the IDE in HA mode
### 5.1 Change default variable ***ide\_ha\_setup: false** to ***ide\_ha\_setup: true***
```console
georg@notebook:~/git/CommunityLab$ vim group_vars/all.yml
```

### 5.2 Install and configure the IDE in the Hetzner Cloud using HA setup
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```

## 6. Install and configure the IDE in different Cloud or On-Prem using custom inventory 
### (You can also specify custom TLS, Kerberos and LDAP configuration)
### 6.1 You can specify following custom inventory in ini format
```console
[ansible]
localhost

[hub1]
hub1.example.com 

[hubs:children]
hub1

[hubs:vars]
tls_user={{ jupyterhub_user }}
postgres_client=True

[master1]
master1.example.com zookeeper_id=1

[masters:children]
master1

[masters:vars]
tls_user={{ hdfs_user }}

[worker1]
worker1.example.com patroni_id=1

[worker2]
worker2.example.com patroni_id=2

[worker3]
worker3.example.com patroni_id=3

[workers:children]
worker1
worker2
worker3

[workers:vars]
tls_user={{ hdfs_user }}

# If using your own certs and Java Keystore/Truststores you have to define following variables
cert_file_postgres=/etc/ssl/private/cert_postgres.pem
key_file_postgres=/etc/ssl/private/key_postgres.pem
chain_file_postgres=/etc/ssl/private/chain_postgres.pem

[all:children]
ansible
hubs
masters
workers

[all:vars]
custom_inventory_file=True
keytab_user_hdfs={{ hdfs_user }}
keytab_user_yarn={{ yarn_user }}
keytab_user_http=HTTP
keytab_user_jupyter={{ jupyterhub_user }}

# If Kerberos server is present you have to define following variables
kerberos_external=True

# If using your own certs and Java Keystore/Truststores you have to define following variables
tls_external=True
cert_file=/etc/ssl/private/cert.pem
key_file=/etc/ssl/private/key.pem
keystore_file=/etc/ssl/private/{{ inventory_hostname }}.jks
truststore_file=/etc/ssl/certs/truststore.jks
haproxy_pem_file=/etc/ssl/private/haproxy.pem

# If LDAP server is present you have to define following variables
ldap_external=True
ldap_server_address=0.0.0.0
ldap_bind_user=cn=admin,{{ ldap_organization }}
ldap_bind_dn_template=UID={username},OU=people,{{ ldap_organization_upper }}
ldap_user_search_base=OU=people,{{ ldap_organization_upper }}
ldap_group_search_base=ou=groups,{{ ldap_organization }}
```

For other custom inventory examples see: 

| Kerberos and LDAP server already present                                  | Kerberos and LDAP server not present                                              |
|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| Non-HA setup: [inventory](examples/custom_inventory_non_ha.ini)           | Non-HA setup: [inventory](examples/custom_inventory_non_ha_external_security.ini) |
| HA setup: [inventory](examples/custom_inventory_ha.ini)                   | HA setup: [inventory](examples/custom_inventory_ha_external_security.ini)         |

### 6.2 You can now install the IDE with your custom inventory file
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```
