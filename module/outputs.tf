output "bucket_id" {
  value = aws_s3_bucket.sunkenland.id
}

output "instance_id" {
  value = aws_spot_instance_request.sunkenland.spot_instance_id
}

output "monitoring_url" {
  value = format("%s%s%s", "http://", aws_spot_instance_request.sunkenland.public_dns, ":19999")
}
