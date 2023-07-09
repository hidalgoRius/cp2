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
 default = "${var.prefix}-acr"
}

variable "resource_group_name" {
  default = "${var.prefix}-resource-group"
}

variable "subnet_name" {
  default = "subnet1"
}


