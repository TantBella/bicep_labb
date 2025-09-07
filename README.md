# bicep_labb

Infrastructure as Code med Bicep. Detta projekt deployar en liten men realistisk Azure-miljö med tre miljöer: dev, test och prod via Azure CLI.

## Funktioner

- Skapar Resource Group, Storage Account, App Service Plan och Web App per miljö.
- Skapar Key Vault med en hemlighet.
- Ger Web App systemidentity åtkomst till Key Vault via access policy.
- Autoscale för App Service Plan i prod baserat på CPU.
- Alla resurser parametriserade (ingen hårdkodning).
- Taggar för owner, environment, costCenter.
- Outputs: Web App URL per miljö.

## Deployment

### Förberedelser

1. Installera [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
2. Installera [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
3. Logga in i Azure:

```bash
az login
az account set --subscription "<DIN_SUBSCRIPTION>"
```

Eller:

```bash
az login --use-device-code
```

### Deploy per miljö (med debug)

#### Dev

```bash
  az deployment group create `
  --name dev-deployment `
  --resource-group rg-<dittnamn>-dev `
  --template-file "./src/main.bicep" `
  --parameters "./parameters/dev.json" `
  --output json `
  --debug
```

#### Test

```bash
  az deployment group create `
  --name test-deployment `
  --resource-group rg-<dittnamn>-dev `
  --template-file "./src/main.bicep" `
  --parameters "./parameters/test.json" `
  --output json `
  --debug
```

#### Prod

```bash
  az deployment group create `
  --name prod-deployment `
  --resource-group rg-<dittnamn>-dev `
  --template-file "./src/main.bicep" `
  --parameters "./parameters/prod.json" `
  --output json `
  --debug
```

## Outputs

Efter deployment får du URL\:erna till Web Apps:

- **Dev:** `webAppUrl` från dev-deployment
- **Test:** `webAppUrl` från test-deployment
- **Prod:** `webAppUrl` från prod-deployment

Exempel på kommando för att se outputs:
DEV:

```bash
  az deployment group show `
  --name dev-deployment `
  --resource-group rg-<dittnamn>-dev `
  --query "properties.outputs.webAppUrl.value" `
  -o tsv
```

TEST:

```bash
  az deployment group show `
  --name test-deployment `
  --resource-group rg-<dittnamn>-dev `
  --query "properties.outputs.webAppUrl.value" `
  -o tsv
```

PROD:

```bash
  az deployment group show `
  --name prod-deployment `
  --resource-group rg-<dittnamn>-dev `
  --query "properties.outputs.webAppUrl.value" `
  -o tsv
```
