/*
##############################################################################
Variables file
##############################################################################
*/

// Pod number
variable "pod_number" {
    description = "Pod number for DEVWKS-2409 session"
    type = string
    default = "" # input your pod number here, i.e. "33" for pod 33
}

// vMX
variable "vmx_authentication_token" {
    description = "vMX authentication token"
    type = string
    default = "" # input your vmx token gathered from python script
}

variable "vmx_managed_resource_group_id_prefix" {
    description = "String prefix for Resource Group where vMX managed application will be deployed"
    type = string
    // replace <SUBSCRIPTION_ID> below with your own, i.e. if your subscription ID is 123456 then the string would look like "/subscriptions/123456/resourceGroups"
    default = "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups"
}

// VMs
variable "vm_username" {
    description = "Username for VMs"
    type = string
    sensitive = true
}

variable "vm_password" {
    description = "User password for VMs"
    type = string
    sensitive = true
}

variable "vm_size" {
    description = "Size of the VMs"
    type = string
    default = "Standard_DS1_v2"
}

variable "vm_image" {
    description = "Image specifications"
    type = map(string)
    default = {
      "publisher" = "canonical"
      "offer" = "0001-com-ubuntu-server-focal"
      "sku" = "20_04-lts-gen2"
      "version" = "20.04.202304260"
    }
}

// miscellaneous
variable "tags" {
    description = "Tags for resources"
    type = map(string)
    default = {
        Creator = "jsterben"
        Management = "Terraform"
        Purpose = "CiscoLive"
        Session = "DEVWKS2409"
    }
}

variable "location" {
    description = "Location of the network"
    type = string
    default     = "centralus"
}