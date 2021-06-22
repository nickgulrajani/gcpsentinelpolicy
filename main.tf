terraform {
  required_version = ">= 0.11.1"
}
terraform {
  backend "remote" {
    organization = "tige-ignw"
    workspaces {
      name = "nick-sentinel-workspace"
    }
  }
}

variable "gcp_credentials" {
  description = "GCP credentials needed by google provider"
  default = "CREDENTIALS_FILE.json"
}

variable "gcp_project" {
  description = "GCP project name"
  default = "devsecops-311418"
}

variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
  default = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-a"
  default = "us-central1-a"
}


variable "machine_type" {
  description = "GCP machine type"
  default = "n1-standard-1"
}

variable "instance_name" {
  description = "GCP instance name"
  default = "demo"
}

variable "image" {
  description = "image to build instance from"
  default = "debian-cloud/debian-9"
}

provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_compute_instance" "demo" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

}

output "external_ip"{
  value = google_compute_instance.demo.network_interface.0.access_config.0.nat_ip
}
