
# generate password, this resource creates warnings if you try to output 
resource "random_password" "_db_password" {

  # https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingpasswordrules.htm
  length           = 16
  special          = true
  override_special = "!#_"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

# variables for readbility in complex statements
locals {
  # host creation helpers -- uncomment if needed 
  # user_data_base64_standard = filebase64("${path.module}/templates/standard.tpl")
   
  # perform illegal op if encoding of password is not BASE64
  circuitbreaker = data.oci_secrets_secretbundle.db_password.secret_bundle_content[0]["content_type"] == "BASE64" ? 1/1 : 1/0

  # not used for now, but can be used for distribution across ads
  avadom_list  = data.oci_identity_availability_domains.ads.availability_domains
  avadom_count = length(local.avadom_list)

  # primary domain == ad1
  avadom_name  =  data.oci_identity_availability_domain.ad1.name 

  # fault domains for ad1
  faldom_list  = data.oci_identity_fault_domains.ad1_fds.fault_domains
  faldom_count = length(local.faldom_list)

  # get password once
  db_password_base64 = base64encode(random_password._db_password.result)
}
