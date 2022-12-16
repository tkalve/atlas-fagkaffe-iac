# Terraform

* Deklarativt IaC-verktøy
* Open source og gratis
* Skyuavhengig
* Haugevis av providers

---

## Et lite utvalg

* Azure (RM)
* Amazon Web Services (AWS)
* Google Cloud Platform
* Azure Active Directory
* Kubernetes
* VMware vSphere
* ++++

---

## I korte trekk

* Infrastruktur definert i kode
* Lagret i kildekode
* Idempotent og konsistent
* Egen syntaks: HCL

---

## Oppsett

---

## Sett opp en lokal backend

```terraform
# Lagre state lokalt til fil
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```
<!-- .element: class="fragment" -->

---

## Eller lagre den sentralt

```terraform
# Lagre state i Azure storage
terraform {
  backend "azurerm" {
    resource_group_name  = "atlas-infra-rg"
    storage_account_name = "atlasinfrastorage"
    container_name       = "tfstate"
    key                  = "fagkaffe.terraform.tfstate"
  }
}
```
<!-- .element: class="fragment" -->

---

## Konfigurer en provider

```terraform
provider "azurerm" {
  features {}
}
```

---

## Legg til noen ressurser

```terraform
resource "azurerm_redis_cache" "example" {
  name                = "atlas-fagkaffe-redis"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
}
```

---

## Så kan me bare kjøra på

```console
# Initialiser
terraform init
```

```console
# Lag en plan
terraform plan
```

```console
# Make it so
terraform apply
```

---

## Spørsmål?

---

Men skulle vi ikke gjøre dette med GitHub Actions?

---

![Make it so](content/images/picard.jpg)
