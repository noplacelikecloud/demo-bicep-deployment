targetScope = 'resourceGroup'

param VMName string
param VNETName string
param subnetName string
param VMSize string
param location string

param localAdminUser string
@secure()
param localAdminPasswd string


resource pubIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'pubIP-${VMName}'
  location: location
  properties:{
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    
  }
  sku:{
    name: 'Basic'
  }
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'nsg-${VMName}'
  location: location

  properties:{
    securityRules:[
      {
        name: 'Allow_RDP'
        properties:{
          access: 'Allow'
          destinationAddressPrefix:'*'
          destinationPortRange:'3389'
          protocol:'*'
          sourceAddressPrefix:'*'
          sourcePortRange: '*'
          direction: 'Inbound'
          priority: 100
        }
      }
    ]
  }
}

resource netif 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: 'netif-${VMName}'
  location:location

  properties:{
    ipConfigurations:[
      {
        name:'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress:{
            id: pubIP.id
          }
          subnet:{
            id: resourceId('Microsoft.Network/virtualNetworks',VNETName,subnetName)
          }
        }
      }
    ]
    networkSecurityGroup:{
      id: NSG.id
    }
  }
}

resource VM 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: VMName
  location: location

  properties:{
    osProfile:{
      adminUsername: localAdminUser
      adminPassword: localAdminPasswd
      computerName: VMName
    }
    hardwareProfile:{
      vmSize:VMSize
    }
    storageProfile:{
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
      }
      osDisk:{
        createOption:'FromImage'
        managedDisk:{
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile:{
      networkInterfaces:[
        {
          id: netif.id
          properties:{
            primary:true
          }
        }
      ]
    }
  }
}
