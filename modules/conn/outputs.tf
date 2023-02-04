
###########################################################################
# OUTPUT
###########################################################################

output "conn_ocid" {
  value = oci_database_tools_database_tools_connection.adb_connection.id
}
