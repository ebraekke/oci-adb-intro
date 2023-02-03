
/* uncomment for debugging -- not needed otherwise
*/

/*
output "ads" {
  value = data.oci_identity_availability_domains.ads
}

output "vcn_name" {
  value = data.oci_core_vcn.this_vcn.dns_label
}
*/

output "adb_db_ocid" {
  value = module.db.adb_db_ocid
}

output "adb_service_name" {
  value = module.conn.adb_service_name
} 

output "conn_ocid" {
  value = module.conn.conn_ocid
}

