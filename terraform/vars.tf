# DEFINE ENVIRONMENT.
# ES UNA APROXIMACION PARA DEFINIR ENTORNOS DISTINTOS. Se aplica como PREFIJO al resource group.
# SE TRATA DE UN EJEMPLO PAR FINES ACADEMICOS. En entornos reales, la aproximación puede ser otra en función de las necesidades de la empresa.
variable "env" {
 type = string
 description = "Environment deployment option. Must be specified, dev or prod"
 nullable = false
 validation {
    condition = contains(["dev", "prod"], var.env)
    error_message = "Valid value is one of the following: dev, prod."
  }
}

variable "prefix" {
 type = string
 description = "A prefix for some resources"
 default = "CP2"
}

variable "acr_sku" {
  type        = string
  description = "Tipo de SKU a utilizar por el registry. Opciones válidas: Basic, Standard, Premium."
  default     = "Basic"
}

variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "uksouth" 
}

variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/id_rsa.pub" # o la ruta correspondiente
}

variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  default = "vmuser"
}

variable "acr_name" {
 type = string
 description = "Azure Container Registry Name"
 default = "acr"
}

variable "resource_group_name" {
  default = "resource-group"
}

variable "subnet_name" {
  default = "subnet1"
}


# VIRTUAL MACHINE IMAGE AND PLAN DEFINITION
variable "vm_publisher" {
 default = "cognosys"
}

variable "vm_offer" {
  default = "centos-8-stream-free"
}

variable "vm_sku" {
  default = "centos-8-stream-free"
}

variable "vm_version" {
  default = "22.03.28"
}

variable "vm_plan" {
 default = "hourly"
}

# AQUI PODRIAMOS HACER UNAC ONDICION: IF env.DEV -> una VM basica, ELSE env.PROD -> UNA MAS POTENTE.
variable "vm_size" {
 default = "Standard_DS1_v2"
}

variable "vm_name" {
  default = "containerVM"
}

#INIT K8S AKS Variable definition
variable "k8s_node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool in PROD env."
  default     = 3 #En el fichero k8s.tf se especifica que para el entorno DEV hay 1 nodo
}

variable "k8s_vm_size" {
  type = string
  default = "Standard_D2_v2" #En el fichero k8s.tf se especifica la version de la VM para el Entorno DEV.
  description = "VM type"
}
# END K8S AK Variable definition 


