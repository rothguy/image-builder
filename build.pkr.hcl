packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.3"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "imagebuilder" {
  project_id                  = "image-builder-dev"
  source_image_family         = "ubuntu-2204-lts"
  zone                        = "us-central1-a"
  ssh_username                = "root"
  omit_external_ip            = true
  use_internal_ip             = true
}

build {
  sources = ["sources.googlecompute.imagebuilder"]
}
