
/* uncomment for debugging -- not needed otherwise
*/

output "ads" {
  value = data.oci_identity_availability_domains.ads
}

output "vcn_name" {
  value = data.oci_core_vcn.this_vcn.dns_label
}


/*
output "conn_ocid" {
  value = module.conn.conn_ocid
}
*/
