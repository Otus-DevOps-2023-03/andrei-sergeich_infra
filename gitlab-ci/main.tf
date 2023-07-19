provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_compute_instance" "gitlab" {
  name = "gitlab"
  labels = {
    tags = "gitlab"
  }
#   platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 8
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.gitlab-subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }
}

resource "yandex_vpc_network" "gitlab-network" {
  name = "gitlab-network"
}

resource "yandex_vpc_subnet" "gitlab-subnet" {
  name           = "gitlab-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.gitlab-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/ansible_inventory_ini.tpl",
    {
      gitlab_servers = yandex_compute_instance.gitlab[*].network_interface.0.nat_ip_address
    }
  )
  filename = "./inventory"
}
