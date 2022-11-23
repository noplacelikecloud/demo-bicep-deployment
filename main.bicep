targetScope = 'subscription'

param nameRgNetwork string
param nameRgComputing string
param location string
param VNETName string
param VNETPrefix string
param SNETName string
param SNETPrefix string
param VMName string
param VMSize string
param localAdminUser string
@secure()
param localAdminPasswd string

resource RG_Network 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: nameRgNetwork
  location: location
}

resource RG_Compute 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: nameRgComputing
  location: location
}

module VNET 'modules/mod_VNET.bicep' = {
  scope: RG_Network
  name: 'deploy-demo-vnet'
  params: {
    name: VNETName
    dnsServer: ''
    location: location
    VNETPrefix: VNETPrefix
    SubnetName: SNETName
    SubnetPrefix: SNETPrefix
  }
}

module VM 'modules/mod_VM.bicep' = {
  scope: RG_Compute
  name: 'deploy-demo-vm'
  params: {
    VMName: VMName
    VNETName: VNETName
    location: location
    subnetName: SNETName
    VMSize: VMSize
    networkRG: RG_Network.name
    localAdminUser: localAdminUser
    localAdminPasswd: localAdminPasswd
  }
}
