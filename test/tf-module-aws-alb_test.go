package test

import (
	"testing"
	"fmt"
	"time"
    "math/rand"
	"github.com/gruntwork-io/terratest/modules/terraform"
	// "github.com/stretchr/testify/assert"
)

var terraformDirectory = "../examples"
var region             = "us-east-1"
var account            = ""
var load_balancer_name = "TEST_load_balancer_name"
var vpc_id             = "vpc-7e305e05"
var subnets            = []string{"subnet-1bbdb534", "subnet-65467b5a", "subnet-bffd4bb0", "subnet-d9fd2093"}


func randSeq(n int) string {
	letters := []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    b := make([]rune, n)
    for i := range b {
        b[i] = letters[rand.Intn(len(letters))]
    }
    return string(b)
}

func Test_SetUp(t *testing.T) {
	rand.Seed(time.Now().UnixNano())

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDirectory,
		Vars: map[string]interface{}{
			"aws_region": region,
			"vpc_id": vpc_id,
			"subnets": subnets,
			"load_balancer_name": load_balancer_name + "_" + randSeq(10),
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.Init(t, terraformOptions)
	terraform.Apply(t, terraformOptions)
	account = terraform.Output(t, terraformOptions, "account_id")
	fmt.Printf("account ID: " + account)
}
