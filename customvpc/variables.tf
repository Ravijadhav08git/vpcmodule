variable "vpc_name" {
  type= string
}

variable "vpc_cidr" {
  type= string
}

variable "vpc_create" {
  type = bool
  default = true
}
variable "vpc_default_enable_dns_support" {
  type = bool
  default = true
}
variable "vpc_enable_dns_hostnames" {
  type = bool
  default = true
}
variable "vpc_enable_nat_gateway" {
  type = bool
  default = true
}

variable "vpc_enable_vpn_gateway" {
  type = bool
  default = false
}

variable "vpc_single_nat_gateway" {
  type = bool
  default = true
}

variable "vpc_one_nat_gateway_per_az" {
  type = bool
  default = false
}
variable "vpc_create_database_subnet_group" {
  type = bool
  default = false
}
variable "vpc_create_database_subnet_route_table" {
  type = bool
  default = false
}

variable "vpc_azs" {
  type = list(string)
}

variable "vpc_private_subnets" {
  type = list(string)
  default = []
}
variable "vpc_public_subnets" {
  type = list(string)
  default = []
}
variable "vpc_database_subnets" {
  type = list(string)
  default = []
}
variable "vpc_public_subnet_tags" {
  type= map(string)
  default = {
    Terraform = "true"
  }
}
variable "vpc_private_subnet_tags" {
  type= map(string)
   default = {
    Terraform = "true"
  }
}

variable "vpc_tags" {
  type= map(string)
  description = "VPC tags"
  default = {
    Terraform = "true"
  }
}
variable "vpc_tags_all" {
  description = "A map of tags to add to all resources"
  type = map(string)
   default = {
    Terraform = "true"
  }
}
variable "vpc_public_route_table_tags" {
  type = map(string)
   default = {
    Terraform = "true"
  }
}

variable "vpc_private_route_table_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "vpc_database_route_table_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "vpc_nat_gateway_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "vpc_nat_eip_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "vpc_igw_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "vpc_default_vpc_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }  
}

variable "vpc_default_security_group_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }    
}

variable "vpc_database_subnet_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }     
}
variable "vpc_database_subnet_group_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }   
}

variable "vpc_default_route_table_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }   
}

variable "vpc_default_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }   
}

variable "vpc_instance_tenancy" {
  type = string
  default = "default"
}

variable "vpc_enable_dns_support" {
  type = bool
  default = true
}

variable "vpc_enable_classiclink" {
  type = bool
  default = false 
}

variable "vpc_enable_ipv6" {
  type = bool
  default = false
}

variable "vpc_create_igw" {
   type = bool
   default = true
}

variable "vpc_private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "vpc_database_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "db"
}

variable "vpc_create_database_internet_gateway_route" {
  description = "Controls if an internet gateway route for public database access should be created"
  type        = bool
  default     = false
}

variable "vpc_create_database_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the database subnets"
  type        = bool
  default     = false
}


variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on public subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}
variable "assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = false
}
variable "public_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}
variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on private subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

variable "private_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "database_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on database subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

variable "database_subnet_ipv6_prefixes" {
  description = "Assigns IPv6 database subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "vpc_enable_classiclink_dns_support" {
  description = "Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = null
}

variable "external_nat_ips" {
  description = "List of EIPs to be used for `nat_public_ips` output (used in combination with reuse_nat_ips and external_nat_ip_ids)"
  type        = list(string)
  default     = []
}

variable "lambda_content_handling" {
  type = string
  default = ""
}
