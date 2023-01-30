
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

variable "db_cores" {
    description = "Number of Cores for ADB"
    default = "1"
}


variable "db_gb_storage" {
    description = "Number GB storage for ADB"
    default = "1"
}

variable "autoscale_cpu" {
    description = "Autoscale CPUs?"
    default = true
}

variable "autoscale_storage" {
    description = "Autoscale storage?"
    default = true
}

###########################################################################
# Details related to account/identity (provider.tf)
###########################################################################
variable "region"               { default = "eu-frankfurt-1"}
variable "tenancy_ocid"         {}
variable "compartment_ocid"     {}
variable "user_ocid"            {}
variable "fingerprint"          {}
variable "private_key_path"     {}
