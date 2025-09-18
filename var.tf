variable "env_name" {
     type = string
}

variable "region" {
     type = string
}
############## VPC ####################

variable "vpc_cidr" {
     type = string
}

variable "enable_dns_hostnames" {
     type = bool
}

variable "enable_dns_support" {
     type = bool
  
}

############## SUBNET #################

variable subnets {
    type = map(object(
        {
            subnet_type = string
            cidr = string
            az = string
            ec2_key_key = string
        }
    ))
}

############## igw, eip & NAT #################


variable "pub_subnet"{
    type = map(string)
}

############## route & route table #################

variable "route" {
    type = map(object({
         routes = map(object({
             cidr_block = string
             gateway_type = string
             target = string 
         })) 
     }))
}

variable "rt_association" {
    type = map(object({
      subnet_key = string
      route_table_key = string
    }))
}

variable "ingress_cidr" {
    type = list(string)
  
}

variable "egress_cidr" {
    type = list(string)
  
}

variable "ec2_key" {
     description = "key of ec2"
     type = map(object ({
          key_name = string
          path = string
     }))
}

variable "ami" {
     type = string
}

variable "instance_type" {
     type = string
}