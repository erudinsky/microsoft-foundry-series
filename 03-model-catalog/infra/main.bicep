targetScope = 'resourceGroup'

@description('Base name used for all resources')
param baseName string = 'foundry-demo'

@description('Azure region')
param location string = 'swedencentral'

@description('Enable private networking')
param enablePrivateEndpoint bool = false

@description('Principal ID of the developer who needs access')
param developerPrincipalId string = ''

@description('Models to deploy')
param models array = [
  {
    name: 'gpt-4.1-mini'
    version: '2025-04-14'
    sku: 'GlobalStandard'
    capacity: 30
  }
  {
    name: 'gpt-4.1'
    version: '2025-04-14'
    sku: 'GlobalStandard'
    capacity: 10
  }
  {
    name: 'gpt-5-mini'
    version: '2025-06-02'
    sku: 'GlobalStandard'
    capacity: 10
  }
]

// ──────────────────────────────────────────────
// Foundry resource + project
// ──────────────────────────────────────────────
module foundryModule 'modules/foundry.bicep' = {
  name: 'foundry'
  params: {
    baseName: baseName
    location: location
    enablePrivateEndpoint: enablePrivateEndpoint
  }
}

// ──────────────────────────────────────────────
// Model deployments (sequential to avoid conflicts)
// ──────────────────────────────────────────────
@batchSize(1)
resource modelDeployments 'Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview' = [
  for model in models: {
    name: '${foundryModule.outputs.foundryName}/${model.name}'
    sku: {
      name: model.sku
      capacity: model.capacity
    }
    properties: {
      model: {
        name: model.name
        format: 'OpenAI'
        version: model.version
      }
    }
  }
]

// ──────────────────────────────────────────────
// Networking (optional)
// ──────────────────────────────────────────────
module networkingModule 'modules/networking.bicep' = if (enablePrivateEndpoint) {
  name: 'networking'
  params: {
    baseName: baseName
    location: location
    foundryId: foundryModule.outputs.foundryId
  }
}

// ──────────────────────────────────────────────
// RBAC (optional)
// ──────────────────────────────────────────────
module rbacModule 'modules/rbac.bicep' = if (!empty(developerPrincipalId)) {
  name: 'rbac'
  params: {
    projectId: foundryModule.outputs.projectId
    developerPrincipalId: developerPrincipalId
  }
}

// ──────────────────────────────────────────────
// Outputs
// ──────────────────────────────────────────────
output projectEndpoint string = foundryModule.outputs.projectEndpoint
output deploymentNames array = [for (model, i) in models: modelDeployments[i].name]
