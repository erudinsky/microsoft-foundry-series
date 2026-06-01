targetScope = 'resourceGroup'

@description('Base name used for all resources')
param baseName string = 'foundry-demo'

@description('Azure region')
param location string = resourceGroup().location

@description('Model to deploy')
param modelName string = 'gpt-4.1-mini'

@description('Model version')
param modelVersion string = '2025-04-14'

@description('Capacity in thousands of tokens per minute')
param modelCapacity int = 10

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
    publicNetworkAccess: 'Enabled'
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
// Model deployment
// ──────────────────────────────────────────────
resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview' = {
  parent: foundry
  name: modelName
  sku: {
    name: 'Standard'
    capacity: modelCapacity
  }
  properties: {
    model: {
      name: modelName
      format: 'OpenAI'
      version: modelVersion
    }
  }
}

// ──────────────────────────────────────────────
// Outputs
// ──────────────────────────────────────────────
output projectEndpoint string = 'https://${foundry.properties.customSubDomainName}.ai.azure.com/api/projects/${project.name}'
output resourceName string = foundry.name
output deploymentName string = deployment.name
