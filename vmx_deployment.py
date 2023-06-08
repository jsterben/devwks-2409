"""
##############################################################################
This script will pre-provision a vMX in the selected organization and return 
token for final Azure deployment
##############################################################################
"""

# 1. importing necessary modules:
import meraki
import random

# 2. setting variables:
#   2.1. permanent:
API_KEY = '' # input your cisco meraki API key
VMX_NETWORK_NAME = '' # input network name which will host vMX'

ORGANIZATION_ID = '718324140565596195' # input your cisco meraki organization ID
# VMX_LICENSE_KEY = '' license already claimed, use this variable if running it from zero
TAGS = ['devwks_2409', 'azure']
#   2.2. dynamic:
#       random waitime to avoid all pods doing API-calling at the same time
wait_time = random.randrange(1, 10, 1)

# 3. meraki dashboard instantiation - use "output_log=False" to stop
#   automatic logs:
meraki_dashboard_session = meraki.DashboardAPI(
    api_key = API_KEY,
    retry_4xx_error = True,
    retry_4xx_error_wait_time = wait_time,
    maximum_retries = 3
    )

# 4. new organization creation:
#   use this endpoint:
#
#       https://developer.cisco.com/meraki/api-v1/#!create-organization
#
#   for this session an organization has been created for you already

# 5. claim licenses into organization:
# meraki_dashboard_session.organizations.claimIntoOrganization(
#     organizationId = ORGANIZATION_ID,
#     licenses = [{'key': VMX_LICENSE_KEY, 'mode': 'addDevices'}]
#     )

# 6. create vmx network:
new_network = meraki_dashboard_session.organizations.createOrganizationNetwork(
    organizationId = ORGANIZATION_ID,
    name = VMX_NETWORK_NAME,
    timeZone = 'America/Los_Angeles',
    productTypes= ['appliance'],
    tags = TAGS
)

# 7. pre-allocate vMX into network:
vmx_s = meraki_dashboard_session.networks.vmxNetworkDevicesClaim(
    networkId = new_network['id'],
    size = 'small'
    )

# 8. get vMX token for azure deployment:
vmx_s_token = meraki_dashboard_session.appliance.createDeviceApplianceVmxAuthenticationToken(
    serial = vmx_s['serial']
)

# 9. printing results:
print('\n', 'Your vMX token is --> {token}'.format(token = vmx_s_token['token']))
