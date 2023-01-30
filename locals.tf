
# variables for readbility in complex statements
locals {
  # host creation helpers -- uncomment if needed 
  # user_data_base64_standard = filebase64("${path.module}/templates/standard.tpl")
   
  # perform illegal op if encoding of password is not BASE64
  circuitbraker = data.oci_secrets_secretbundle.db_password.secret_bundle_content[0]["content_type"] == "BASE64" ? 1/1 : 1/0

  # not used for now, but can be used for distribution across ads
  avadom_list  = data.oci_identity_availability_domains.ads.availability_domains
  avadom_count = length(local.avadom_list)

  # primary domain == ad1
  avadom_name  =  data.oci_identity_availability_domain.ad1.name 

  # fault domains for ad1
  faldom_list  = data.oci_identity_fault_domains.ad1_fds.fault_domains
  faldom_count = length(local.faldom_list)
}
