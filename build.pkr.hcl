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
  image_name                  = "my-image-{{timestamp}}"
  image_description           = "New image description"
  ssh_username                = "imagebuilder"
  use_iap                     = true
}

build {
  sources = ["sources.googlecompute.imagebuilder"]
}
