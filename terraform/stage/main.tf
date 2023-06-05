provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "vpc" {
  source = "../modules/vpc"
}

module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  app_disk_image   = var.app_disk_image
  private_key_path = var.private_key_path
  db_url           = module.db.external_ip_address_db
  subnet_id        = module.vpc.app_subnet_id
#   depends_on       = [module.db]
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  db_disk_image    = var.db_disk_image
  private_key_path = var.private_key_path
  subnet_id        = module.vpc.app_subnet_id
#   depends_on       = [module.vpc]
}

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/ansible_inventory_ini.tpl",
    {
      app_servers = module.app.*.external_ip_address_app
      db_servers  = module.db.*.external_ip_address_db
    }
  )
  filename = "../../ansible/environments/stage/inventory"
}
