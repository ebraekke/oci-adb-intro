

resource "oci_database_tools_database_tools_connection" "adb_connection" {
    compartment_id  = var.compartment_ocid
    display_name    = var.connection_name
    type = "ORACLE_DATABASE"

    connection_string = local.connection_string
    
    private_endpoint_id = var.priv_endpoint_ocid
    
    related_resource {
        #Required
        entity_type = "AUTONOMOUSDATABASE"
        identifier  = var.adb_db_ocid
    }

    user_name = "admin"
    user_password {
        secret_id   = var.db_password_ocid
        value_type  = "SECRETID"
    }
}