resource "yandex_lb_network_load_balancer" "lb" {
  name = "reddit-loadbalancer"

  listener {
    name        = "reddit-port-listener"
    port        = 80
    target_port = 9292

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb.id

    healthcheck {
      name = "reddit-healthcheck"

      http_options {
        port = 9292
        path = "/"
      }
    }
  }
}

resource "yandex_lb_target_group" "lb" {
  name = "reddit-target-group"

  target {
    subnet_id = var.subnet_id
    address   = yandex_compute_instance.app.network_interface.0.ip_address
  }
}
