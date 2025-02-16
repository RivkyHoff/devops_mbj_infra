# # Configure the Google Cloud provider
# provider "google" {
#   credentials = file("./service-account.json")
#   project = "basic-formula-447613-s1yes"
#   region  = "me-west1"
# }

# # Create a Google Compute instance
# resource "google_compute_instance" "example" {
#   name          = "example"
#   machine_type  = "e2-micro"
#   zone          = "me-west1-b"
  
#   boot_disk {
#     initialize_params {
#       image = "projects/debian-cloud/global/images/family/debian-12"
#     }
#   }
  
#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral IP
#     }
#   }
# }

provider "google" {
  credentials = file("./service-account.json")
  project     = var.project_id
  region      = var.region
}
resource "google_compute_subnetwork" "custom_subnetwork" {
   name          = "${var.myname}-subnetwork"  # Keep as a unique name
  network       = "default"                  # Reference the existing default network
  ip_cidr_range = "10.0.0.0/24"              # Updated to a non-overlapping CIDR range
  region        = var.region
}

resource "google_compute_region_instance_template" "template" {
  name          = "${var.myname}-template"
  machine_type  = "e2-micro"

  disk {
    source_image = "projects/debian-cloud/global/images/family/debian-12"
  }

  network_interface {
    network    = "default"  # Ensure this references the existing default network
    access_config {}
  }

  metadata_startup_script = file("startup.sh")
}

resource "google_compute_region_instance_group_manager" "mig" {
  name                    = "${var.myname}-mig"
  
  version {
    instance_template = google_compute_region_instance_template.template.self_link
  }
  
  base_instance_name      = "${var.myname}-instance"
  region                  = var.region
  target_size             = 1

  depends_on = [google_compute_region_instance_template.template]
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "${var.myname}-autoscaler"
  target = google_compute_region_instance_group_manager.mig.self_link

  autoscaling_policy {
    min_replicas = 1
    max_replicas = 3
  }
}

resource "google_compute_region_health_check" "health_check" {
  name                = "example-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port = 80
    request_path = "/"
  }
}
