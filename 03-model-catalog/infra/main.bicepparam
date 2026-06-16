using 'main.bicep'

param baseName = 'foundry-demo'
param location = 'swedencentral'
param models = [
  {
    name: 'gpt-4.1-mini'
    version: '2025-04-14'
    sku: 'GlobalStandard'
    capacity: 30
  }
  {
    name: 'gpt-5-mini'
    version: '2025-06-02'
    sku: 'GlobalStandard'
    capacity: 10
  }
]
