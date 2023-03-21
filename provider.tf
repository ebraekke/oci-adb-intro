terraform {
  required_version = "~> 1.2.0"
}

provider "oci" {
  region              = var.region
  
  auth = "SecurityToken"
  config_file_profile = var.oci_cli_profile
}
