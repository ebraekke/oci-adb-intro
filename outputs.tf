
/* uncomment for debugging -- not needed otherwise
output "ads" {
  value = data.oci_identity_availability_domains.ads
}
*/

output "conn_ocid" {
  value = module.conn.conn_ocid
}

output "adb_db_ocid" {
  value = module.db.adb_db_ocid
}
