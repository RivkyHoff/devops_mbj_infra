# output "instance_ip" {

# description = "IP address of the instance"

# value = google_compute_instance.my_instance.network_interface[0].access_config[0].nat_ip

# }

output "instance_group_manager_self_link" {
  value = google_compute_region_instance_group_manager.mig
}

output "health_check_self_link" {
  value = google_compute_region_health_check.health_check
}