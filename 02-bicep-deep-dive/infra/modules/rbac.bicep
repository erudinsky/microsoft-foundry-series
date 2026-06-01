@description('Resource ID of the Foundry project')
param projectId string

@description('Principal ID of the developer who needs access')
param developerPrincipalId string

// Foundry User role
var foundryUserRoleId = '53ca6127-db72-4b80-b1b0-d745d6d5456d'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(projectId, developerPrincipalId, foundryUserRoleId)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      foundryUserRoleId
    )
    principalId: developerPrincipalId
    principalType: 'User'
  }
}
