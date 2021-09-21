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

variable "Public_SG" {
  type = map(object(
    {
      from = number
      to = number
      protocol = string
    }
  ))
  default = {
    http = {from=80, to=80, protocol="tcp"}
    ssh = {from = 22, to=22, protocol="tcp"}
  }
  description = "Wordpress port exposing"
}

variable "Private_SG" {
  type = map(object(
    {
      from = number
      to = number
      protocol = string
    }
  ))
  default = {
    mysql = {from=3306, to=3306, protocol="tcp"}
    ssh = {from = 22, to=22, protocol="tcp"}
  }
  description = "database port exposing list"
}