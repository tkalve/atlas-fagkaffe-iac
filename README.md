# IaC med Terraform ++

## Atlas Fagkaffe 2022-12-16

Dette repoet inneholder presentasjonen og en ganske enkel Terraform-konfigurasjon med en ressursgruppe og en SQL-server for Azure.

## Presentasjon

Presentasjonen ligger i `slides`-mappen. Den er laget med reveal.js og kan enkelt kjøres med Docker:

- `cd slides`
- `docker build -t fagkaffe-iac-slides .`
- `docker run -d --name fagkaffe-iac-slides -p 8080:8080 fagkaffe-iac-slides`

Du kan også kjøre rett fra Visual Studio Code med utvidelsen [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer).

## Terraform

For å kjøre eksempelet i `infra`-mappen lokalt trenger du [Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli) og Azure CLI installert.

Oppdater [infra/main.tf](infra/main.tf) med ønskede ressursnavn, og bytt til local backend øverst i filen.

```console
# Logg inn i Azure
az login
```

```console
# Sett riktig subscription
az account set --subscription <azure subscription id>
```

Så er du klar for å Terraforme!

```console
cd infra

# Fjern Thomas sin lockfil
rm .terraform.lock.hcl

# Sjekk formatering
terraform fmt

# Valider konfigurasjon
terraform validate

# Initialiser modulen og backend
terraform init
```

Før du oppretter ressurser bruker vi `terraform plan` for å se hva Terraform ønsker å gjøre:

```console
$ terraform plan

...
Terraform will perform the following actions:
...
Plan: 2 to add, 0 to change, 0 to destroy.
```

Hvis alt ser greit ut, kan du utføre endringene med å kjøre `terraform apply`.

```console
$ terraform apply
...
Terraform will perform the following actions:
...
Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
```

Du kan også kjøre `terraform apply` direkte uten `plan` først, eller velge å lagre planen til fil før `apply`

---

## Terraform med GitHub Actions

Hvis flere skal samarbeide om samme konfigurasjon, eller Terraform skal kjøres i en pipeline som f.eks. GitHub Actions, må state lagres sentralt. Om alle kjører Terraform lokalt _kan_ den lagres i en fil som sjekkes inn i Git, men det anbefales ikke.

### Azure Storage

Vi bruker Azure Storage for å lagre state.

Opprett en egen ressursgruppe i Azure, feks `prosjekt-infra-rg`, og opprett en Azure Storage Account med en container, feks `tfstate` som i dette eksempelet. Bytt så tilbake til `azurerm` som backend provider i `infra/main.tf`. Du kan lagre state for flere konfigurasjoner/miljøer i samme container, bare sørg for at `key` i backend-konfigurasjonen er ulik.

Bruk gjerne Azure CLI for å opprette:

```console
# Opprett ressursgruppe
az group create -n prosjekt-infra-rg -l norwayeast
 
# Opprett Storage Account
az storage account create -n prosjektinfrastorage -g prosjekt-infra-rg -l norwayeast --sku Standard_LRS
 
# Opprett Storage Account Container
az storage container create -n tfstate 
```

---

### Service Principal

For at GitHub Actions skal kunne autentisere mot Azure, må vi opprette en service principal til dette formålet. Denne kan opprettes med Azure CLI:

```console
$ az ad sp create-for-rbac --name "prosjekt-infra-sp" --role="Contributor" --scopes="/subscriptions/<din subscription id>"

Creating 'Resource Policy Contributor' role assignment under scope '/subscriptions/83b043d3-b1a6-4251-81ff-036e85fd7421'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "7dfb3a85-45b5-46cd-9960-b3d9fb02f16c",
  "displayName": "prosjekt-infra-sp",
  "password": "correct horse battery staple",
  "tenant": "edbed74d-0d65-4ebd-8358-f70c950ee400"
}
```

Verdiene i output må du ta vare på, og lagre som secrets i GitHub repoet ditt:

```env
AZURE_CLIENT_ID = appId
AZURE_CLIENT_SECRET = password
AZURE_TENANT_ID = tenant
AZURE_SUBSCRIPTION_ID = din subscription id
```

Disse brukes av GitHub Actions for å autentisere mot Azure, og hentes inn som secrets i `.github/workflows/terraform.md`.

Denne service principalen må også ha tilgang til storage containeren du opprettet for å lagre state. Gi den rollen `Storage Blob Data Contributor` i Azure-portalen, eller bruk Azure CLI hvis du også er litt vanskelig av deg:

```console
az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee prosjekt-infra-sp \
    --scope "/subscriptions/<subscription>/resourceGroups/<ressursgruppenavn>/providers/Microsoft.Storage/storageAccounts/<storage account name>/blobServices/default/containers/<container>"
```

---

### Terraform.yml

GitHub Actions bruker `.github/workflows/terraform.yml` for å gjøre jobben. Dette eksempelet kjører alle Terraform-kommandoene `fmt`, `init` og `validate` før den oppretter en `plan`. Denne har et ekstra steg for å legge planen til som en kommentar i Pull Requests, og så kjører den `apply` når det merges til `main`.

---

Så er det bare å pushe repoet ditt. Lykke til!
