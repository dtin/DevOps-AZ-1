# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources"
  default = "udacity"
}

variable "location" {
  description = "The Azure Region in which all resources should be created."
  default = "southcentralus"
}

variable "admin_username" {
  description = "The admin username for the VM being created."
  default = "tindd3"
}

variable "admin_password" {
  description = "The password for the VM being created."
  default = "Password!123"
}

variable "number_of_virtual_machines" {
  description = "The number of virtual machines should be created."
  type = number  
  default = 3
}