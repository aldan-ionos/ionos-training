terraform {
  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "6.0.0-beta.11"
    }

    kind = {
      source = "kyma-incubator/kind"
    }
  }
}

provider "kind" {}
provider "ionoscloud" {}

