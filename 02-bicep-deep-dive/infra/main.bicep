targetScope = 'resourceGroup'

param baseName string = 'foundry-demo'
param location string = 'swedencentral'
param modelName string = 'gpt-4.1-mini'
param modelVersion string = '2025-04-14'
param deploymentSku string = 'GlobalStandard'
param modelCapacity int = 10
param enablePrivateEndpoint bool = false
param developerPrincipalId string = ''

module foundryModule 'modules/foundry.bicep' = {
  name: 'foundry'
  params: {
    baseName: baseName
    location: location
    enablePrivateEndpoint: enablePrivateEndpoint
  }
}

module modelModule 'modules/model.bicep' = {
  name: 'model'
  params: {
    foundryName: foundryModule.outputs.foundryName
    modelName: modelName
    modelVersion: modelVersion
    deploymentSku: deploymentSku
    modelCapacity: modelCapacity
  }
}

module networkingModule 'modules/networking.bicep' = if (enablePrivateEndpoint) {
  name: 'networking'
  params: {
    baseName: baseName
    location: location
    foundryId: foundryModule.outputs.foundryId
  }
}

module rbacModule 'modules/rbac.bicep' = if (!empty(developerPrincipalId)) {
  name: 'rbac'
  params: {
    projectId: foundryModule.outputs.projectId
    developerPrincipalId: developerPrincipalId
  }
}

output projectEndpoint string = foundryModule.outputs.projectEndpoint
