package test

import (
	"testing"
	// "fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	// "github.com/stretchr/testify/assert"
)

var terraformDirectory = "../examples"
var region             = "us-east-1"
// var account            = ""

func Test_before_testing(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: terraformDirectory,
		Vars: map[string]interface{}{
			"aws_region": region,
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	// account = terraform.Output(t, terraformOptions, "account_id")
}
