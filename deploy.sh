#!/bin/bash

function terraform_process() {
	# Terraform commands
	tf_commands=("init" "plan -out=myplan -var env=$1" "apply myplan")

	cd terraform
	echo "$0 >>>>> $(date): Entering to terraform folder. Now $(pwd)"
	#Executing terraform commands
	for ((i = 0; i < ${#tf_commands[@]}; i++))
        do
                command="terraform ${tf_commands[$i]}"
                echo "$0 >>>>> $(date): Executing command \"$command\""
                eval "$command"
        done

	terraform_refresh $1
	terraform_outputs
	cd ..
        echo "$0 >>>>> $(date): Exit terraform folder. Now $(pwd)"
}

function terraform_refresh() {
	terraform refresh -var env=$1
}

function terraform_outputs(){
	#Se usa el argumento -raw para evitar las dobles comillas https://www.terraform.io/docs/cli/commands/output.html
	echo "$0 >>>>> $(date): Getting VM public IP..."
        vm_pip="$(terraform output -raw vm_public_ip)"
        echo "$0 >>>>> $(date): Getting VM ssh login user..."
        vm_ssh_user=$(terraform output -raw ssh_user)
        echo "$0 >>>>> $(date): Getting ACR url..."
        acr_url=$(terraform output -raw acr_login_server)
        echo "$0 >>>>> $(date): Getting VM ACR user..."
        acr_user=$(terraform output -raw acr_admin_user)
        echo "$0 >>>>> $(date): Getting VM ACR password..."
        acr_passwd=$(terraform output -raw acr_admin_pass)
	echo "$0 >>>>> $(date): Getting K8S name..."
        k8s_name=$(terraform output -raw kubernetes_cluster_name)
	echo "$0 >>>>> $(date): Getting Resource group name..."
        rg_name=$(terraform output -raw resource_group_name)
}

function ansible_process() {
	cd ansible
	echo "$0 >>>>> $(date): Entering to ansible folder. Now $(pwd)"
	echo "$0 >>>>> $(date): Get all Playbook files *.yaml"
	
	#Aqui creamos el fichero de inventario. Como solo hay una VM, se pasa de manera aislada.
	echo "$0 >>>>> $(date): Creating inventory file from Terraform output"
        echo "[ContainerVM]" > inventory
        echo $vm_pip >> inventory

	#Aqui creamos un fichero devariables comun para todos los playbooks, con el usuario SSH, datos de ACR, etc.
	cd vars
	echo "$0 >>>>> $(date): Entering to ansible/vars folder. Now $(pwd)"
	echo "$0 >>>>> $(date): Creating global var file from Terraform output (vars/global_vars.yaml)"
        echo "podman_ssh_login: '$vm_ssh_user'" > tf_vars.yaml
	echo "az_acr_user: '$acr_user'" >> tf_vars.yaml
	echo "az_acr_passwd: '$acr_passwd'" >> tf_vars.yaml #TODO: Podriamos poner esta password en ansible-vault
	echo "az_acr_url: '$acr_url'" >> tf_vars.yaml
	echo "k8s_name: '$k8s_name'" >> tf_vars.yaml
	echo "rg_name: '$rg_name'" >> tf_vars.yaml


	cd ..
	echo "$0 >>>>> $(date): Exit ansible/vars folder. Now $(pwd)"

	#Executing ansible-playbook commands
	for playbook in ./*.yaml
        do
                command="ansible-playbook -i inventory ${playbook##*/}"
		echo "$0 >>>>> $(date): Executing command \"$command\""
		eval "$command"
        done
	cd ..
        echo "$0 >>>>> $(date): Exit ansible folder. Now $(pwd)"

	cd ..
        echo "$0 >>>>> $(date): Exit ansible folder. Now $(pwd)"

}

function pluralith_generate_infrastructure_diagram() {
	cd terraform
	pluralith graph --out-dir=../diagrams --var env=$1 --show-costs --local-only
	cd ../diagrams
	mv Pluralith_Diagram.pdf Infrastructure_diagram.pdf


}

#BEGIN MAIN CODE 

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
k8s_name=""
rg_name=""


if [ -z "$2" ]
then
	 #EXECUTING TERRAFORM PROCESS
	echo "$0 >>>>> $(date): [START] TERRAFORM deploy infrastructure"
        terraform_process $1
	echo "$0 >>>>> $(date): [END] TERRAFORM deploy infrastructure"

        if [ -z "$vm_pip" ]
	then
                echo "$0 >>>>> $(date): [ERROR] Terraform did not provide a public IP for the virtual machine. Exiting"
	     	exit 1
        fi

	#EXECUTING ANSIBLE PROCESS
	echo "$0 >>>>> $(date): [START] ANSIBLE configure infrastructure"
        ansible_process
        echo "$0 >>>>> $(date): [END] ANSIBLE configure infrastructure"

elif [ "$2" == "--terraform-refresh" ]
then
	echo "$0 >>>>> $(date): [INFO] User requests perform only terraform refresh. $2"
        cd terraform
        terraform_refresh $1
        terraform_outputs
        cd ..

	#EXECUTING ANSIBLE PROCESS
        echo "$0 >>>>> $(date): [START] ANSIBLE configure infrastructure"
        ansible_process "$vm_pip" $vm_ssh_user $acr_user $acr_passwd $acr_url
        echo "$0 >>>>> $(date): [END] ANSIBLE configure infrastructure"
elif [ "$2" == "--disable-ansible" ]
then
	echo "$0 >>>>> $(date): [INFO] Ansible execution is DISABLED by user. Skipping step. $3"
else
	echo "$0 >>>>> $(date): [INFO] Invalid option. Allowed --terraform-refresh or --disable-ansible."
fi

echo "$0 >>>>> $(date): [INFO] Execution script end."

exit 1
