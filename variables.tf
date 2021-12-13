#*************************************
#           TF Requirements
#*************************************
variable "tenancy_ocid" {
  default = ""
}
variable "region" {
  default = ""
}
variable "user_ocid" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "compartment_name" {
  default = ""
}
variable "non_admin_users" {
  type = list
  default = []
}


#*************************************
#          IAM Specific
#*************************************

variable "dls_group_name" {
  default = "DataLabelingGroup"
}
variable "dls_dynamic_group_name" {
  default = "DataLabelingDynamicGroup"
}
variable "dls_root_policy_name" {
  default = "DataLabelingRootPolicies"
}


#*************************************
#           Data Sources
#*************************************

data "oci_identity_tenancy" "tenant_details" {
  #Required
  tenancy_id = var.tenancy_ocid
}
data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenant_details.home_region_key]
  }
}
data "oci_identity_regions" "current_region" {
  filter {
    name   = "name"
    values = [var.region]
  }
}
data "oci_identity_compartment" "current_compartment" {
  #Required
  id = var.tenancy_ocid
}
