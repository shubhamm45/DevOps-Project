terraform {
  backend "s3" {
    key = "eks/cluster_name/statefile"
    region = "ap-south-1"
  }
} 
