variable "save_to" {
    default = ""
}

data "archive_file" "generate_zip" {
  type        = "zip"
  output_path = (var.save_to != "" ? "${var.save_to}/dls-orm-${timestamp()}.zip" : "${path.module}/dist/dls-orm-${timestamp()}.zip")
  source_dir = "../"
  excludes    = ["packer",".terraform.lock.hcl","terraform.tfstate", "terraform.tfvars.example", ".terraform", "build-orm", "images", "README.md", "terraform.", "terraform.tfstate.backup", "test", "simple", ".git", "README", "CONTRIBUTING.md", ".github", ".gitignore", ".DS_Store", "LICENSE","diagram",]
}
