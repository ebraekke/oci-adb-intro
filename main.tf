

module "db" {
    source              = "./modules/db"

    db_name             = "${var.set_name}adb"
    db_password_base64  = data.oci_secrets_secretbundle.db_password.secret_bundle_content[0]["content"]
    avadom_name         = local.avadom_name
    compartment_ocid    = var.compartment_ocid
    subnet_ocid         = var.subnet_ocid
    db_cores            = var.db_cores
    db_tb_storage       = var.db_tb_storage
}

module "conn" {
    source              = "./modules/conn"

    compartment_ocid    = var.compartment_ocid
    connection_name     = "${var.set_name}adbconn"
    adb_db_ocid         = module.db.adb_db_ocid
    db_user_name        = "admin"
    db_password_ocid    = data.oci_secrets_secretbundle.db_password.secret_id
    priv_endpoint_ocid  = var.priv_endpoint_ocid
}
