output "azs"{
    value = slice(data.aws_availability_zones.name.names,0,2)
}

