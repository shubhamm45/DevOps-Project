terraform {
  backend "s3" {
    bucket = "euran-terraform-statefile"
    key = "/SERVER_NAME/statefile"
    region = "ap-south-1"
  }
}  
