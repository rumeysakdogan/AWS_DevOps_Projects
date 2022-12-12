terraform {
  backend "s3" {
    bucket = "terra-state-vprofile-rd"
    key    = "terraform"
    region = "us-east-1"
  }
}