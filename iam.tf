#*************************************
#           Groups
#*************************************

resource "oci_identity_group" "dls-group" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  description    = "Data Labeling Group"
  name           = var.dls_group_name
}


#*************************************
#       User Membership in Group
#*************************************


resource "oci_identity_user_group_membership" "dls_user_group_membership" {

  # One membership for each element of var.non_admin_users
  for_each = toset(var.non_admin_users)

  # each.value here is a value from var.non_admin_users
  user_id = each.key
  group_id = oci_identity_group.dls-group.id
}


#*************************************
#          Dynamic Groups
#*************************************


resource "oci_identity_dynamic_group" "dls-dynamic-group" {
  compartment_id = var.tenancy_ocid
  description    = "Data Labeling Service dynamic group"
  matching_rule  = "ALL { resource.type = 'datalabelingdataset' }"
  name           = var.dls_dynamic_group_name
}


#*************************************
#           Policies
#*************************************

locals {
  dls_root_policies = [
    "Allow group ${oci_identity_group.dls-group.name} to read buckets in compartment ${var.compartment_name}",
    "Allow group ${oci_identity_group.dls-group.name} to manage objects in compartment ${var.compartment_name}",
    "Allow group ${oci_identity_group.dls-group.name} to read objectstorage-namespaces in compartment ${var.compartment_name}",
    "Allow group ${oci_identity_group.dls-group.name} to manage data-labeling-family in compartment ${var.compartment_name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dls-dynamic-group.name} to read buckets in compartment ${var.compartment_name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dls-dynamic-group.name} to read objects in compartment ${var.compartment_name}",
    "Allow dynamic-group ${oci_identity_dynamic_group.dls-dynamic-group.name} to manage objects in compartment ${var.compartment_name} where any {request.permission='OBJECT_CREATE'}"
  ]
}


resource "oci_identity_policy" "dls-service-policies" {
  compartment_id = var.tenancy_ocid
  description    = "Allow dls service"
  name           = var.dls_root_policy_name
  statements     = local.dls_root_policies
}
