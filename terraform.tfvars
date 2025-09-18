
env_name = "Amarjeet-tf-env"
region = "ap-south-1"
############## VPC ####################
vpc_cidr = "10.0.1.0/24"
enable_dns_hostnames = true
enable_dns_support = true

############## SUBNET #################

subnets = {
     public_subnet = {
         subnet_type = "public"
         cidr = "10.0.1.0/28"
         az = "ap-south-1a"
         ec2_key_key = "ec2-pub-01-key"
     }
     private_subnet = {
         subnet_type = "private"
         cidr = "10.0.2.0/28"
         az = "ap-south-1b"
         ec2_key_key = "ec2-pvt-01-key"
     }
}

############## igw, eip & NAT #################ss


pub_subnet = {
  "pub_subnet-01" = "public_subnet"
}

############## route & route table #################

route = {
     pub_route-01 = {
         routes = {
                 route-01= {
                     cidr_block = "10.0.2.0/24"
                     gateway_type = "igw"
                     target = "public_subnet"
                     }
         }
     }
     pvt_route-01 = {
         routes = {
                 route-01 = {
                     cidr_block = "10.0.2.0/24"
                     gateway_type = "nat"
                     target = "pub_subnet-01"  
                 }
         }
     }
}

rt_association = {
     pub_rt_association = {
         subnet_key      = "public_subnet"
         route_table_key = "pub_route-01"
     }
     pvt_rt_association = {
         subnet_key      = "private_subnet"
         route_table_key = "pvt_route-01"
     }
}

ingress_cidr = ["0.0.0.0/0"]
egress_cidr = [ "0.0.0.0/0" ]

ec2_key = {
    ec2-pub-01-key = {
        key_name = "ec2-pub-01-key.pem"
        path     = "ec2-pub-01-key.pem"
    }
    ec2-pvt-01-key = {
        key_name = "ec2-pvt-01-key.pem"
        path     = "ec2-pub-01-key.pem"
    }
}

ami = "ami-123456789"
instance_type = "t2.micro"