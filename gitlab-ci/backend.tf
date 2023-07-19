terraform {
  backend "s3" {
    endpoint                = "storage.yandexcloud.net"
    bucket                  = "terraform-2-state-backend"
    region                  = "ru-central1"
    key                     = "gitlab/terraform.tfstate"
    shared_credentials_file = "./s3_credentials"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
