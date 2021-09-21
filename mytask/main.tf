provider "aws" {
    region = var.region
}

module "customvpc" {
    source = "../modules/myvpc"
}

module "wordpress_instance" {
    source = "../modules/ec2"
    vpc_security_group_ids_list = [module.customvpc.Public_SG_id]
    subnet_ids = module.customvpc.public_subnet_id
    name = "wordpress_instance"

}

module "database_instance" {
    source = "../modules/ec2"
    vpc_security_group_ids_list = [module.customvpc.Private_SG_id]
    subnet_ids = module.customvpc.private_subnet_id[0]
    name = "database_instance"
}

resource "aws_ami_from_instance" "myworpress_image" {
    name = "myworpress_image"
    source_instance_id = module.wordpress_instance.instance_id
  
}

resource "aws_lb" "myelb" {
    name = "myapp-elb"
    internal = false
    load_balancer_type = "application"
    security_groups = [module.customvpc.Public_SG_id]
    subnets = [module.customvpc.public_subnet_id]
    enable_deletion_protection = true 
}

