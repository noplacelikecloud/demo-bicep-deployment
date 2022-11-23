targetScope = 'resourceGroup'

param VMName string
param VNetName string
param location string
param subnetName string
param VMSize string
param localAdminUser string
@secure()
param localAdminPasswd string

module VM 'modules/mod_VM.bicep' = {
  name: 'deploy-demo-vm'
  params: {
    VMName: VMName
    VNETName: VNetName
    location: location
    subnetName: subnetName
    VMSize: VMSize
    localAdminUser: localAdminUser
    localAdminPasswd: localAdminPasswd
  }
}
