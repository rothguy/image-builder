# Used to define the image name in the build step.
locals {
  image_name = "my-image-{{timestamp}}"
}

# Automatically loaded from output.auto.pkrvars.hcl for the test step.
variable built_image_name {
  type    = string
  default = "default_built_image_name"
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
  source_image                = var.built_image_name
  zone                        = "us-central1-a"
  ssh_username                = "imagebuilder"
  use_iap                     = true
  skip_create_image           = true
}

build {
  name = "build"
  sources = ["sources.googlecompute.build"]

  post-processor "shell-local" {
    inline = ["echo 'built_image_name = \"${local.image_name}\"' >> output.auto.pkrvars.hcl"]
  }
}

build {
  name = "test"
  sources = ["sources.googlecompute.test"]

  provisioner "shell" {
    inline = ["ls -la"]
  }
}
