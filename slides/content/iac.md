# Infrastructure as Code (IaC)

---

## Hva er Infrastructure as Code (IaC)?

* Håndtering av og provisjonering av infrastruktur gjennom kode i stedet for manuelle prosesser
* Infrastrukturen er beskrevet i konfigurasjonsfiler
* Versjonert og revidert, for å unngå udokumenterte og uønskede endringer

---

## Hvorfor kan vi ikke bare gjøre det manuelt?

---

## Bakdeler med manuell provisjonering

* Mange klikk for å opprette nye ressurser eller gjøre endringer, mange mulige feilkilder
* Vanskelig å få oversikt over alle komponentene man har (og hvordan de henger sammen)
* Nesten umulig å «kopiere» et miljø
* Dårlig sporbarhet - hvem gjorde hva når?

---

## Fordeler med IaC

* Infrastrukturen er automatisk dokumentert i kode
* Miljøene settes opp likt hver gang! F.eks dev, test, prod
* Færre menneskelige feilkilder (som ikke oppdages i code review)
* Disaster recovery ... 😱

---

## Bakdeler?

* Det krever litt å komme i gang med
* Tar lenger tid å sette opp enn å bare opprette i portalen
* Helt nytt fagfelt å rive seg i håret av

---

## Men!<!-- .element: class="fragment" -->

## IaC er best uansett altså<!-- .element: class="fragment" -->

---

## To typer IaC

* Imperativ: En liste over steg som må gjøres for å sette opp det man ønsker<!-- .element: class="fragment" -->
* Deklarativ: En beskrivelse av det man ønsker å oppnå<!-- .element: class="fragment" -->

---

## Imperativ IaC

* Bygget opp slik et menneske tenker for å sette opp<!-- .element: class="fragment" -->
* Infra og konfigurasjon settes opp steg for steg<!-- .element: class="fragment" -->
* Eks. Azure CLI, bash scripts, etc.<!-- .element: class="fragment" -->

---

### Eksempel med Azure CLI

```console
# opprett ressursgruppe
az group create -l norwaywest –n atlas-rg

# opprett SQL server
az sql server create -l norwaywest –g atlas-rg –n atlas-sql ...

# opprett SQL database
az sql db create -g atlas-app-rg –s atlas-sql –n vinlotteridb ...
```

---

## Deklarativ IaC

* Beskriver sluttresultatet man ønsker i stedet for stegene som må til for å komme dit<!-- .element: class="fragment" -->
* Inneholder (ofte) en liste over alle ressurser og deres nåværende status<!-- .element: class="fragment" -->
* Kan føre et oppsett tilbake til sin riktige form hvis noen gjør manuelle endringer<!-- .element: class="fragment" -->
* Eks: Terraform, Bicep, Puppet<!-- .element: class="fragment" -->

---

### Eksempel med Bicep

```bicep
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: 'atlas-sql'
  location: 'norwaywest'
  properties: {
    administratorLogin: 'nimda'
    administratorLoginPassword: 'hunter2'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: 'vinlotteridb'
  location: 'norwaywest'
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}
```

---

### Eksempel med Terraform

```terraform
resource "azurerm_resource_group" "this" {
  name     = "atlas-rg"
  location = "norwaywest"
}

resource "azurerm_mssql_server" "this" {
  name                 = "atlas-sql"
  resource_group_name  = azurerm_resource_group.this.name
  administrator_login  = "nimda"
  ...
}

resource "azurerm_sql_database" "this" {
   name                = "vinlotteridb"
   server_name         = azurerm_sql_server.this.name
   ...
}
```

### Spørsmål?
