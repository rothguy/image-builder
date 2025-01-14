variable "source_image" {
  type = string
}

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.3"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "test" {
  project_id                  = "image-builder-dev"
  source_image                = var.source_image
  zone                        = "us-central1-a"
  ssh_username                = "imagebuilder"
  use_iap                     = true
  skip_create_image           = true
}

build {
  sources = ["sources.googlecompute.test"]

  provisioner "shell" {
    inline = ["ls -la"]
  }
}
