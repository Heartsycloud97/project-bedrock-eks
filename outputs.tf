output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "vpc_id" {
  value = aws_vpc.bedrock_vpc.id
}

output "assets_bucket_name" {
  value = aws_s3_bucket.assets.id
}

output "region" {
  value = var.aws_region
}
