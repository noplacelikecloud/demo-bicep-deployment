param name string
param location string
param dnsServer string

resource VNET 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: name
  location: location
  properties:{
    addressSpace: {
      addressPrefixes:[
        '192.168.10.0/16'
      ]
    }
    dhcpOptions:(!empty(dnsServer)) ? {
      dnsServers: [
        dnsServer
      ]
    }:json('null')
    subnets:[{
      name: 'servers'
      properties: {
        addressPrefix: '192.168.10.0/24'
      }
    }]
  }

}

output id string = VNET.id
output name string = VNET.name
