output "monitoring_url" {
  value       = module.main.monitoring_url
  description = "URL to monitor the Sunkenland Server"
}

output "bucket_id" {
  value       = module.main.bucket_id
  description = "The S3 bucket name"
}

output "instance_id" {
  value       = module.main.instance_id
  description = "The EC2 instance ID"
}
