/*

Where is the tools spec? 

https://docs.oracle.com/en-us/iaas/api/#/en/database/20160918/datatypes/CreateAutonomousDatabaseDetails

and 

https://docs.oracle.com/en-us/iaas/api/#/en/database/20160918/datatypes/DatabaseTool

*/
resource "oci_database_autonomous_database" "my_adb" {

    ## name and placement
    compartment_id                      = var.compartment_ocid
    db_name                             = var.db_name
    display_name                        = var.db_name

    ## security 
    subnet_id                           = var.subnet_ocid
    admin_password                      = base64decode(var.db_password_base64)
    is_mtls_connection_required         = false

    ## db_tools 
    db_tools_details {
        name                     = "MONGODB_API"
        is_enabled               = true
        compute_count            = 0
        max_idle_time_in_minutes = 0 
    }

    ## specs
    cpu_core_count                      = var.db_cores
    data_storage_size_in_tbs            = var.db_tb_storage
    is_auto_scaling_enabled             = true
    is_auto_scaling_for_storage_enabled = true
    license_model                       = "LICENSE_INCLUDED"
    # db_version                          = "19c"
    db_workload                         = "OLTP"
    # max_cpu_core_count                  = (var.db_cores * 3)
    private_endpoint_label              = var.db_name
}
