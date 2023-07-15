#!/bin/bash

function terraform_process() {
	# Terraform commands
	tf_commands=("init" "plan -out=myplan -var env=$1" "apply myplan" "refresh -var env=$1")

	cd terraform
	echo "$0 >>>>> $(date): Entering to terraform folder. Now $(pwd)"
	#Executing terraform commands
	for ((i = 0; i < ${#tf_commands[@]}; i++))
        do
                command="terraform ${tf_commands[$i]}"
                echo "$0 >>>>> $(date): Executing command \"$command\""
                eval "$command"
        done

	echo "$0 >>>>> $(date): Getting VM public IP..."
	vm_pip="$(terraform output vm_public_ip)"
	echo "$0 >>>>> $(date): Getting VM ssh login user..."
	vm_ssh_user=$(terraform output ssh_user)
	echo "$0 >>>>> $(date): Getting ACR url..."
        acr_url=$(terraform output acr_login_server)
	echo "$0 >>>>> $(date): Getting VM ACR user..."
        acr_user=$(terraform output acr_admin_user)
	echo "$0 >>>>> $(date): Getting VM ACR password..."
        acr_passwd=$(terraform output acr_admin_pass)



	cd ..
        echo "$0 >>>>> $(date): Exit terraform folder. Now $(pwd)"
}

function ansible_process() {
	ansible_playbook1="ansible-playbook -i inventory pb_podman_prereq.yaml --extra-vars \"podman_ssh_login=$2\""
	ansible_playbook2="ansible-playbook -i inventory pb_podman_app_setup.yaml --extra-vars \"podman_ssh_login=$2 az_acr_user=$3 az_acr_passwd=$4 az_acr_url=$5\""

	echo $ansible_playbook2
	exit 1

	cd ansible
        echo "$0 >>>>> $(date): Entering to ansible folder. Now $(pwd)"
	echo "$0 >>>>> $(date): Creating inventory file from Terraform output"
	echo "[ContainerVM]" > inventory
	echo $1 | sed 's/^.//;s/.$//' >> inventory
	echo "$0 >>>>> $(date): Executing command $ansible_playbook"
	eval "$ansible_playbook1"



}


echo "$0 >>>>> $(date): CASO PRACTICO 2 AUTOMATED DEPLOYMENT SCRIPT"

if [ -z "$1" ] || [[ ! $1 =~ ^(dev|prod)$ ]];
then
	echo "$0 >>>>> $(date): [ERROR] Environment is required. Allowed 'dev','prod'"
  	exit 1
fi

echo "$0 >>>>> $(date): Selected env: $1"

vm_pip=""
vm_ssh_user=""
acr_url=""
acr_user=""
acr_passwd=""

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
ansible_process "$vm_pip" $vm_ssh_user $acr_user $acr_passwd $acr_url
echo "$0 >>>>> $(date): [END] ANSIBLE INFRASTRUCTURE CONFIGURATION"

exit 1
