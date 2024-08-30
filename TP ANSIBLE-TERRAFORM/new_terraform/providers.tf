terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.8.0"
    }
  }
  required_version = ">= 0.13"
}
