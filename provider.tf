# Pesimistic ~> opoerator allows only 0.14.x, current max version supported by ORM
# https://www.terraform.io/docs/language/expressions/version-constraints.html

terraform {
 required_version = "~> 0.14.0"
 required_providers {
     # Recommendation from ORM / OCI provider teams
          oci = {
             version =">= 4.21.0"
          }
 }
}

// Default Provider
provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  ###### Uncomment the below if running locally using terraform and not as OCI Resource Manager stack #####
  // user_ocid        = var.user_ocid
  // fingerprint      = var.fingerprint
  // private_key_path = var.private_key_path

}



// Home Provider
provider "oci" {
  alias        = "home"
  region       = lookup(data.oci_identity_regions.home-region.regions[0], "name")
  tenancy_ocid = var.tenancy_ocid
  ###### Uncomment the below if running locally using terraform and as not OCI Resource Manager stack #####
  // user_ocid        = var.user_ocid
  // fingerprint      = var.fingerprint
  // private_key_path = var.private_key_path
}
