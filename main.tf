resource "aws_vpc" "name" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = "${local.Name}-vpc"
        }
        )
     
  
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.name.id

  tags = merge(var.common_tags,var.gateway_tags,{
   Name = local.Name
  })
}

resource "aws_subnet" "snet" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.name.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = true

    tags = merge(var.common_tags,var.gateway_tags,{
        Name = "${local.Name}-public- ${local.azs[count.index]}"
    })

}


resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.name.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]


  tags = merge(var.common_tags,var.gateway_tags,{
    Name = "${local.Name}-private- ${local.azs[count.index]}"
  })
}

resource "aws_subnet" "database_subnet" {
    count = length(var.database_subnet_cidr)
    vpc_id = aws_vpc.name.id
    cidr_block = var.database_subnet_cidr[count.index]
    availability_zone = local.azs[count.index]

    tags = merge(var.common_tags,var.gateway_tags,{
        Name = "${local.Name}-database-${local.azs[count.index]}"
    })
}


resource "aws_eip" "elastic_ip" {  #creation of elastic ip 
    domain = "vpc"

}

#creation of the natgateway

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.snet[0].id

    tags  = merge(var.common_tags,var.aws_nat_gateway_tags,{
        Name = local.Name
    })

    depends_on = [ aws_internet_gateway.ig ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id 

  tags = merge(var.common_tags,var.public_route_table,{
    Name = "${local.Name}-public"
  })
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id 

  tags = merge(var.common_tags,var.private_route_table,{
    Name = "${local.Name}-private"
  })
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.name.id 

  tags = merge(var.common_tags,var.database_route_table,{
    Name = "${local.Name}-database"
  })
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id 
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id

}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block =  "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id 
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.snet[*].id,count.index)
  route_table_id= aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
  subnet_id = element(aws_subnet.private_subnet[*].id,count.index)
  route_table_id= aws_route_table.private.id
}


resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidr)
  subnet_id = element(aws_subnet.database_subnet[*].id,count.index)
  route_table_id= aws_route_table.database.id
}
