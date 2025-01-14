locals {
  image_name = "my-image-{{timestamp}}"
}

variable output_image_name {
  type    = string
  default = "default_output_image_name"
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
  project_id                  = "image-builder-dev"
  source_image_family         = "ubuntu-2204-lts"
  zone                        = "us-central1-a"
  image_name                  = local.image_name
  image_description           = "New image description"
  ssh_username                = "imagebuilder"
  use_iap                     = true
}

source "googlecompute" "test" {
  project_id                  = "image-builder-dev"
  source_image                = var.output_image_name
  zone                        = "us-central1-a"
  ssh_username                = "imagebuilder"
  use_iap                     = true
  skip_create_image           = true
}

build {
  name = "build"
  sources = ["sources.googlecompute.build"]

  provisioner "shell" {
    script = "install-redis.sh"
  }

  post-processor "shell-local" {
    inline = ["echo 'output_image_name = \"${local.image_name}\"' > output.auto.pkrvars.hcl"]
  }
}

build {
  name = "test"
  sources = ["sources.googlecompute.test"]

  provisioner "shell" {
    inline = ["ls -la"]
  }
}
