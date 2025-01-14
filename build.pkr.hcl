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
  image_name                  = "my-image"
  image_description           = "New image description"
  ssh_username                = "imagebuilder"
  use_iap                     = true
}

source "googlecompute" "test" {
  project_id                  = "image-builder-dev"
  source_image                = "my-image"
  zone                        = "us-central1-a"
  ssh_username                = "imagebuilder"
  use_iap                     = true
  skip_create_image           = true
}

build {
  sources = ["sources.googlecompute.build"]

  provisioner "shell" {
    script = "install-redis.sh"
  }
}

build {
  sources = ["sources.googlecompute.test"]

  provisioner "shell" {
    inline = ["ls -la"]
  }
}
