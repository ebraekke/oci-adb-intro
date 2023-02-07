

data "oci_database_autonomous_database" "my_adb" {
    autonomous_database_id = var.adb_db_ocid
}
