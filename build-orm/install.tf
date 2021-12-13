variable "save_to" {
    default = "/Users/shwethasridharan/Downloads/dls_orm/"
}

data "archive_file" "generate_zip" {
  type        = "zip"
  output_path = (var.save_to != "" ? "${var.save_to}/dls-orm.zip" : "${path.module}/dist/dls-orm.zip")
  source_dir = "../"
  excludes    = ["packer",".terraform.lock.hcl","terraform.tfstate", "terraform.tfvars.template", "terraform.tfvars", "provider.tf", ".terraform", "build-orm", "images", "README.md", "terraform.", "terraform.tfstate.backup", "test", "simple", ".git", "README", "CONTRIBUTING.md", ".github", ".gitignore", ".DS_Store", "LICENSE","diagram",]
}
