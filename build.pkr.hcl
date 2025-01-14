variable project_id {
  type = string
  default = "default_hcl_project_id"
}

variable zone {
  type = string
  default = "default_hcl_zone"
}

variable source_image_family {
  type = string
  default = "default_hcl_source_image_family"
}

variable image_name {
  type = string
  default = "default-hcl-image-name"
}

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.3"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "build" {
  project_id                  = var.project_id
  source_image_family         = var.source_image_family
  zone                        = var.zone
  image_name                  = var.image_name
  ssh_username                = "imagebuilder"
  use_iap                     = true
}

source "googlecompute" "test" {
  project_id                  = var.project_id
  source_image                = var.image_name
  zone                        = var.zone
  ssh_username                = "imagebuilder"
  use_iap                     = true
  skip_create_image           = true
}

build {
  name = "build"
  sources = ["sources.googlecompute.build"]
}

build {
  name = "test"
  sources = ["sources.googlecompute.test"]

  provisioner "shell" {
    inline = ["ls -la"]
  }
}
