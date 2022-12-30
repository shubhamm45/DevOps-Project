

terraform {
  backend "s3" {
    bucket = "euran-terraform-statefile"
    key = "eks/ngg_cluster_name/statefile"
    region = "ap-south-1"
  }
} 
