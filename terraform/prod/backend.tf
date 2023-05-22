terraform {
  backend "s3" {
    endpoint                = "storage.yandexcloud.net"
    bucket                  = "andrei-sergeich-infra-bucket"
    region                  = "ru-central1"
    key                     = "prod/terraform.tfstate"
    shared_credentials_file = "./s3_credentials"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
