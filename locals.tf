locals {
   Name = "${var.project_name}-${var.environment}"
   azs= slice(data.aws_availability_zones.name.names,0,2)
}