# DEFINE ENVIRONMENT.
# ES UNA APROXIMACION PARA DEFINIR ENTORNOS DISTINTOS. Solo se aplicará como SUFIJO al resource group.
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
 description = "A prefix for all resources"
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

# AQUI PODRIAMOS HACER UNAC ONDICION: IF env.DEV -> una VM basica, ELSE env.PROD -> UNA MAS POTENTE.
variable "vm_size" {
 default = "Standard_F2"
}

