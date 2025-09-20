output "external_ip"  { value = yandex_compute_instance.vm.network_interface[0].nat_ip_address }
output "internal_ip"  { value = yandex_compute_instance.vm.network_interface[0].ip_address }
output "security_group_id" { value = yandex_vpc_security_group.sg.id }
