# Part 3 — Foundry Model Catalog

Code samples for [Foundry Model Catalog — Comparing GPT-4.1, GPT-5 & Open-Weight Models](https://erudinsky.com/2026/06/15/foundry-model-catalog-comparing-gpt-4-1-gpt-5-open-weight-models/) on [erudinsky.com](https://erudinsky.com).

## What's covered

- Deploying **multiple models** from the Foundry Model Catalog using a single Bicep template with a `@batchSize(1)` resource loop
- Smart **model routing** — automatically classify task complexity and pick the cheapest model that can handle it (gpt-4.1-nano → gpt-4.1-mini → gpt-5-mini)

## Deploy infrastructure

```bash
az group create --name rg-foundry-demo --location swedencentral

az deployment group create \
  --resource-group rg-foundry-demo \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam
```

## Run the Python app

```bash
cd app
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Copy .env.example to .env and update PROJECT_ENDPOINT
cp .env.example .env

python model_router.py
```
