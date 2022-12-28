terraform {
  backend "s3" {
    bucket = "euran-terraform-statefile"
    key = "eks/cluster_name/statefile"
    region = "ap-south-1"
  }
} 
