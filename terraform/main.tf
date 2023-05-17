# Comment for passing tests
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.12"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

# resource "yandex_compute_instance" "app" {
#   count = var.inst_count
#   name  = "reddit-app-${count.index + 1}"
#   zone  = var.zone

#   connection {
#     type        = "ssh"
#     host        = self.network_interface.0.nat_ip_address
#     user        = "ubuntu"
#     agent       = false
#     private_key = file(var.private_key_path)
#     # путь до приватного ключа
#   }

#   provisioner "file" {
#     source      = "files/puma.service"
#     destination = "/tmp/puma.service"
#   }

#   provisioner "remote-exec" {
#     script = "files/deploy.sh"
#   }
# }
