@description('Name of the parent Foundry resource')
param foundryName string

@description('Model to deploy')
param modelName string

@description('Model version')
param modelVersion string

@description('Deployment type SKU')
@allowed([
  'Standard'
  'GlobalStandard'
  'DataZoneStandard'
])
param deploymentSku string = 'GlobalStandard'

@description('Capacity in thousands of tokens per minute')
param modelCapacity int = 10

// ──────────────────────────────────────────────
// Reference parent Foundry resource
// ──────────────────────────────────────────────
resource foundry 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' existing = {
  name: foundryName
}

// ──────────────────────────────────────────────
// Model deployment
// ──────────────────────────────────────────────
resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2025-04-01-preview' = {
  parent: foundry
  name: modelName
  sku: {
    name: deploymentSku
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

output deploymentName string = deployment.name
