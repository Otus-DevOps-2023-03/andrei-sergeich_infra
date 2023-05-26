terraform {
  backend "s3" {
    endpoint                = "storage.yandexcloud.net"
    bucket                  = var.bucket_name
    region                  = "ru-central1"
    key                     = "stage/terraform.tfstate"
    shared_credentials_file = "./s3_credentials"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
