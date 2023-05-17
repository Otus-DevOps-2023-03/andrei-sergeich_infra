# output "external_ip_address_apps" {
#   value = yandex_compute_instance.app[*].network_interface.0.nat_ip_address
# }

# output "external_ip_address_apps" {
#   value = [
#     for inst in yandex_compute_instance.app :
#     "IP of ${inst.name} is ${inst.network_interface.0.nat_ip_address}"
#   ]
# }

# output "external_ip_address_lb" {
#   value = yandex_lb_network_load_balancer.lb.listener[*].external_address_spec[*].address
# }

# output "external_ip_address_lb" {
#   value = tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address
# }

output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}
output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}
