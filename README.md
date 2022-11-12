# CommunityLab

_CommunityLab_ is an Open-Source ready to use configuration system like Amazon Elastic MapReduce and Azure Hadoop Insight.

Build your own high available and scalable Open-Source IDE in the Hetzner Cloud. If you want to use a different Cloud provider or On-Premises machines you can specify a custom ansible inventory file (see step 5).

High-level design:

![High-level desing](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/HLD.jpg?raw=True)


Low-level design:

![Low-level desing](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD.png?raw=True)

If you are german speaking you may be interested in my academic work: [Thesis.pdf](Thesis.pdf) <br /> 

## 1. Prerequisites
## required
- Ubuntu (was tested on Ubuntu 20.04.4 LTS)
- Ansible (was testet on Ansible version 2.12.1)
- Python (was testet on Python version 3.9.9)

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

## 5. Install and configure the IDE in different Cloud or On-Prem using custom inventory 
### (You can also specify custom TLS, Kerberos and LDAP configuration)
### 5.1 You can specify following custom inventory in ini format
```console
[ansible]
localhost

[hub1]
hub1.example.com

[hub2]
hub2.example.com

[hubs:children]
hub1
hub2

[hubs:vars]
# If Kerberos server is present you have to define following variables
keytab_user_jupyter={{ jupyterhub_user }}

[master1]
master1.example.com zookeeper_id=1

[master2]
master2.example.com zookeeper_id=2

[master3]
master3.example.com zookeeper_id=3

[masters:children]
master1
master2
master3

[masters:vars]
# If Kerberos server is present you have to define following variables
keytab_user_hdfs={{ hdfs_user }}
keytab_user_yarn={{ yarn_user }}
keytab_user_journalnode={{ journalnode_user }}
keytab_user_http=HTTP
keytab_user_jupyter={{ jupyterhub_user }}

[worker1]
worker1.example.com

[worker2]
worker2.example.com

[worker3]
worker3.example.com

[workers:children]
worker1
worker2
worker3

[workers:vars]
# If using your own certs and Java Keystore/Truststores you have to define following variables
cert_file_postgres=/etc/ssl/private/cert_postgres.pem
key_file_postgres=/etc/ssl/private/key_postgres.pem
chain_file_postgres=/etc/ssl/private/key_postgres.pem

# If Kerberos server is present you have to define following variables
keytab_user_hdfs={{ hdfs_user }}
keytab_user_yarn={{ yarn_user }}
keytab_user_journalnode={{ journalnode_user }}
keytab_user_http=HTTP
keytab_user_jupyter={{ jupyterhub_user }}

[security1]
security1.example.com 

[security2]
security2.example.com

[securites:children]
security1
security2

[all:children]
ansible
hubs
masters
workers
securities

[all:vars]
custom_inventory_file=True

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

# If Kerberos server is present you have to define following variables
kerberos_external=True
keytab_folder=/etc/keytabs
```

### 5.2 You can now install the IDE with your custom inventory file
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```
