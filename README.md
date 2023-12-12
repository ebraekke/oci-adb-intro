# ebraekke/oci-adb-intro


This is the first version of a terraform recipe that creates an Autonomous inside a private subnet in a VCN. 

The recipe assumes a fairly basic network setup. 
I use a default VCN created by the regular console based wizard. 
* Netmask for VCN: `10.0.0.0/16`
* Netmask for public subnet: `10.0.0.0/24`
* Netmask for private subnet: `10.0.1.0/24`

In my reference network I only allow traffic on SSH (port 22), Oracle (1521 and 27071) and MySQL (3306) from a Bastion's private IP that 
has been created in my public subnet. This means traffic through the Bastion is the only traffic allowed into the private subnet. 
I addition I allow Oracle database traffic (1521 and 27071) from the two addresses of a private endpoint (aka "Reverse connection source IPs")
into the private subnet. This seems to be a prerequisite for making SQLcl in CloudShell work.   

## Download the latest version of the Resource Manager ready stack from the releases section 

Or you can just click the button below. 

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/ebraekke/oci-adb-intro/releases/download/v0.9.0-alpha.1/oci-adb-intro_0.9.0.zip)


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
    description = "ocid of private endpoint in \"vcn_ocid\" to be used by new connection"
}

variable "compartment_ocid"     {
    description = "ocid of compartment"
}
```

## Default parameters

The following "default" parameters need to be passed to the oci terraform provider.

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
terraform plan --out=oci-adb-intro.arn.tfplan --var-file=config/vars_arn.tfvars

terraform apply "oci-adb-intro.arn.tfplan"
```

## Resource Manager

### Create a release 

Perform these operations from the top level folder in repo. 

Remember to add Linux to lock file.
```bash
terraform providers lock -platform=linux_amd64
```

Create ZIP archive, add non-tracked file from config dir.
```bash
git archive --add-file config\provider.tf --format=zip HEAD -o .\config\test_rel.zip
```

### Create stack

```bash
$C = "ocid1.compartment.oc1..somehashlikestring"
$config_source = "C:\Users\espenbr\GitHub\oci-adb-intro\config\test_rel.zip"
$variables_file = "C:/Users/espenbr/GitHub/oci-adb-intro/config/vars_arn.json"
$disp_name = "Demo of ADB stack"
$desc = "ADB Creation from RM" 
$wait_spec="--wait-for-state=ACTIVE"

oci resource-manager stack create --config-source=$config_source --display-name="$disp_name" --description="$desc" --variables=file://$variables_file -c $C --terraform-version=1.2.x $wait_spec
```

## List stacks in a compartment

Pwsh style quoting of strings. 

```bash
oci resource-manager  stack list -c $C --output table --query "data [*].{`"ocid`":`"id`", `"name`":`"display-name`"}"
<<
+-------------------+------------------------------------------------------------------------------------------------+
| name              | ocid                                                                                           |
+-------------------+------------------------------------------------------------------------------------------------+
| Demo of ADB stack | ocid1.ormstack.oc1.eu-frankfurt-1.somehashlikestring                                           |
+-------------------+------------------------------------------------------------------------------------------------+
```

### Create plan job

```bash
oci resource-manager job create-plan-job --stack-id $stack_ocid --wait-for-state=SUCCEEDED --wait-interval-seconds=10
```

### Submit apply job job based on plan run 

Grab the job id from the output of the plan job.  

```bash
$plan_job_ocid = "ocid1.ormjob.oc1.eu-frankfurt-1.somehashlikestring"

oci resource-manager job create-apply-job --execution-plan-strategy FROM_PLAN_JOB_ID --stack-id $stack_ocid --wait-for-state SUCCEEDED --wait-interval-seconds 10 --execution-plan-job-id $plan_job_ocid
```

### Create and run destroy job 

```bash
oci resource-manager job create-destroy-job --execution-plan-strategy AUTO_APPROVED  --stack-id $stack_ocid --wait-for-state SUCCEEDED --wait-interval-seconds 10
```

### Update variables 

```bash
oci resource-manager stack update --stack-id $stack_ocid --variables=file://C:/Users/espenbr/GitHub/oci-adb-intro/config/vars_arn.json
```

### Delete a specific stack 

```bash
oci resource-manager  stack delete --stack-id $stack_ocid --wait-for-state DELETED --wait-interval-seconds 10
```

## TODO: Creating  users for mongodb api verification 

This is the user that matches the connection object that will be created by this terraform specification.

```sql 
CREATE USER new_user IDENTIFIED BY password
/

GRANT CREATE SESSION TO new_user
/
```

Also, create connection object for this second user. 


# How to query the completed job 

```
$plan_job_ocid = "ocid1.ormjob.oc1.eu-frankfurt-1.somehashlikestring"

oci resource-manager job-output-summary list-job-outputs --job-id $plan_job_ocid
{
  "data": {
    "items": [
      {
        "description": "",
        "is-sensitive": false,
        "output-name": "conn_ocid",
        "output-type": "string",
        "output-value": "ocid1.databasetoolsconnection.oc1.eu-frankfurt-1.amaaaaaa3gkdkiaacjyckxnf42z7pqb3izxepl2otnne5nf7t6axurz5zpza"
      }
    ]
  }
}


```

```
$stack_outputs = oci resource-manager job-output-summary list-job-outputs --job-id $plan_job_ocid

$stack_outputs.data.items.Count
<<
1

$stack_outputs.data.items[0]
<<
description  :
is-sensitive : False
output-name  : conn_ocid
output-type  : string
output-value : ocid1.databasetoolsconnection.oc1.eu-frankfurt-1.amaaaaaa3gkdkiaacjyckxnf42z7pqb3izxepl2otnne5nf7t6axurz5zpza


$stack_outputs.data.items | Where-Object {$_.'output-name' -eq 'conn_ocid'}
<<
description  :
is-sensitive : False
output-name  : conn_ocid
output-type  : string
output-value : ocid1.databasetoolsconnection.oc1.eu-frankfurt-1.amaaaaaa3gkdkiaacjyckxnf42z7pqb3izxepl2otnne5nf7t6axurz5zpza

($stack_outputs.data.items | Where-Object {$_.'output-name'-eq 'conn_ocid'}).'output-value'
<<
ocid1.databasetoolsconnection.oc1.eu-frankfurt-1.amaaaaaa3gkdkiaacjyckxnf42z7pqb3izxepl2otnne5nf7t6axurz5zpza


$conn_ocid = ($stack_outputs.data.items | Where-Object {$_.'output-name'-eq 'conn_ocid'}).'output-value'

if ($null -eq $conn_ocid) {
  this is bad!
}

```
