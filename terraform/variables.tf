variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
  # Значение по умолчанию
}

variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable "image_id" {
  description = "Disk image"
}

# variable "subnet_id" {
#   description = "Subnet"
# }

variable "service_account_key_file" {
  description = "key.json"
}

variable "inst_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "app_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "db_disk_image" {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "ssh_user" {
  description = "User name for SSH connection"
  default     = "ubuntu"
}

variable "bucket_name" {
  description = "s3 bucket name"
}

variable "access_key" {
  description = "access key for s3 bucket"
}

variable "secret_key" {
  description = "secret key for s3 bucket"
}
