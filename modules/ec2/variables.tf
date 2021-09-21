variable "access_key" {
  type        = string
  description = "(optional) describe your variable"
  
}
variable "secret_key" {
  type        = string
  description = "(optional) describe your variable"
  
}
variable "region" {
  type        = string
  description = "(optional) describe your variable"
  default = "us-east-2"
}
variable "flavor" {
  type        = string
  description = "(optional) describe your variable"
  default = "t2.micro"
}
variable "image_id" {
  type        = string
  description = "(optional) describe your variable"
  default = "ami-00dfe2c7ce89a450b"
}

variable "key_name" {
  type = string
  default = "test"
}

variable "vpc_security_group_ids_list" {
  type        = list(string)
  default     = []
  description = "A list of security group IDs to associate with."
  sensitive   = true
}

variable "subnet_ids" {
  type        = string
  default     = null
  description = "VPC Subnet ID the instance is launched in."
  sensitive   = true
}


variable "instance_count" {
  type        = number
  description = "Number of instances to launch."
  default = 1
}

variable "name" {
  type = string
  description = "defining name of a instance"
  
}