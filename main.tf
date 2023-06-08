/*
##############################################################################
This config will create the following resources in Azure:

    - Hub VNET hosting Catalyst 8000 router
    - Workloads VNET hosting 3 linux VMs in two separate subnets
    - VPN VNET where a Cisco Meraki vMX will reside - single VNET

##############################################################################
*/

// 1. initializaing terraform
terraform {
  
  cloud {
    organization = "cloudy_pibe"
    workspaces {
      name = "" # input your pod worspace name, i.e. for pod 33 it would be "pod_33"
    }
  }

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.56.0"
    }
  }
}

// 2. initializing providers
provider "azurerm" {
  features {}
}

// 3. resource group for azure native resources
resource "azurerm_resource_group" "MainResourceGroup" {
  name     = format("DEVWKS2409ResourceGroup${var.pod_number}")
  location = var.location
  tags = var.tags
}

// 4. VNETs, its Subnets and Peerings
//    4.1. Workloads VNET
resource "azurerm_virtual_network" "WorkloadsVNET" {
    name = format("WorkloadsVNET${var.pod_number}")
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    address_space = ["10.0.0.0/23"]
    location = var.location
    tags = var.tags
}

resource "azurerm_subnet" "WorkloadsSubnet0" {
    name = "Subnet0"
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    virtual_network_name = azurerm_virtual_network.WorkloadsVNET.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "WorkloadsSubnet1" {
    name = "Subnet1"
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    virtual_network_name = azurerm_virtual_network.WorkloadsVNET.name
    address_prefixes = ["10.0.1.0/24"]
}

//  4.2. VPN VNET
resource "azurerm_virtual_network" "VPNVNET" {
    name = format("VPNVNET${var.pod_number}")
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    address_space = ["10.0.2.0/24"]
    location = var.location
    tags = var.tags
}

resource "azurerm_subnet" "VPNSubnet0" {
    name = "Subnet0"
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    virtual_network_name = azurerm_virtual_network.VPNVNET.name
    address_prefixes = ["10.0.2.0/24"]
}

//  4.3. Hub VNET
resource "azurerm_virtual_network" "HubVNET" {
    name = format("HubVNET${var.pod_number}")
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    address_space = ["10.0.4.0/23"]
    location = var.location
    tags = var.tags
}

resource "azurerm_subnet" "HubSubnet0" {
    name = "OutsideSubnet0"
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    virtual_network_name = azurerm_virtual_network.HubVNET.name
    address_prefixes = ["10.0.4.0/24"]
}

resource "azurerm_subnet" "HubSubnet1" {
    name = "InsideSubnet0"
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    virtual_network_name = azurerm_virtual_network.HubVNET.name
    address_prefixes = ["10.0.5.0/24"]
}

//  4.4. VNET peerings
//    4.4.1. Hub <==> VPN
resource "azurerm_virtual_network_peering" "HubToVPNPeering" {
    name = "HubToVPNPeering"
    virtual_network_name = azurerm_virtual_network.HubVNET.name
    remote_virtual_network_id = azurerm_virtual_network.VPNVNET.id
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    use_remote_gateways = false
}

resource "azurerm_virtual_network_peering" "VPNToHubPeering" {
    name = "VPNToHubPeering"
    virtual_network_name = azurerm_virtual_network.VPNVNET.name
    remote_virtual_network_id = azurerm_virtual_network.HubVNET.id
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    use_remote_gateways = false
}

//    4.4.2. Hub <==> Workloads
resource "azurerm_virtual_network_peering" "HubToWorkloadsPeering" {
    name = "HubToWorkloadsPeering"
    virtual_network_name = azurerm_virtual_network.HubVNET.name
    remote_virtual_network_id = azurerm_virtual_network.WorkloadsVNET.id
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    use_remote_gateways = false
}

resource "azurerm_virtual_network_peering" "WorkloadsToHubPeering" {
    name = "WorkloadsToHubPeering"
    virtual_network_name = azurerm_virtual_network.WorkloadsVNET.name
    remote_virtual_network_id = azurerm_virtual_network.HubVNET.id
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    use_remote_gateways = false
}

// 5. VMs
//  5.1. NICs - necessary before creating VMs
//    5.1.1. VM0 NIC
resource "azurerm_network_interface" "VM0NIC0" {
    ip_configuration {
      name = "IPConfiguration0"
      subnet_id = azurerm_subnet.WorkloadsSubnet0.id
      private_ip_address_version = "IPv4"
      private_ip_address_allocation = "Dynamic"
    }
    location = var.location
    name = format("VM0-${var.pod_number}NIC0")
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    enable_accelerated_networking = false
    tags = var.tags
}

//    5.1.2. VM1 NIC
resource "azurerm_network_interface" "VM1NIC0" {
    ip_configuration {
      name = "IPConfiguration0"
      subnet_id = azurerm_subnet.WorkloadsSubnet0.id
      private_ip_address_version = "IPv4"
      private_ip_address_allocation = "Dynamic"
    }
    location = var.location
    name = format("VM1-${var.pod_number}NIC0")
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    enable_accelerated_networking = false
    tags = var.tags
}

//    5.1.3. VM2 NIC
resource "azurerm_network_interface" "VM2NIC0" {
    ip_configuration {
      name = "IPConfiguration0"
      subnet_id = azurerm_subnet.WorkloadsSubnet1.id
      private_ip_address_version = "IPv4"
      private_ip_address_allocation = "Dynamic"
    }
    location = var.location
    name = format("VM2-${var.pod_number}NIC0")
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    enable_accelerated_networking = false
    tags = var.tags
}

//  5.2. Actual VMs
//    5.2.1. VM0
resource "azurerm_linux_virtual_machine" "VM0" {
    admin_username = var.vm_username
    location = var.location
    name = format("VM0-${var.pod_number}")
    network_interface_ids = [azurerm_network_interface.VM0NIC0.id]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    size = var.vm_size
    admin_password = var.vm_password
    disable_password_authentication = false
    provision_vm_agent = true
    source_image_reference {
      publisher = "canonical"
      offer = "0001-com-ubuntu-server-focal"
      sku = "20_04-lts-gen2"
      version = "20.04.202304260"
    }
    tags = var.tags
}

//    5.2.2. VM1
resource "azurerm_linux_virtual_machine" "VM1" {
    admin_username = var.vm_username
    location = var.location
    name = format("VM1-${var.pod_number}")
    network_interface_ids = [azurerm_network_interface.VM1NIC0.id]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    size = var.vm_size
    admin_password = var.vm_password
    disable_password_authentication = false
    provision_vm_agent = true
    source_image_reference {
      publisher = var.vm_image.publisher
      offer = var.vm_image.offer
      sku = var.vm_image.sku
      version = var.vm_image.version
    }
    tags = var.tags
}

//    5.2.3. VM402
resource "azurerm_linux_virtual_machine" "VM2" {
    admin_username = var.vm_username
    location = var.location
    name = format("VM2-${var.pod_number}")
    network_interface_ids = [azurerm_network_interface.VM2NIC0.id]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    resource_group_name = azurerm_resource_group.MainResourceGroup.name
    size = var.vm_size
    admin_password = var.vm_password
    disable_password_authentication = false
    provision_vm_agent = true
    source_image_reference {
      publisher = var.vm_image.publisher
      offer = var.vm_image.offer
      sku = var.vm_image.sku
      version = var.vm_image.version
    }
    tags = var.tags
}

// 6. VMX
//  6.1. accept legal terms from marketplace - only needed to be created once, commenting this block as it was there before terraform automation and wont do state importing as there are other resources not applicable to this demo
# resource "azurerm_marketplace_agreement" "VMXLegalTerms" {
#   publisher = "cisco"
#   offer = "cisco-meraki-vmx"
#   plan = "cisco-meraki-vmx"
# }

// 6.2. vMX Managed Application ARM template deployment
resource "azurerm_template_deployment" "VMX" {
  name = format("VMXARMTemplate${var.pod_number}")
  resource_group_name = azurerm_resource_group.MainResourceGroup.name
  depends_on = [ azurerm_resource_group.MainResourceGroup, azurerm_virtual_network.VPNVNET, azurerm_subnet.VPNSubnet0 ]
  template_body = file("./arm_templates/vmx.json")
  parameters = {
    location = var.location
    vmName = format("VMX${var.pod_number}")
    merakiAuthToken = var.vmx_authentication_token
    zone = "0"
    virtualNetworkName = azurerm_virtual_network.VPNVNET.name
    virtualNetworkNewOrExisting = "existing"
    virtualNetworkAddressPrefix = azurerm_virtual_network.VPNVNET.address_space[0]
    virtualNetworkResourceGroup = azurerm_resource_group.MainResourceGroup.name
    virtualMachineSize = "Standard_F4s_v2"
    subnetName = azurerm_subnet.VPNSubnet0.name
    subnetAddressPrefix = azurerm_subnet.VPNSubnet0.address_prefixes[0]
    applicationResourceName = format("VMXManagedApplication${var.pod_number}")
    managedResourceGroupId = join("/", [var.vmx_managed_resource_group_id_prefix, format("VMXManagedApplication${var.pod_number}ResourceGroup")])
  }
  deployment_mode = "Incremental"
}

