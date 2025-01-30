variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames"{
    default = true
}
variable "common_tags" {
  default = {}
}
variable "vpc_tags" {
    default = {}
}

variable "project_name" {
  default = {}
}

variable "environment" {
  default = {}
}

variable "gateway_tags" {
  default = {}
}

variable "public_subnet_cidr"{
    type = list

validation {
  condition = length(var.public_subnet_cidr)== 2 
  error_message = "please give 2 valid subnet cidrs"
}

}

variable "private_subnet_cidr" {
    type = list 

    validation {
      condition = length(var.private_subnet_cidr) == 2
      error_message = "please enter two valid subnet cidrs"
    }
}

variable "database_subnet_cidr" {
    type = list 
    validation {
        condition = length(var.database_subnet_cidr) == 2
        error_message = "please enter the correctly two cidr blocks"
    }
}

variable "aws_nat_gateway_tags" {
  default = {}
}

variable "public_route_table" {
  default = {}
}
variable "private_route_table" {
  default = {}
}
variable "database_route_table" {
  default = {}
}

variable "is_peering_required"{
    type = bool 
    default = false
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
}

variable "vpc_peering_tags"{
    default = {}
}