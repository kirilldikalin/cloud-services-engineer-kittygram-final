terraform {
  backend "s3" {
    # фиксированный endpoint для Object Storage
    endpoints = { s3 = "https://storage.yandexcloud.net" }
    region    = "ru-central1"
    key       = "tf-state.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
