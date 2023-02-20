
# Variables 
variable "subnet_ocid"          {
    description = "ocid of (private) subnet to host ADB"
}

variable "password_ocid" {
    description = "ocid of secret in vault"  
}

variable "priv_endpoint_ocid" {
    description = "ocid of private endpoint in \"subnet_ocid\" to be used by new connection" 
}

variable "compartment_ocid"     {
    description = "ocid of compartment"
}

variable "db_cores" {
    description = "Number of Cores for ADB"
    default = "1"
}

variable "db_tb_storage" {
    description = "Number TB storage for ADB"
    default = "1"
}

###########################################################################
# Details related to account/identity (provider.tf) and book keeping
###########################################################################
variable "region"               { default = "eu-frankfurt-1"}
variable "oci_cli_profile"      { 
    description = "name of oci cli profile used for session based auth"
}
variable "tenancy_ocid"         {}
