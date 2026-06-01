# Microsoft Foundry — Practical Series

Code samples for the [Microsoft Foundry blog series](https://erudinsky.com/tags/microsoft-foundry/) on [erudinsky.com](https://erudinsky.com).

## Series

| # | Topic | Blog post |
|---|-------|-----------|
| 1 | Getting started — Provision with Bicep, deploy GPT, generate descriptions | [Read](https://erudinsky.com/2026/05/21/getting-started-with-microsoft-foundry-product-descriptions-with-gpt/) |
| 2 | Bicep deep dive — networking, RBAC, deployment types, region selection | [Read](https://erudinsky.com/2026/06/01/microsoft-foundry-bicep-deep-dive-networking-rbac-deployment-types/) |
| 3 | Foundry model catalog — comparing models and when to use what | Coming soon |
| 4 | Foundry services overview — agents, Responses API, tools, memory | Coming soon |
| 5 | Prompt engineering and structured JSON output | Coming soon |
| 6 | Building the Python API — FastAPI backend with Foundry SDK | Coming soon |
| 7 | Adding a database — PostgreSQL and RAG via Azure AI Search | Coming soon |
| 8 | Content safety, guardrails and Responsible AI | Coming soon |
| 9 | Building the Vue.js frontend — full-stack product description generator | Coming soon |
| 10 | CI/CD with GitLab, cost optimization and monitoring | Coming soon |

## Repository structure

```
foundry-series/
├── 01-getting-started/
│   ├── infra/
│   │   └── main.bicep              # Foundry resource + project + model deployment
│   └── app/
│       ├── main.py                 # Product description generator
│       ├── requirements.txt
│       └── .env.example
├── 02-bicep-deep-dive/
│   └── infra/
│       ├── main.bicep              # Orchestrator with modules
│       ├── main.bicepparam         # Parameter file
│       └── modules/
│           ├── foundry.bicep       # Foundry resource + project
│           ├── model.bicep         # Model deployment (configurable SKU)
│           ├── networking.bicep    # VNet + Private Endpoint + DNS
│           └── rbac.bicep          # Role assignments
```

## Prerequisites

- An Azure subscription — [free trial](https://azure.microsoft.com/pricing/purchase-options/azure-account?wt.mc_id=MVP_387222)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?wt.mc_id=MVP_387222) (v2.67+)
- Python 3.10+

## Quick start

```bash
# Sign in to Azure
az login

# Deploy Part 1 infrastructure
az group create --name rg-foundry-demo --location eastus
az deployment group create \
  --resource-group rg-foundry-demo \
  --template-file 01-getting-started/infra/main.bicep

# Run the Python app
cd 01-getting-started/app
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python main.py
```

## License

MIT
