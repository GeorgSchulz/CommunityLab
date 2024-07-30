# CommunityLab

_CommunityLab_ is an Open-Source ready to use configuration system like Amazon Elastic MapReduce (EMR) and Azure Hadoop Insight (HDInsight).

Build your own high available and scalable Open-Source IDE in the Hetzner Cloud. If you want to use a different Cloud provider or On-Premises machines you can specify a custom Ansible inventory file (see step 3).

High-level design:

![High-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/HLD.bmp?raw=True)

The IDE can be installed as high available system but also in Non-HA mode. As default Non-HA mode is used to save costs when installing and running the IDE in a Cloud environment. 

Low-level design (Non-HA setup):

![Low-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_Non_HA.bmp?raw=True)

If you want to setup the IDE in HA mode change the relevant Terraform variable in Hetzner Cloud (see step 2.2.1) or define 3 master nodes in your custom Ansible inventory file when using On-Premise machines or different Cloud provider.

Low-level design (HA setup):

![Low-level design HA](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_HA.bmp?raw=True)

Following components are used:

| Component        | Version |
|------------------|---------|
| JupyterHub       | 3.1.1   |
| JupyterLab       | 3.4.7   |
| Apache Hadoop    | 3.3.4   |
| Apache Spark     | 3.1.2   |
| Apache Zookeeper | 3.8.0   |
| PostgreSQL       | 16      |

The conda environments used for JupyterHub and JupyterLab contain following packages:
- [JupyterHub](collections/ansible_collections/jupyter/hub/roles/install/files/jupyterhubenvironment.txt)
- [JupyterLab](collections/ansible_collections/jupyter/lab/roles/setup/files/jupyterlabenvironment.txt)

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
- Ubuntu (was tested on Ubuntu 22.04.4 LTS)
- Ansible (was tested on Ansible version 2.15.5)
- Python (was tested on Python version 3.9.19)

### optional
- Terraform (was tested on Terraform version v1.9.3)
- Go (was tested on Go version go1.18.1)
- A valid domain name
- Hetzner Account, Hetzner Cloud API Token (Read/Write) and Hetzner DNS Token

The installation process was tested on Ubuntu 22.04.4 LTS and [Windows Ubuntu Subsystem](https://learn.microsoft.com/de-de/windows/wsl/install).

## 2. Use Hetzner Cloud
### 2.1 Install Terraform, Go and Ansible on your local machine if not present
```console
georg@notebook:~/git/CommunityLab$ bash requirements.sh 
```

### 2.2 Setup infrastructure in Hetzner Cloud using Terraform
#### 2.2.1 Define variables for your custom infrastructure (mandatory: hetzner_token, hetznerdns_token, ssh_public_key_file, ssh_private_key_file, user, domain; optional: ide_ha_setup, set to true for IDE in HA mode)
```console
georg@notebook:~/git/CommunityLab$ cd terraform/
georg@notebook:~/git/CommunityLab/terraform$ vim terraform.tfvars
```

#### 2.2.2 Configure dependencies for Terratest
```console
georg@notebook:~/git/CommunityLab$ cd test/
georg@notebook:~/git/CommunityLab/terraform/test$ go mod init hcloud.tf
georg@notebook:~/git/CommunityLab/terraform/test$ go mod tidy
```

#### 2.2.3 Test following Terraform deployment
```console
georg@notebook:~/git/CommunityLab/terraform/test$ go test deployment_test.go -v
```

#### 2.2.4 Verify created DNS and Reverse DNS entries of VMs in Hetzner Cloud are correct and SSH connection to VMs is possible
```console
georg@notebook:~/git/CommunityLab/terraform/test$ go test connection_test.go -v
```

#### 2.2.5 Verify infrastructure can be destroyed using Terraform
```console
georg@notebook:~/git/CommunityLab/terraform/test$ go test destruction_test.go -v
```


#### 2.2.6 Initialize Terraform after successfully testing all Terraform deployment steps
```console
georg@notebook:~/git/CommunityLab/terraform/test$ cd ../
georg@notebook:~/git/CommunityLab/terraform$ terraform init
```

#### 2.2.7 Create local files for Terraform resources and Ansible inventory
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform apply
```

#### 2.2.8 Now use created Terraform resources to create infrastructure in Hetzner Cloud
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform apply
```

### 2.3 Install and configure the IDE in Hetzner Cloud using Ansible
#### 2.3.1 Define variables for your custom environment (mandatory: domain, my_email)
```console
georg@notebook:~/git/CommunityLab$ vim group_vars/all.yml
```

#### 2.3.2 Install and configure the IDE
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```

### 2.4 Access IDE via JupyterHub
#### (e.g. using domain: example.com)
#### 2.4.1 Non-HA IDE
Use credentials of variable ldap_users in group_vars/all.yml and login here: https://hub1.example.com

#### 2.4.2 HA IDE
Use credentials of variable ldap_users in group_vars/all.yml and login here: https://jupyterhub.example.com

### 2.5 Delete infrastructure in Hetzner Cloud using Terraform
```console
georg@notebook:~/git/CommunityLab$ cd terraform
georg@notebook:~/git/CommunityLab/terraform$ terraform destroy
```

## 3. Install and configure the IDE in different Cloud or On-Prem using custom Ansible inventory file
### (You can also specify custom TLS, Kerberos and LDAP configuration)
### 3.1 You can specify following custom inventory in INI format
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

# If Kerberos server is present you have to define following variable
kerberos_external=True

# If using your own certs and Java Keystore/Truststores you have to define following variable, set other values in section "Parameters for TLS" in group_vars/all.yml
tls_external=True

# If LDAP server is present you have to define following variable, set other values in section "Parameters when connecting to LDAP server" in group_vars/all.yml
ldap_external=True
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

## 4. IDE Usage
### 4.1 Use Git integration in JupyterLab

After entering JupyterLab you can work with your GitHub or GitLab repositories by cloning them using the provided Git integration on the left side:
 
![Git Integration: Clone existing GitHub repository](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/git_clone.bmp?raw=True)

Having successfully cloned your repository you can now directly interact with it:
 
![Git Integration: Interact with GitHub repository](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/git_repo.bmp?raw=True)

### 4.2 Use Apache Spark in JupyterLab

Besides classical Data Science analysis using Python packages like NumPy, Pandas or scikit-learn you may want to use Apache Spark in JupyterLab. This example code shows how to import the Python library PySpark and write data to HDFS or load data from HDFS in Parquet format.

![Example Code: Usage of Python library PySpark](examples/spark_example.ipynb)

### 4.3 Store all used files in HDFS and make them available for other team members

After finishing your work in JupyterLab you can persist all your files in HDFS and stop your running YARN container. 

You can copy your files to HDFS by using the **hdfs dfs -copyFromLocal <src> <dest>** command in the terminal of JupyterLab. If you want to provide files for other members of your Data Science project just copy them to the **/share** folder in HDFS. Files in this folder can be changed and deleted by all IDE users:

![Copy files from JupyterLab to HDFS](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/hdfs_copyFromLocal_command.bmp?raw=True)

Other team members can easily access them by using the **hdfs dfs -copyToLocal <src> <dest>** command in the terminal of JupyterLab and download them in their running YARN container:
 
![Download files from HDFS to JupyterLab](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/hdfs_copyToLocal_command.bmp?raw=True)
