targetScope = 'subscription'

param nameRgNetwork string
param nameRgComputing string
param location string

resource RG_Network 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: nameRgNetwork
  location: location
}

resource RG_Compute 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: nameRgComputing
  location: location
}
