#!/bin/bash

function terraform_process() {
	# Terraform commands
	tf_init="terraform init"
	tf_plan="terraform plan -out=myplan -var env=$1"
	tf_output_vm_public_ip="terraform output vm_public_ip"

	cd terraform
	echo "$0 >>>>> $(date): Entering to terraform folder. Now $(pwd)"
	echo "$0 >>>>> $(date): Executing command $tf_init"
	eval "$tf_init"
	echo "$0 >>>>> $(date): Executing command $tf_plan"
	eval "$tf_plan"
	echo "$0 >>>>> $(date): Getting VM public IP..."
	vm_pip="$(terraform output vm_public_ip)"
	cd ..
        echo "$0 >>>>> $(date): Exit terraform folder. Now $(pwd)"



}

function ansible_process() {
	cd ansible
        echo "$0 >>>>> $(date): Entering to ansible folder. Now $(pwd)"
	echo "$0 >>>>> $(date): Creating inventory file from Terraform output"
	echo "[podman-servers]" > inventory
	echo $1 | sed 's/^.//;s/.$//' >> inventory


}


echo "$0 >>>>> $(date): CASO PRACTICO 2 AUTOMATED DEPLOYMENT SCRIPT"

if [ -z "$1" ] || [[ ! $1 =~ ^(dev|prod)$ ]];
then
	echo "$0 >>>>> $(date): [ERROR] Environment is required. Allowed 'dev','prod'"
  	exit 1
fi

echo "$0 >>>>> $(date): Selected env: $1"

vm_pip=""

#EXECUTING TERRAFORM PROCESS
echo "$0 >>>>> $(date): [START] TERRAFORM deploy infrastructure"
terraform_process $1
echo echo "$0 >>>>> $(date): [END] TERRAFORM deploy infrastructure"

if [ -z "$vm_pip" ]
then
	echo "$0 >>>>> $(date): [ERROR] Terraform did not provide a public IP for the virtual machine. Exiting"
	exit 1
fi

echo "$0 >>>>> $(date): [START] ANSIBLE INFRASTRUCTURE CONFIGURATION"
ansible_process "$vm_pip"
echo "$0 >>>>> $(date): [END] ANSIBLE INFRASTRUCTURE CONFIGURATION"

exit 1
