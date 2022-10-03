resource "confluent_environment" "development_env" {
  display_name = "Development"

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
  }
}

resource "confluent_kafka_cluster" "basic_kafka_cluster" {
  display_name = "basic_kafka_cluster"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "eu-central-1"
  basic {}
  environment {
    id = confluent_environment.development_env.id
  }
  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
  }
}
resource "confluent_service_account" "app-manager" {
  display_name = "app-manager"
  description  = "Service account to manage 'inventory' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-cluster-admin" {
  crn_pattern = confluent_kafka_cluster.basic_kafka_cluster.rbac_crn
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "CloudClusterAdmin"

}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.basic_kafka_cluster.id
    api_version = confluent_kafka_cluster.basic_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.basic_kafka_cluster.kind

    environment {
      id = confluent_environment.development_env.id
    }
  }
  depends_on = [
    confluent_role_binding.app-manager-kafka-cluster-admin
  ]

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
  }
}

resource "confluent_kafka_topic" "orders" {

  topic_name       = "orders"
  partitions_count = 4
  rest_endpoint    = confluent_kafka_cluster.basic_kafka_cluster.rest_endpoint
  config = {
    "cleanup.policy"    = "compact"
    "max.message.bytes" = "12345"
    "retention.ms"      = "67890"
  }
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }
  kafka_cluster {
    id = confluent_kafka_cluster.basic_kafka_cluster.id
  }

  lifecycle {
    #prevent_destroy = true
    create_before_destroy = true
  }
  depends_on = [
    confluent_kafka_cluster.basic_kafka_cluster
  ]
}

