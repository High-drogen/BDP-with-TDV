terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.17"
    }
  }
  required_version = ">= 0.12.26"
}

provider "openstack" {
  cloud = "openstack"
}