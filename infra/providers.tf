terraform {
  required_version = ">= 1.2.0"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "0.12.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key    # optionally use TF_VAR_CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = var.confluent_cloud_api_secret # optionally use TF_VAR_CONFLUENT_CLOUD_API_SECRET env var
}
