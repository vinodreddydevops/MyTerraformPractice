provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_instance" "Testvm" {
    ami = var.image_id
    instance_type = var.flavor
  
}