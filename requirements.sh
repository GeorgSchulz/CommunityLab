# Define variables for Ansible installation
miniforge_script=Miniforge3-Linux-x86_64.sh
miniforge_url=https://github.com/conda-forge/miniforge/releases/latest/download/$miniforge_script
miniforge_base=/opt/miniforge
miniforge_path=/opt/miniforge/miniforge3
miniforge_link=/opt/miniforge/miniforge

rm /tmp/Miniforge*

if [ -d /opt/miniforge ]
then
	sudo rm -rf /opt/miniforge
fi

# Install Ansible using Miniforge
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

# Create Ansible vault password
read -sp "Enter Ansible Vault Password: "
sudo echo $REPLY > ~/.vault_pass.txt
sudo chown $USER: ~/.vault_pass.txt
chmod 600 ~/.vault_pass.txt

# Configure Ansible usage
if grep -Fxq "PATH=\"\$PATH:/opt/miniforge/miniforge/envs/ansible/bin\"" ~/.bashrc
then
	exit
else
	echo "PATH=\"\$PATH:/opt/miniforge/miniforge/envs/ansible/bin\"" >> ~/.bashrc
    	source ~/.bashrc
fi
