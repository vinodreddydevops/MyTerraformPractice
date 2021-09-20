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
}
variable "flavor" {
  type        = string
  description = "(optional) describe your variable"
}
variable "image_id" {
  type        = string
  description = "(optional) describe your variable"
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