package test

import (
	"testing"
	"os"
	"strings"
	"path"
	"fmt"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/stretchr/testify/assert"
)

// Get used values of deployed Terraform variables
var terraformVarFile = "./terraform.tfvars"
		
// Write custom function for converting path containing tilde sign to /home/<user>
func ConvertTildeString(t *testing.T, pathToFile string) (string) {
	if strings.HasPrefix(pathToFile, "~/") {
		home, _ 	:= os.UserHomeDir()
		pathToFile	= path.Join(home, pathToFile[2:])
	}

	return pathToFile
}

func TestTerraformCommunityLabPreflight(t *testing.T) {

	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
	
		// Set the path to the Terraform code that will be tested
		TerraformDir: "./",

	})

	// Get Terraform variable values that will be tested
	defaultHetznerToken 		:= "YOUR_HETZNER_CLOUD_TOKEN"
	defaultHetznerDNSToken 		:= "YOUR_HETZNER_DNS_TOKEN"
	defaultUser    	    		:= "georg"
	defaultDomain  	     		:= "example.com"
	deployedHetznerToken		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "hetzner_token")
	deployedHetznerDNSToken		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "hetznerdns_token")
	deployedUser   			:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "user")
	deployedDomain 			:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "domain")
	deployedSSHPrivateKey 		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "ssh_private_key_file")
	deployedSSHPublicKey 		:= terraform.GetVariableAsStringFromVarFile(t, terraformVarFile, "ssh_public_key_file")
	
	// Check if default values for mandatory variables were changed
        assert.NotEqual(t, defaultHetznerToken, deployedHetznerToken)
        assert.NotEqual(t, defaultHetznerDNSToken, deployedHetznerDNSToken)
        assert.NotEqual(t, defaultUser, deployedUser)
        assert.NotEqual(t, defaultDomain, deployedDomain)

	// Check if deployed SSH Private and Public Key are present on local notebook
	// Convert value of relevant Terraform variables to absolute path if tilde sign is present
	SSHPrivateKey := ConvertTildeString(t, deployedSSHPrivateKey)
	SSHPublicKey := ConvertTildeString(t, deployedSSHPublicKey)

	SSHPrivateKeyExists := files.IsExistingFile(SSHPrivateKey)
	SSHPublicKeyExists := files.IsExistingFile(SSHPublicKey)
	
	if !SSHPrivateKeyExists {
		t.Fatal(fmt.Printf("Defined SSH Private Key file %v in Terraform variable file %v is not present", deployedSSHPrivateKey, terraformVarFile))
	}
	
	if !SSHPublicKeyExists {
		t.Fatal(fmt.Printf("Defined SSH Public Key file %v in Terraform variable file %v is not present", deployedSSHPublicKey, terraformVarFile))
	}

	// Run "terraform init". Fail the test if there are any errors
	terraform.Init(t, terraformOptions)

}

func TestTerraformCommunityLabCreateLocalResources(t *testing.T) {
	
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
	
		// Set the path to the Terraform code that will be tested
		TerraformDir: "./",

	})

        // Running "terraform apply" creates local files for Terraform resources and Ansible inventory
	terraform.Apply(t, terraformOptions)

}

func TestTerraformCommunityLabDeployment(t *testing.T) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested
	 	TerraformDir: "./",

	})

        // Create infrastructure in Hetzner Cloud by running "terraform apply" again
	terraform.Apply(t, terraformOptions)
        
}
