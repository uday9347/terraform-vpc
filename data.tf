data "aws_availability_zones" "name" {
#   
    state = "available"
}

data "aws_vpc" "def" {
    default = true
}

data "aws_route_table" "default" {
    vpc_id = data.aws_vpc.def.id 
    # filter {
    #     name = "association.main"
    #     values = ["true"]
    # }

}