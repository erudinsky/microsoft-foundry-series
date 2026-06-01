@description('Base name used for all resources')
param baseName string

@description('Azure region')
param location string

@description('Enable private networking')
param enablePrivateEndpoint bool = false

// ──────────────────────────────────────────────
// Foundry resource (Cognitive Services account)
// ──────────────────────────────────────────────
resource foundry 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: '${baseName}-ai'
  location: location
  kind: 'AIServices'
  sku: {
    name: 'S0'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customSubDomainName: '${baseName}-ai'
    allowProjectManagement: true
    publicNetworkAccess: enablePrivateEndpoint ? 'Disabled' : 'Enabled'
  }
}

// ──────────────────────────────────────────────
// Project
// ──────────────────────────────────────────────
resource project 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  parent: foundry
  name: '${baseName}-project'
  location: location
  properties: {}
}

// ──────────────────────────────────────────────
// Outputs
// ──────────────────────────────────────────────
output foundryName string = foundry.name
output foundryId string = foundry.id
output projectId string = project.id
output projectEndpoint string = 'https://${foundry.properties.customSubDomainName}.ai.azure.com/api/projects/${project.name}'
