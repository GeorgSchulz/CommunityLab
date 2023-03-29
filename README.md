# CommunityLab

_CommunityLab_ is an Open-Source ready to use configuration system like Amazon Elastic MapReduce (EMR) and Azure Hadoop Insight (HDInsight).

Build your own high available and scalable Open-Source IDE in the Hetzner Cloud. If you want to use a different Cloud provider or On-Premises machines you can specify a custom Ansible inventory file (see step 3).

High-level design:

![High-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/HLD.bmp?raw=True)

The IDE can be installed as high available system but also in Non-HA mode. As default Non-HA mode is used to save costs when installing and running the IDE in a Cloud environment. If you want to setup the IDE in HA mode change the relevant Terraform variable in Hetzner Cloud (see step 2.2.1) or define 3 master nodes in your custom Ansible inventory file when using On-Premise machines or different Cloud provider.

Low-level design (Non-HA setup):

![Low-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_Non_HA.bmp?raw=True)

Low-level design (HA setup):

![Low-level design HA](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_HA.bmp?raw=True)

Following components are used:

| Component        | Version |
|------------------|---------|
| JupyterHub       | 3.1.1   |
| JupyterLab       | 3.4.7   |
| Apache Hadoop    | 3.3.3   |
| Apache Spark     | 3.1.2   |
| Apache Zookeeper | 3.8.0   |
| PostgreSQL       | 14      |

When using Hetzner Cloud following costs have to be considered (Non-HA):

| Server Name  | Server Type | CPU | RAM | Costs (day) | Costs (month) |
|--------------|-------------|-----|-----|-------------|---------------|
| hub1         | CPX31       | 4   | 8   | 0,60 €      | 15,59 €       |
| master1      | CPX41       | 8   | 16  | 1,18 €      | 29,39 €       |
| worker1      | CPX51       | 16  | 32  | 2,50 €      | 64,74 €       |
| worker2      | CPX51       | 16  | 32  | 2,50 €      | 64,74 €       |
| worker3      | CPX51       | 16  | 32  | 2,50 €      | 64,74 €       |
| security1    | CPX11       | 2   | 2   | 0,17 €      |  4,58 €       |
|              |             |     |     |             |               |
| CommunityLab |             | 62  | 122 | 9,45 €      | 243,78 €      |

If you are german speaking you may be interested in my related academic work: [Thesis.pdf](Thesis.pdf)

## 1. Prerequisites
### required
- Ubuntu (was tested on Ubuntu 22.04.2 LTS)
- Ansible (was tested on Ansible version 2.14.3)
- Python (was tested on Python version 3.9.16)

### optional
- Terraform (was tested on Terraform v1.4.2)
- A valid domain name
- Hetzner Account, Hetzner Cloud API Token (Read/Write) and Hetzner DNS Token

The installation process was tested on Ubuntu 22.04.2 LTS and Windows Ubuntu Subsystem.

## 2. Use Hetzner Cloud
### 2.1 Install Terraform and Ansible on your local machine if not present
```console
georg@notebook:~/git/CommunityLab$ bash requirements.sh 
```

### 2.2 Setup infrastructur in Hetzner Cloud using Terraform
#### 2.2.1 Define variables for your custom infrastructure (mandatory: hetzner_token, hetznerdns_token, ssh_key_file, user, domain, optional: ide_ha_setup, set to true for IDE in HA mode)
```console
georg@notebook:~/git/CommunityLab$ cd terraform
georg@notebook:~/git/CommunityLab/terraform$ vim variables.tf
```

#### 2.2.2 Initialize Terraform
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform init
```

#### 2.2.3 Create local files for Terraform resources and Ansible inventory
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform apply
```

#### 2.2.4 Now use created Terraform resources to create infrastructure in Hetzner Cloud
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform apply
```

#### 2.2.5 Verify infrastructure is successfully configured using Ansible
```console
georg@notebook:~/git/CommunityLab/terraform$ cd ../
georg@notebook:~/git/CommunityLab$ ansible all -m ping
```

### 2.3 Install and configure the IDE in Hetzner Cloud using Ansible
#### 2.3.1 Define variables for your custom environment
```console
georg@notebook:~/git/CommunityLab$ vim group_vars/all.yml
```

#### 2.3.2 Install and configure the IDE
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```

### 2.4 Delete infrastructure in Hetzner Cloud using Terraform
```console
georg@notebook:~/git/CommunityLab$ cd terraform
georg@notebook:~/git/CommunityLab/terraform$ terraform destroy
```

## 3. Install and configure the IDE in different Cloud or On-Prem using custom Ansible inventory file
### (You can also specify custom TLS, Kerberos and LDAP configuration)
### 3.1 You can specify following custom inventory in ini format
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

| Kerberos and LDAP server not present                                      | Kerberos and LDAP server already present                                          |
|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| Non-HA setup: [inventory](examples/custom_inventory_non_ha.ini)           | Non-HA setup: [inventory](examples/custom_inventory_non_ha_external_security.ini) |
| HA setup: [inventory](examples/custom_inventory_ha.ini)                   | HA setup: [inventory](examples/custom_inventory_ha_external_security.ini)         |

### 3.2 You can now install the IDE with your custom inventory file
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```
