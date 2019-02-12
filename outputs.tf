output "vault_cluster_size" {
  value = "${var.num_vault_servers}"
}

output "vault_admin_user_name" {
  value = "${module.vault_servers.admin_user_name}"
}

output "vault_load_balancer_ip_address" {
  value = "${module.vault_servers.load_balancer_ip_address}"
}

output "consul_cluster_size" {
  value = "${var.num_consul_servers}"
}
output "consul_admin_user_name" {
  value = "${module.consul_servers.admin_user_name}"
}
output "consul_load_balancer_ip_address" {
  value = "${module.consul_servers.load_balancer_ip_address}"
}
