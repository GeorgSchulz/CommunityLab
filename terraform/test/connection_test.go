package test

import (
	"testing"
	"os"
	"strings"
	"path"
	"fmt"
	"net"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/stretchr/testify/assert"
)

// Get used values of deployed Terraform variables
var terraformVarFile = "./terraform.tfvars"
		
// Define variables for testing both non HA and HA setup of IDE
var CommunityLabServersNonHA = []string{
	"hub1",
	"master1",
	"worker1",
	"worker2",
	"worker3",
	"security1",
}

var CommunityLabServersHA = []string{
	"hub1",
	"hub2",
	"master1",
	"master2",
	"master3",
	"worker1",
	"worker2",
	"worker3",
	"security1",
	"security2",
}
	
// Write custom function for converting path containing tilde sign to /home/<user>
func ConvertTildeString(t *testing.T, pathToFile string) (string) {
	if strings.HasPrefix(pathToFile, "~/") {
		home, _ 	:= os.UserHomeDir()
		pathToFile	= path.Join(home, pathToFile[2:])
	}

	return pathToFile
}

// Write custom function for testing DNS and Reverse DNS of created VMs in Hetzner Cloud
func CheckDNS(t *testing.T, hostname string, domainName string) (bool, error) {
	serverIPArray, err := net.LookupIP(hostname + "." + domainName)
	
	if err != nil {
		fmt.Fprintf(os.Stderr, "Could not get IP: %v\n", err)
		os.Exit(1)
	}
		
	serverIPString 		:= fmt.Sprintf("%s", serverIPArray[0])
	serverIP 		:= strings.Trim(serverIPString, ".")
	serverNameArray, err 	:= net.LookupAddr(serverIP)
	
	if err != nil {
		fmt.Fprintf(os.Stderr, "Could not get A record name: %v\n", err)
		os.Exit(1)
	}


	serverNameString 	:= fmt.Sprintf("%s", serverNameArray[0])
	serverName 		:= strings.Trim(serverNameString, ".")
	
	assert.Equal(t, serverName, hostname + "." + domainName)

	if err != nil {
		return false, err
	}
	
	return err == nil, nil

}

// Write custom function for testing SSH connection to created VMs in Hetzner Cloud
func CheckSSHConnection(t *testing.T, hostname string, domainName string, sshUsername string, sshPrivateKeyfilePath string) {
	publicHostname 		:= hostname + "." + domainName
	SSHPrivateKeyContent, _ := os.ReadFile(ConvertTildeString(t, sshPrivateKeyfilePath))
	SSHPrivateKey		:= string(SSHPrivateKeyContent)
	keypair 		:= ssh.KeyPair{PrivateKey: SSHPrivateKey}
	
	publicHost := ssh.Host{
			Hostname:    publicHostname,
			SshKeyPair:  &keypair,
			SshUserName: sshUsername,
		}			
				
	// It can take a minute or so for the Instance to boot up, so retry a few times
	maxRetries 		:= 30
	timeBetweenRetries 	:= 5 * time.Second
	description 		:= fmt.Sprintf("SSH to public host %s", publicHostname)

	// Run a simple echo command on the server
	expectedText 	:= "Hello, World"
	command 	:= fmt.Sprintf("echo -n '%s'", expectedText)

	// Verify that we can SSH to the Instance and run commands
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckSshCommandE(t, publicHost, command)
		
		if err != nil {
			return "", err
		}

		if strings.TrimSpace(actualText) != expectedText {
			return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
		}

		return "", nil
	})

}

func TestTerraformCommunityLabDNS(t *testing.T) {
        
	// Get used values of deployed Terraform variables
	ideHASetup		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "ide_ha_setup")
	deployedDomain 		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "domain")

	if ideHASetup == "false" {

		for _, serverName := range CommunityLabServersNonHA {
			
			CheckDNS(t, serverName, deployedDomain)

		}

	} else {
		
		for _, serverName := range CommunityLabServersHA {
			
			CheckDNS(t, serverName, deployedDomain)

		}

	}
	
}

func TestTerraformCommunityLabSSHConnection(t *testing.T) {
        
	// Get used values of deployed Terraform variables
	ideHASetup			:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "ide_ha_setup")
	deployedDomain 			:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "domain")
	deployedUser 			:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "user")
	deployedSSHPrivateKey 		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "ssh_private_key_file")

	if ideHASetup == "false" {

		for _, serverName := range CommunityLabServersNonHA {
			
			CheckSSHConnection(t, serverName, deployedDomain, deployedUser, deployedSSHPrivateKey)

		}

	} else {
		
		for _, serverName := range CommunityLabServersHA {
			
			CheckSSHConnection(t, serverName, deployedDomain, deployedUser, deployedSSHPrivateKey)

		}

	}
	
}
