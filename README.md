# Provision Data Labeling Service (DLS) Using OCI Resource Manager and Terraform

## Introduction

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-ods-orm/releases/download/1.0.6/oci-ods-orm-v1.0.6.zip)

This solution allows you to provision [Data Labeling Service (**_DLS_**)](https://docs.oracle.com/en-us/iaas/data-labeling/data-labeling/using/home.htm) and all its related artifacts using [Terraform](https://www.terraform.io/docs/providers/oci/index.html) and [Oracle Cloud Infrastructure Resource Manager](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm).

Below is a list of all artifacts that will be provisioned:

| Component    | Default Name            | Optional |  Notes
|--------------|-------------------------|----------|:-----------|
| [Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm)        | Oracle Cloud Infrastructure Users Group              | False    | All Policies are granted to this group, you can add users to this group to grant access to DLS services.
| [Dynamic Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm) | Oracle Cloud Infrastructure Dynamic Group           | False    |
| [Policies (root)](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)    | Oracle Cloud Infrastructure Security Policies        | False              | Policies at the root compartment level to grant access to DLS.
## Prerequisite

- You need a user with an **Administrator** privileges to execute the ORM stack or Terraform scripts.
- Make sure your tenancy has service limits availabilities for the above components in the table.

## Option 1 - Provision using Terraform CLI

1. Clone repo

   ```bash
   git clone git@github.com:oracle-quickstart/oci-dls.git
   cd oci-dls/
   ```

1. Create a copy of the file **oci-dls/terraform.tfvars.example** in the same directory and name it **terraform.tfvars**.

1. Open the newly created **oci-dls/terraform.tfvars** file and edit the following sections:
    - **TF Requirements** : Add your Oracle Cloud Infrastructure user and tenant details:

        ```text
           #*************************************
           #           TF Requirements
           #*************************************

           // Oracle Cloud Infrastructure Region, user "Region Identifier" as documented here https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
           region=""
           // The Compartment OCID to provision artificats within
           compartment_ocid=""
           // Oracle Cloud Infrastructure User OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
           user_ocid=""
           // Oracle Cloud Infrastructure tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
           tenancy_ocid=""
           // Path to private key used to create Oracle Cloud Infrastructure "API Key", more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
           private_key_path=""
           // "API Key" fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
           fingerprint=""
        ```

    - **IAM Requirements**: Check default values for IAM artifacts and change them if needed

        ```text
           #*************************************
           #          IAM Specific
           #*************************************

           // ODS IAM Group Name (no spaces)
           ods_group_name= "DataScienceGroup"
           // ODS IAM Dynamic Group Name (no spaces)
           ods_dynamic_group_name= "DataScienceDynamicGroup"
           // ODS IAM Policy Name (no spaces)
           ods_policy_name= "DataSciencePolicies"
           // ODS IAM Root Policy Name (no spaces)
           ods_root_policy_name= "DataScienceRootPolicies"
           // If enabled, the needed OCI policies to manage "OCI Vault service" will be created
           enable_vault_policies= true
        ```

1. Open file **oci-dls/provider.tf** and uncomment the (user_id , fingerprint, private_key_path) in the **_two_** providers (**Default Provider** and **Home Provider**)

    ```text
        // Default Provider
        provider "oci" {
          region = var.region
          tenancy_ocid = var.tenancy_ocid
          ###### Uncomment the below if running locally using terraform and not as Oracle Cloud Infrastructure Resource Manager stack #####
        //  user_ocid = var.user_ocid
        //  fingerprint = var.fingerprint
        //  private_key_path = var.private_key_path

        }

        // Home Provider
        provider "oci" {
          alias            = "home"
          region           = lookup(data.oci_identity_regions.home-region.regions[0], "name")
          tenancy_ocid = var.tenancy_ocid
          ###### Uncomment the below if running locally using terraform and not as Oracle Cloud Infrastructure Resource Manager stack #####
        //  user_ocid = var.user_ocid
        //  fingerprint = var.fingerprint
        //  private_key_path = var.private_key_path

        }
    ```
1. Make sure you have terraform v1.0+ cli installed and accessible from your terminal.

1. Initialize terraform provider

> terraform init

1. Plan terraform scripts

> terraform plan

1. Run terraform scripts

> terraform apply -auto-approve

If you wish to Destroy all created artifacts use -

> terraform destroy -auto-approve

## Option 2 - Provision using OCI Resource Manager

ORM stack creation requires a .zip of the terraform configuration files to be uploaded.

1. Clone repo

   ```bash
   git clone git@github.com:oracle-quickstart/oci-dls.git
   cd oci-dls/
   ```
1. Create a copy of the file **oci-dls/terraform.tfvars.example** in the same directory and name it **terraform.tfvars**.

1. Open the newly created **oci-dls/terraform.tfvars** file and edit the following sections:
    - **TF Requirements** : Add your Oracle Cloud Infrastructure user and tenant details:

        ```text
           #*************************************
           #           TF Requirements
           #*************************************

           // Oracle Cloud Infrastructure Region, user "Region Identifier" as documented here https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
           region=""
           // The Compartment OCID to provision artificats within
           compartment_ocid=""
           // Oracle Cloud Infrastructure User OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
           user_ocid=""
           // Oracle Cloud Infrastructure tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
           tenancy_ocid=""
           // Path to private key used to create Oracle Cloud Infrastructure "API Key", more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
           private_key_path=""
           // "API Key" fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two
           fingerprint=""
        ```

    - **IAM Requirements**: Check default values for IAM artifacts and change them if needed

        ```text
           #*************************************
           #          IAM Specific
           #*************************************

           // ODS IAM Group Name (no spaces)
           ods_group_name= "DataScienceGroup"
           // ODS IAM Dynamic Group Name (no spaces)
           ods_dynamic_group_name= "DataScienceDynamicGroup"
           // ODS IAM Policy Name (no spaces)
           ods_policy_name= "DataSciencePolicies"
           // ODS IAM Root Policy Name (no spaces)
           ods_root_policy_name= "DataScienceRootPolicies"
           // If enabled, the needed OCI policies to manage "OCI Vault service" will be created
           enable_vault_policies= true
        ```

1. Make sure you have terraform v1.0+ cli installed and accessible from your terminal

1. cd build-orm

1. Initialize terraform provider

> terraform init

1. Plan terraform scripts

> terraform plan

1. Run terraform scripts

> terraform apply -auto-approve

This command will package the required files into a zip and will store it in the `build-orm\dist` folder. You can check the content of the file by running `unzip -l filename.zip`:

```bash
$ unzip -l dls-orm-2022-01-18T15:10:23Z.zip
Archive:  dls-orm-2022-01-18T15:10:23Z.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     2373  01-01-2049 00:00   iam.tf
     1006  01-01-2049 00:00   provider.tf
     1858  01-01-2049 00:00   schema.yaml
     1918  01-01-2049 00:00   terraform.tfvars
     1296  01-01-2049 00:00   variables.tf
---------                     -------
```
1. Download the dls-orm-<timestamp>.zip file

1. From Oracle Cloud Infrastructure **Console/Resource Manager**, create a new stack.

1. Select **My Configurations** and then upload the zip file.

1. Set a name for the stack and click Next.

1. Set the required variables values and then Create.
    ![create stack](images/create-dls-stack.gif)

1. From the stack details page, Select **Plan** button and make sure it completes successfully.

1. From the stack details page, Select **Apply** button and make sure it completes successfully.

1. To destroy all created artifacts, from the stack details page, Select **Destroy** under **Terraform Actions** menu button and make sure it completes successfully.

### Provisioning Options

- **IAM Groups/Policies** change default names of Groups and Policies to be created.

    ![IAM Configs](images/iam_variables.png)

## Contributing

`oci-dls` is an open source project. See [CONTRIBUTING](CONTRIBUTING.md) for details.

Oracle gratefully acknowledges the contributions to `oci-dls` that have been made by the community.
