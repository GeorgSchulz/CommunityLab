package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)


func TestTerraformCommunityLabDestroyAllResources(t *testing.T) {
	
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
	
		// Set the path to the Terraform code that will be tested
		TerraformDir: "./",

	})

	// Clean up resources with "terraform destroy" at the end of the test
        defer terraform.Destroy(t, terraformOptions)

}
