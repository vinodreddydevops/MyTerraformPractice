provider "aws" {
    region = var.region
}

module "customvpc" {
    source = "../modules/myvpc"
}

module "wordpress_instance" {
    source = "../modules/ec2"
    instance_count = 3
    vpc_security_group_ids_list = [module.customvpc.Public_SG_id]
    subnet_ids = module.customvpc.public_subnet_id

}

module "database_instance" {
    source = "../modules/ec2"
    instance_count = 3
    vpc_security_group_ids_list = [module.customvpc.Private_SG_id]
    subnet_ids = module.customvpc.private_subnet_id[0]
}