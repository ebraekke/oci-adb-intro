
/*
For readability
*/
locals {
  adb_name = data.oci_database_autonomous_database.my_adb.private_endpoint

  ## get full service name for "low" connection in easy fmt
  full_adb_service_name = data.oci_database_autonomous_database.my_adb.connection_strings[0]["low"] 

  ## extract the "real service name", assumes max length of less than (1000*10) - 1
  adb_service_name = substr(regex("\\/.*$",  local.full_adb_service_name), 1, 1000*10)

  ## template conn string
  template_connection_string = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1521)(host=xHOSTx))(connect_data=(service_name=xSERVICE_NAMEx))(security=(ssl_server_dn_match=no)))"

  ## replace markers twice in nested fashion 
  connection_string = replace(replace(local.template_connection_string, "xHOSTx", local.adb_name), "xSERVICE_NAMEx", local.adb_service_name)
}
