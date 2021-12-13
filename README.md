# Provision Data Labeling Service (DLS) Using OCI Resource Manager and Terraform

## Introduction

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-quickstart/oci-ods-orm/releases/download/1.0.6/oci-ods-orm-v1.0.6.zip)

This solution allows you to provision [Data Labeling Service (**_DLS_**)](https://docs.oracle.com/en-us/iaas/data-labeling/data-labeling/using/home.htm) and all its related artifacts using [Terraform](https://www.terraform.io/docs/providers/oci/index.html) and [Oracle Cloud Infrastructure Resource Manager](https://docs.cloud.oracle.com/en-us/iaas/Content/ResourceManager/Concepts/resourcemanager.htm).

Below is a list of all artifacts that will be provisioned:

| Component    | Default Name            | Optional |  Notes
|--------------|-------------------------|----------|:-----------|
| [Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm)        | Oracle Cloud Infrastructure Users Group              | False    | All Policies are granted to this group, you can add users to this group to grant me access to ODS services.
| [Dynamic Group](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm) | Oracle Cloud Infrastructure Dynamic Group           | False    | Dynamic Group for Functions and API Gateway.
| [Policies (compartment)](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)   | Oracle Cloud Infrastructure Security Policies        | False              | A policy at the compartment level to grant access to ODS, VCN, Functions and API Gateway
| [Policies (root)](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Concepts/policygetstarted.htm)    | Oracle Cloud Infrastructure Security Policies        | False              | A policy at the root compartment level to grant access to OCIR in tenancy.

## Prerequisite

- You need a user with an **Administrator** privileges to execute the ORM stack or Terraform scripts.
- Make sure your tenancy has service limits availabilities for the above components in the table.

## Using Resource Manager

1. clone repo `git clone git@github.com:oracle-quickstart/oci-dls.git`

1. First off we'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

1. Note, the instructions below build a `.zip` file from you local copy for use in ORM.

1. Make sure you have terraform v0.14+ cli installed and accessible from your terminal.


1. In order to `build` the zip file with the latest changes you made to this code, you can simply go to [build-orm](./build-orm) folder and use terraform to generate a new zip file:

At first time, you are required to initialize the terraform modules used by the template with  `terraform init` command:

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/archive...
- Installing hashicorp/archive v2.1.0...
- Installed hashicorp/archive v2.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Once terraform is initialized, just run `terraform apply` to generate ORM zip file.

```bash
$ terraform apply

data.archive_file.generate_zip: Refreshing state...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

This command will package the content of `simple` folder into a zip and will store it in the `build-orm\dist` folder. You can check the content of the file by running `unzip -l dist/orm.zip`:

```bash
$ unzip -l dls-orm.zip
Archive:  dls-orm.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
     2373  01-01-2049 00:00   iam.tf
     1858  01-01-2049 00:00   schema.yaml
       44  01-01-2049 00:00   scripts/example.sh
     1296  01-01-2049 00:00   variables.tf
---------                     -------
     5571                     4 files
```

1. From Oracle Cloud Infrastructure **Console/Resource Manager**, create a new stack.
1. Make sure you select **My Configurations** and then upload the zip file downloaded in the previous step.
1. Set a name for the stack and click Next.
1. Set the required variables values and then Create.
    ![create stack](images/create-dls-orm.mp4)

1. From the stack details page, Select **Plan** button and make sure it completes successfully.

1. From the stack details page, Select **Apply** button and make sure it completes successfully.

1. To destroy all created artifacts, from the stack details page, Select **Destroy** under **Terraform Actions** menu button and make sure it completes successfully.

### Understanding Provisioning Options

- **IAM Groups/Policies** change default names of Groups and Policies to be created.

    ![IAM Configs](images/iam_variables.png)


    ## Using Terraform

    1. Clone repo

       ```bash
       git clone git@github.com:oracle-quickstart/oci-dls.git
       cd oci-dls/terraform
       ```

    1. Create a copy of the file **oci-dls/terraform/terraform.tfvars.example** in the same directory and name it **terraform.tfvars**.
    1. Open the newly created **oci-dls/terraform/terraform.tfvars** file and edit the following sections:
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

    1. Open file **oci-dls/terraform/provider.tf** and uncomment the (user_id , fingerprint, private_key_path) in the **_two_** providers (**Default Provider** and **Home Provider**)

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

## Contributing

`oci-dls` is an open source project. See [CONTRIBUTING](CONTRIBUTING.md) for details.

Oracle gratefully acknowledges the contributions to `oci-dls` that have been made by the community.
