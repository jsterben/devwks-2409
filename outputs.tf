/*
##############################################################################
Outputs file
##############################################################################
*/

# output "ResourceGroup400" {
#     value = [
#         azurerm_resource_group.ResourceGroup400.name,
#         azurerm_resource_group.ResourceGroup400.id
#     ]
# }

# output "WorkloadsVNET" {
#     value = [
#         azurerm_virtual_network.WorkloadsVNET400.name,
#         azurerm_virtual_network.WorkloadsVNET400.id,
#         azurerm_subnet.WorkloadsSubnet0.name,
#         azurerm_subnet.WorkloadsSubnet0.id,
#         azurerm_subnet.WorkloadsSubnet1.name,
#         azurerm_subnet.WorkloadsSubnet1.id
#     ]
# }

# output "VPNVNET" {
#     value = [
#         azurerm_virtual_network.VPNVNET400.name,
#         azurerm_virtual_network.VPNVNET400.id,
#         azurerm_subnet.VPNSubnet0.name,
#         azurerm_subnet.VPNSubnet0.id
#     ]
# }

# output "HubVNET" {
#     value = [
#         azurerm_virtual_network.HubVNET400.name,
#         azurerm_virtual_network.HubVNET400.id,
#         azurerm_subnet.HubSubnet0.name,
#         azurerm_subnet.HubSubnet0.id,
#         azurerm_subnet.HubSubnet1.name,
#         azurerm_subnet.HubSubnet1.id
#     ]
# }

# output "VNETPeerings" {
#     value = [
#         azurerm_virtual_network_peering.HubToVPNPeering.name,
#         azurerm_virtual_network_peering.HubToVPNPeering.id,
#         azurerm_virtual_network_peering.VPNToHubPeering.name,
#         azurerm_virtual_network_peering.VPNToHubPeering.id,
#         azurerm_virtual_network_peering.HubToWorkloadsPeering.name,
#         azurerm_virtual_network_peering.HubToWorkloadsPeering.id,
#         azurerm_virtual_network_peering.WorkloadsToHubPeering.name,
#         azurerm_virtual_network_peering.WorkloadsToHubPeering.id
#     ]
# }

# output "VMs" {
#     value = [
#         azurerm_network_interface.VM400NIC0.name,
#         azurerm_network_interface.VM400NIC0.id,
#         azurerm_network_interface.VM401NIC0.name,
#         azurerm_network_interface.VM401NIC0.id,
#         azurerm_network_interface.VM402NIC0.name,
#         azurerm_network_interface.VM402NIC0.id,
#         azurerm_linux_virtual_machine.VM400.name,
#         azurerm_linux_virtual_machine.VM400.id,
#         azurerm_linux_virtual_machine.VM401.name,
#         azurerm_linux_virtual_machine.VM401.id,
#         azurerm_linux_virtual_machine.VM402.name,
#         azurerm_linux_virtual_machine.VM402.id
#     ]
# }
