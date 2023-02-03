
/*
For readability
*/
locals {
  adb_ip = data.oci_database_autonomous_database.my_adb.private_endpoint
  adb_name = data.oci_database_autonomous_database.my_adb.private_endpoint

  ## get full service name in easy fmt
  full_adb_service_name = data.oci_database_autonomous_database.my_adb.connection_strings[0]["low"] 

  ## extract the "real service name"
  adb_service_name = local.full_adb_service_name
}
