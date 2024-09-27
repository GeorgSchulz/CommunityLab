# CommunityLab

_CommunityLab_ is an Open-Source ready to use configuration system like Amazon Elastic MapReduce (EMR) and Azure Hadoop Insight (HDInsight).

Build your own high available and scalable Open-Source IDE using Ansible. The relevant Ansible Collections of the IDE are tested using [Ansible Molecule](https://ansible.readthedocs.io/projects/molecule/).

_CommunityLab_ consists of following components:

| Component        | Version |
|------------------|---------|
| JupyterHub       | 5.1.0   |
| JupyterLab       | 4.2.4   |
| Apache Hadoop    | 3.4.0   |
| Apache Spark     | 3.5.1   |
| Apache Zookeeper | 3.9.2   |
| PostgreSQL       | 16      |

Each component can be deployed with Ansible Molecule on your local notebook using Docker Container and self signed certificates (see step 2).

If you want to setup your own VMs for the IDE, you can use Terraform (Hetzner Cloud). The deployment process for Terraform is also tested with [Terratest](https://terratest.gruntwork.io/) (see step 3).

If you want to use a different Cloud provider or On-Premises machines you can specify a custom Ansible inventory file (see step 4). 

High-level design:

![High-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/HLD.bmp?raw=True)

The IDE can be installed as high available system but also in Non-HA mode. As default Non-HA mode is used to save costs when installing and running the IDE in a Cloud environment. 

Low-level design (Non-HA setup):

![Low-level design](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_Non_HA.bmp?raw=True)

If you want to setup the IDE in HA mode change the relevant Terraform variable in Hetzner Cloud (see step 2.2.1) or define 3 master nodes in your custom Ansible inventory file when using On-Premise machines or different Cloud provider.

Low-level design (HA setup):

![Low-level design HA](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/LLD_HA.bmp?raw=True)

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
- Ubuntu (was tested on Ubuntu 24.04 LTS)
- Ansible (was tested on Ansible version 2.17.3)
- Python (was tested on Python version 3.12.5)

### optional
- Molecule (was tested on Molecule version 24.7.0)
- Docker (was tested on Docker version 27.1.2, required for Ansible Molecule)
- Terraform (was tested on Terraform version v1.9.3)
- Go (was tested on Go version go1.18.1)
- A valid domain name
- Hetzner Account, Hetzner Cloud API Token (Read/Write) and Hetzner DNS Token

The installation process was tested on Ubuntu 24.04 LTS and [Windows Ubuntu Subsystem](https://learn.microsoft.com/de-de/windows/wsl/install).

## 2. Use Ansible Molecule
### 2.1 Install Ansible and Molecule on your local machine if not present
```console
georg@notebook:~/git/CommunityLab$ bash requirements.sh
```

### 2.2 Ansible Molecule is available for following Ansible Collections
```console
georg@notebook:~/git/CommunityLab$ find . -name extensions
./collections/ansible_collections/jupyter/hub/extensions
./collections/ansible_collections/authentication/kerberos/extensions
./collections/ansible_collections/hadoop/hdfs/extensions
./collections/ansible_collections/hadoop/yarn/extensions
./collections/ansible_collections/bigdata/spark/extensions
./collections/ansible_collections/bigdata/zookeeper/extensions
./collections/ansible_collections/rdbms/postgres/extensions
./collections/ansible_collections/authorization/ldap/extensions
```

### 2.3 The IDE can be installed using Ansible Molecule like this (Docker is required)
```console
georg@notebook:~/git/CommunityLab$ cd collections/ansible_collections/jupyter/hub/extensions/
georg@notebook:~/git/CommunityLab/collections/ansible_collections/jupyter/hub/extensions$ molecule converge
```

### 2.4 Check container created by Ansible Molecule
```console
georg@notebook:~/git/CommunityLab/collections/ansible_collections/jupyter/hub/extensions$ docker container ls
CONTAINER ID   IMAGE                                   COMMAND                  CREATED             STATUS             PORTS     NAMES
a33331864a0e   geerlingguy/docker-ubuntu2404-ansible   "/usr/lib/systemd/sy…"   About an hour ago   Up About an hour             instance-6
9ea4bebf4d72   geerlingguy/docker-ubuntu2404-ansible   "/usr/lib/systemd/sy…"   About an hour ago   Up About an hour             instance-5
24f7cf1a2789   geerlingguy/docker-ubuntu2404-ansible   "/usr/lib/systemd/sy…"   About an hour ago   Up About an hour             instance-4
7c8c3790565b   geerlingguy/docker-ubuntu2404-ansible   "/usr/lib/systemd/sy…"   About an hour ago   Up About an hour             instance-3
55440ed1459e   geerlingguy/docker-ubuntu2404-ansible   "/usr/lib/systemd/sy…"   About an hour ago   Up About an hour             instance-2
16591b433003   geerlingguy/docker-ubuntu2404-ansible   "/usr/lib/systemd/sy…"   About an hour ago   Up About an hour             instance-1
```

### 2.5 Get IP address of Docker container running JupyterHub
```console
georg@notebook:~/git/CommunityLab/collections/ansible_collections/jupyter/hub/extensions$ docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' instance-1
172.23.27.3
```

### 2.6 Start Firefox browser
```console
georg@notebook:~/git/CommunityLab/collections/ansible_collections/jupyter/hub/extensions$ firefox
```

### 2.7 Login to JupyterHub here using credentials of variable [ldap_users](./collections/ansible_collections/jupyter/hub/extensions/molecule/default/molecule.yml):
https://172.23.27.3:8443

![IDE Docker](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/ide_in_docker.bmp?raw=True)

### 2.6 Delete all Docker container using Ansible Molecule
```console
georg@notebook:~/git/CommunityLab/collections/ansible_collections/jupyter/hub/extensions$ molecule destroy
```

## 3. Use Hetzner Cloud
### 3.1 Install Terraform, Go and Ansible on your local machine if not present
```console
georg@notebook:~/git/CommunityLab$ bash requirements.sh all
```

### 3.2 Setup infrastructure in Hetzner Cloud using Terraform
#### 3.2.1 Define variables for your custom infrastructure (mandatory: hetzner_token, hetznerdns_token, ssh_public_key_file, ssh_private_key_file, user, domain; optional: ide_ha_setup, set to true for IDE in HA mode)
```console
georg@notebook:~/git/CommunityLab$ cd terraform/
georg@notebook:~/git/CommunityLab/terraform$ vim terraform.tfvars
```

#### 3.2.2 Configure dependencies for Terratest
```console
georg@notebook:~/git/CommunityLab/terraform$ cd test/
georg@notebook:~/git/CommunityLab/terraform/test$ go mod init hcloud.tf
georg@notebook:~/git/CommunityLab/terraform/test$ go mod tidy
```

#### 3.2.3 Test following Terraform deployment
```console
georg@notebook:~/git/CommunityLab/terraform/test$ go test deployment_test.go -v
```

#### 3.2.4 Verify created DNS and Reverse DNS entries of VMs in Hetzner Cloud are correct and SSH connection to VMs is possible
```console
georg@notebook:~/git/CommunityLab/terraform/test$ go test connection_test.go -v
```

#### 3.2.5 Verify infrastructure can be destroyed using Terraform
```console
georg@notebook:~/git/CommunityLab/terraform/test$ go test destruction_test.go -v
```


#### 3.2.6 Initialize Terraform after successfully testing all Terraform deployment steps
```console
georg@notebook:~/git/CommunityLab/terraform/test$ cd ../
georg@notebook:~/git/CommunityLab/terraform$ terraform init
```

#### 3.2.7 Create local files for Terraform resources and Ansible inventory
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform apply
```

#### 3.2.8 Now use created Terraform resources to create infrastructure in Hetzner Cloud
```console
georg@notebook:~/git/CommunityLab/terraform$ terraform apply
```

### 3.3 Install and configure the IDE in Hetzner Cloud using Ansible
#### 3.3.1 Define variables for your custom environment (mandatory: my_email)
```console
georg@notebook:~/git/CommunityLab$ vim group_vars/all.yml
```

#### 3.3.2 Install and configure the IDE
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```

### 3.4 Access IDE via JupyterHub
#### (e.g. using domain: example.com)
#### 3.4.1 Non-HA IDE
Use credentials of variable [ldap_users](./group_vars/all.yml) and login here: https://hub1.example.com:8443

#### 3.4.2 HA IDE
Use credentials of variable [ldap_users](./group_vars/all.yml) and login here: https://jupyterhub.example.com

### 3.5 Delete infrastructure in Hetzner Cloud using Terraform
```console
georg@notebook:~/git/CommunityLab$ cd terraform
georg@notebook:~/git/CommunityLab/terraform$ terraform destroy
```

## 4. Install and configure the IDE in different Cloud or On-Prem using custom Ansible inventory file
### (You can also specify custom TLS, Kerberos and LDAP configuration)
### 4.1 Copy Terraform inventory template and change relevant variables for your custom environment if necessary
### For Non-HA IDE:
```console
georg@notebook:~/git/CommunityLab$ cp terraform/inventory_non_ha_ide.tpl inventory
```

### For HA IDE:
```console
georg@notebook:~/git/CommunityLab$ cp terraform/inventory_ha_ide.tpl inventory
```

### 4.2 You can now install the IDE with your custom inventory file
```console
georg@notebook:~/git/CommunityLab$ ansible-playbook setup.yml
```

## 5. IDE Usage
### 5.1 Use Git integration in JupyterLab

After entering JupyterLab you can work with your GitHub or GitLab repositories by cloning them using the provided Git integration on the left side:
 
![Git Integration: Clone existing GitHub repository](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/git_clone.bmp?raw=True)

Having successfully cloned your repository you can now directly interact with it:
 
![Git Integration: Interact with GitHub repository](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/git_repo.bmp?raw=True)

### 5.2 Use Apache Spark in JupyterLab

Besides classical Data Science analysis using Python packages like NumPy, Pandas or scikit-learn you may want to use Apache Spark in JupyterLab. This example code shows how to import the Python library PySpark and write data to HDFS or load data from HDFS in Parquet format.

![Example Code: Usage of Python library PySpark](examples/spark_example.ipynb)

### 5.3 Store all used files in HDFS and make them available for other team members

After finishing your work in JupyterLab you can persist all your files in HDFS and stop your running YARN container. 

You can copy your files to HDFS by using the **hdfs dfs -copyFromLocal <src> <dest>** command in the terminal of JupyterLab. If you want to provide files for other members of your Data Science project just copy them to the **/share** folder in HDFS. Files in this folder can be changed and deleted by all IDE users:

![Copy files from JupyterLab to HDFS](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/hdfs_copyFromLocal_command.bmp?raw=True)

Other team members can easily access them by using the **hdfs dfs -copyToLocal <src> <dest>** command in the terminal of JupyterLab and download them in their running YARN container:
 
![Download files from HDFS to JupyterLab](https://github.com/GeorgSchulz/CommunityLab/blob/master/images/hdfs_copyToLocal_command.bmp?raw=True)
