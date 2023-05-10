terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.12"
}

provider "yandex" {
  service_account_key_file = "svc_acct_key.json"
  cloud_id                 = "b1g9njqvrj5rvqmiuu7a"
  folder_id                = "b1g83nhabcouvia9hqhg"
  zone                     = "ru-central1-a"
}

resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = "fd83cb84r35jimtq6hsa"
    }
  }

  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = "e9bru58ieckd54a89a5a"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }

  connection {
    type        = "ssh"
    host        = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file("~/.ssh/id_ed25519")
    # путь до приватного ключа
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}
