param name string
param location string
param dnsServer string
param VNETPrefix string
param SubnetName string
param SubnetPrefix string

resource VNET 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: name
  location: location
  properties:{
    addressSpace: {
      addressPrefixes:[
        VNETPrefix
      ]
    }
    dhcpOptions:(!empty(dnsServer)) ? {
      dnsServers: [
        dnsServer
      ]
    }:json('null')
    subnets:[{
      name: SubnetName
      properties: {
        addressPrefix: SubnetPrefix
      }
    }]
  }

}

output id string = VNET.id
output name string = VNET.name
