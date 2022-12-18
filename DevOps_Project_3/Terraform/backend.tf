terraform {
  backend "s3" {
    bucket = "euran-terraform-statefile"
    key = "eks/${var.cluster_name}statefile"
    region = "ap-south-1"
  }
} 
