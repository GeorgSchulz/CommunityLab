# Define used variables
miniforge_script=Miniforge3-Linux-x86_64.sh
miniforge_url=https://github.com/conda-forge/miniforge/releases/latest/download/$miniforge_script
miniforge_base=/opt/miniforge
miniforge_path=/opt/miniforge/miniforge3
miniforge_link=/opt/miniforge/miniforge
ansible_vault_file=~/.vault_pass.txt

echo "===================================================================================================================="
echo "========================      Idempotent installation script for Terraform and Ansible      ========================"
echo "===================================================================================================================="
echo ""

# Install Terraform if not present
if command_output=$(terraform -version > /dev/null 2>&1)
then
    	echo "Terraform is already installed."
    	echo ""
	echo "Using Terraform version:"
	echo ""
    	terraform -version
	echo ""
else
    	echo "Terraform is not installed."
	echo ""

   	sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
        wget -O- https://apt.releases.hashicorp.com/gpg | \
	gpg --dearmor | \
	sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
	https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
	sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update
	sudo apt-get install terraform
    	
	echo "Successfully installed Terraform."
    	echo ""
	echo "Using Terraform version:"
    	terraform -version
	echo ""
fi

# Install Ansible if not present
if command_output=$(ansible --version > /dev/null 2>&1)
then
	echo "Ansible is already installed."
	echo ""
	echo "Using Ansible version:"
	ansible --version
	echo ""
else
	echo "Ansible is not installed."
	echo ""

	# Remove present Miniforge files in /tmp
	rm /tmp/Miniforge* > /dev/null 2>&1

	# Check if Miniforge is installed and remove if present
	if [ -d $miniforge_base ]
	then
		sudo rm -rf $miniforge_base
	fi

	echo "===================================================================================================================="
	echo "=======================================      Install Ansible using Miniforge ======================================="
	echo "===================================================================================================================="
	echo ""

	wget -P /tmp $miniforge_url
	sudo -s <<EOF
        	# Set default Python version to Python3
        	alternatives --set python /usr/bin/python3

		# Install Ansible using Miniforge
        	bash /tmp/$miniforge_script -b -p $miniforge_path
        	source $miniforge_path/etc/profile.d/conda.sh
        	conda create -n ansible python=3.9 -y
        	conda activate ansible
        	conda install -c conda-forge ansible -y
        	conda deactivate
        	ln -s $miniforge_path $miniforge_link
EOF
	sudo chown -R $USER: $miniforge_base
	
	echo ""
	echo "===================================================================================================================="
	echo "============================================     Configure Ansible     ============================================="
	echo "===================================================================================================================="
	echo ""

	# Create Ansible vault password if not present
	if [ ! -f $ansible_vault_file ]
	then
		read -sp "Enter Ansible Vault Password: "
		echo ""
		sudo echo $REPLY > $ansible_vault_file
		sudo chown $USER: $ansible_vault_file
		chmod 600 $ansible_vault_file
	fi

	# Configure Ansible usage
	if grep -Fxq "PATH=\"\$PATH:/opt/miniforge/miniforge/envs/ansible/bin\"" ~/.bashrc
	then
		echo "Ansible Path for Miniforge is already set in ~/.bashrc file."
		echo ""
	else
		echo "PATH=\"\$PATH:/opt/miniforge/miniforge/envs/ansible/bin\"" >> ~/.bashrc
    		source ~/.bashrc
	fi
	
	echo "Successfully installed Ansible."
    	echo ""
	echo "Using Ansible version:"
	echo ""
    	ansible --version
	echo ""
fi

echo "===================================================================================================================="
echo "========================      Installation process for Terraform and Ansible finished      ========================="
echo "===================================================================================================================="
echo ""
