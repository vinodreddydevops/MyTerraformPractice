provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}


resource "aws_instance" "instance" {
    count = var.instance_count
    ami = var.image_id
    instance_type = var.flavor
    key_name = var.key_name
    subnet_id = var.subnet_ids
    vpc_security_group_ids = var.vpc_security_group_ids_list
}