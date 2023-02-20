# ebraekke/oci-adb-intro


This is the first version of a terraform recipe that creates an Autonomous inside a private subnet in a VCN. 


The recipe assumes a fairly basic network setup. 
I use a default VCN created by the wizard. 
* Netmask for VCN: `10.0.0.0/16`
* Netmask for public subnet: `10.0.0.0/24`
* Netmask for private subnet: `10.0.1.0/24`

In my reference network I only allow traffic on SSH (port 22), Oracle (1521) and MySQL (3306) from a Bastion's private IP that 
has been created in my public subnet. This means traffic through the Bastion is the only traffic allowed into the private subnet. 
I addition I allow Oracle database traffic (1521) from the two addresses of a private endpoint (aka "Reverse connection source IPs")
into the private subnet. This seems to be a prerequisite for making SQLcl in CloudShell work.   

## Session based authentication 

Provide the name of the session created using `oci cli session autenticate` in the variable `oci_cli_profile`. 

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
```

## Default parameters

The following "default" parameters need to be provided to the oci terraform provider. 

```hcl
variable "region"               { default = "eu-frankfurt-1"}
variable "oci_cli_profile"      { 
    description = "name of oci cli profile used for session based auth"
}
variable "tenancy_ocid"         {}
```

## Outputs

The created Connection resource contains all the information needed to access ADB.

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

conn_ocid = "ocid1.databasetoolsconnection.oc1.eu-frankfurt-1.<some-secret-string>"
```

## Other 

The created config can be used by the repo `ebraekke/oci-powershell-modules` when connecting via sqlcl.

## Usage

Store config files in sub-dir `config/` it is ignored by git.

```bash
terraform plan --out=oci-adb-intro.tfplan --var-file=config/vars_fra.tfvars

terraform apply "oci-adb-intro.tfplan"
```
