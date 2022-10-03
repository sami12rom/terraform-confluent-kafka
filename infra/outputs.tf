output "resource-ids" {
  value     = <<-EOT
  Environment ID:   ${confluent_environment.development_env.id}
  Kafka Cluster ID: ${confluent_kafka_cluster.basic_kafka_cluster.id}
  Kafka topic name: ${confluent_kafka_topic.orders.topic_name}
    run the following commands:
  # 1. Log in to Confluent Cloud
  $ confluent login
  # 2. Produce key-value records to topic '${confluent_kafka_topic.orders.topic_name}' by using Kafka API Key 
  # Enter a few records and then press 'Ctrl-C' when you're done.
  # Sample records:
  # {"number":1,"date":18500,"shipping_address":"899 W Evelyn Ave, Mountain View, CA 94041, USA","cost":15.00}
  # {"number":2,"date":18501,"shipping_address":"1 Bedford St, London WC2E 9HG, United Kingdom","cost":5.00}
  # {"number":3,"date":18502,"shipping_address":"3307 Northland Dr Suite 400, Austin, TX 78731, USA","cost":10.00}
  
  EOT
  sensitive = true
}
