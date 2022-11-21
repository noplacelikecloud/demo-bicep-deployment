targetScope = 'resourceGroup'

param VNETName string
param location string

module VNET 'modules/mod_VNET.bicep' = {
  name: 'deploy-demo-vnet'
  params: {
    name: VNETName
    dnsServer: ''
    location: location
  }
}
