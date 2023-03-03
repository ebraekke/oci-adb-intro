
provider "oci" {
  auth = "SecurityToken"
  config_file_profile = var.oci_cli_profile
  region              = var.region
}
