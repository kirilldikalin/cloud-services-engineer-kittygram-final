variable "cloud_id"        { type = string }
variable "folder_id"       { type = string }

variable "sa_key_file" {
  type    = string
  default = "authorized_key.json"
}

variable "network_name" {
  type    = string
  default = "kitty-vpc"
}
variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/24"
}
variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vm_name" {
  type    = string
  default = "kitty-vm"
}
variable "vm_ssh_user" {
  type    = string
  default = "student"
}
variable "vm_ssh_pubkey" { type = string }
variable "vm_platform" {
  type    = string
  default = "standard-v3"
}
variable "vm_cores" {
  type    = number
  default = 2
}
variable "vm_mem_gb" {
  type    = number
  default = 4
}
variable "vm_disk_gb" {
  type    = number
  default = 20
}
