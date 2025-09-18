############################# VPC ##################################

resource aws_vpc "vpc" {
     cidr_block = var.vpc_cidr
     enable_dns_hostnames = var.enable_dns_hostnames
     enable_dns_support = var.enable_dns_support
     tags={
         Name = "vpc-${var.env_name}"
     }
}

############################## SUBNET ################################

#when we want to create multiple subnet with resource block we will have to use for_each or count method.

## Using for_each
resource aws_subnet "subnet" {
    vpc_id = aws_vpc.vpc.id
    for_each = var.subnets
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = each.value.subnet_type == "public" ? true : false
    tags = {
        Name = "sg-${var.env_name}-${each.key}"
    }
}

###################################  IGW ###########################

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc.id
    tags ={
        Name = "igw-${var.env_name}"
    }
}

################################### eip & NAT ####################################

resource "aws_eip" "eip"{
    domain = "vpc"
    tags ={
        Name = "eip-${var.env_name}"
    }
}

resource "aws_nat_gateway" "nat" {
     allocation_id = aws_eip.eip.id
     for_each = var.pub_subnet
     subnet_id = aws_subnet.subnet[each.value].id
     tags ={
        Name = "nat-${var.env_name}-${each.key}"
    }
}


################################### Route Table and Route ###################################

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id
    for_each = var.route
    dynamic "route" {
         for_each = each.value.routes
             content {
                 cidr_block = route.value.cidr_block
                 gateway_id = route.value.gateway_type == "igw" ? aws_internet_gateway.igw.id : null
                 nat_gateway_id = route.value.gateway_type == "nat" ? aws_nat_gateway.nat[route.value.target].id : null
                 }
     }
     tags ={
        Name = "rt-${var.env_name}-${each.key}"
    }
}


resource "aws_route_table_association" "rt_association" {
    for_each = var.rt_association
    subnet_id = aws_subnet.subnet[each.value.subnet_key].id
    route_table_id = aws_route_table.route_table[each.value.route_table_key].id
}

####################################### sg #################################

resource "aws_security_group" "aws_sg" {
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.ingress_cidr
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "-1"
        cidr_blocks = var.egress_cidr      
    }
  
}

resource "aws_key_pair" "ec2-key" {
    for_each = var.ec2_key
    key_name   = each.value.key_name
    public_key = file(each.value.path)
}
####################################### EC2 #################################

## Using for_each
resource aws_instance "EC2"{
    for_each = var.subnets
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.subnet[each.key].id
    key_name = aws_key_pair.ec2-key[each.value.ec2_key_key].key_name
    vpc_security_group_ids = [aws_security_group.aws_sg.id]
    tags= {
        Name = "ec2-${var.env_name}-${each.key}"
    }
}
