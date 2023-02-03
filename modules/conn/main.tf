

resource "oci_database_tools_database_tools_connection" "adb_connection" {
    compartment_id  = var.compartment_ocid
    display_name    = var.connection_name
    type = "ORACLE_DATABASE"

    ## TODO: figure out how to create!
    connection_string = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1521)(host=myadb.adb.eu-frankfurt-1.oraclecloud.com))(connect_data=(service_name=hikomo1xnp7z6id_myadb_low.adb.oraclecloud.com))(security=(ssl_server_dn_match=no)))"

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