provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kms_symmetric_key" "kms_key" {
  name              = var.kms_key_name
  default_algorithm = "AES_128"
}

resource "yandex_storage_bucket" "my_bucket" {
  bucket        = var.bucket_name
  access_key    = var.access_key
  secret_key    = var.secret_key
  force_destroy = "true"
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.kms_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
