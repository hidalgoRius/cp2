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
  default = "cp2user"
}


variable "resource_group_name" {
  default = "rg-createdbyTF"
}

variable "network_name" {
  default = "vnet1"
}

variable "subnet_name" {
  default = "subnet1"
}


