# Daily notes 

```
Error: 409-IncorrectState, You are attempting to use a feature that's not currently enabled for this tenancy.
│ Suggestion: The resource is in a conflicted state. Please retry again or contact support for help with service: Database Autonomous
│ Documentation: https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_autonomous_database
│ API Reference: https://docs.oracle.com/iaas/api/#/en/database/20160918/AutonomousDatabase/CreateAutonomousDatabase
│ Request Target: POST https://database.eu-frankfurt-1.oraclecloud.com/20160918/autonomousDatabases
│ Provider version: 4.105.0, released on 2023-01-25.
│ Service: Database Autonomous
│ Operation Name: CreateAutonomousDatabase
│ OPC request ID: 1b816d739f958de3af126909790dfd7d/B66C877C32961AC6839B29BB66D96138/E92D21221A7DBC43C5A3EFF4BB7A9E91
│
│
│   with module.db.oci_database_autonomous_database.mongo_db,
│   on modules\db\main.tf line 6, in resource "oci_database_autonomous_database" "mongo_db":
│    6: resource "oci_database_autonomous_database" "mongo_db" {
```

# ebraekke/oci-adb-intro

https://docs.oracle.com/en-us/iaas/api/#/en/database/20160918/AutonomousDatabase/

# Intro 

This is the first version of a terraform recipe that creates an MongoDB compatible Autonomous inside a 
private subnet in a VCN. 


The recipe assumes a fairly basic network setup. 
I use a default VCN created by the wizard. 
* Netmask for VCN: `10.0.0.0/16`
* Netmask for public subnet: `10.0.0.0/24`
* Netmask for private subnet: `10.0.1.0/24`

In my reference network I only allow traffic on SSH (port 22), Oracle (1522) and MySQL (3306) from a Bastion's private IP that 
has been created in my public subnet. This means traffic through the Bastion is the only traffic allowed into the network. 

## Required input parameters 

```hcl
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
}```

## Default parameters

The following "default" parameters need to be provided to the oci terraform provider. 

```hcl
variable "region"               { default = "eu-frankfurt-1"}
variable "tenancy_ocid"         {}
variable "compartment_ocid"     {}
variable "user_ocid"            {}
variable "fingerprint"          {}
variable "private_key_path"     {}
```

## Outputs

The created Connection resource contains all the information needed access ADB.

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

conn_ocid = "ocid1.databasetoolsconnection.oc1.eu-frankfurt-1.<some-secret-string>"
```


## Other 

The created config can be used by the repo `ebraekke/oci-powershell-modules` when connecting via mongosh.

## Usage

Store config files in sub-dir `config/` it is ignored by git.

```bash
terraform plan --out=oci-adb-intro.tfplan --var-file=config/vars_fra.tfvars

terraform apply "oci-adb-intro.tfplan"
```
