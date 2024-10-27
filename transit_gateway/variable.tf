
variable "transit_gateway_subnetIds" {
  type = list(string)
  default = []
}

variable "transit_gateway_id" {
  type = any
}
variable "transit_gateway_name" {
  type = string
}
variable "transit_gateway_vpc_id" {
  type = any
}

variable "transit_gateway_default_route_table_propagation" {
  type = bool
  default = true
}

variable "transit_gateway_default_route_table_association" {
  type = bool
  default = true 
}

variable "transit_gateway_tags" {
  type= map(string)
  default = {
    Terraform = "ManagedBy"
  }
}

variable "attach_transit_gateway" {
  default = false
  type = bool
}

variable "route_table_id" {
  type = list(string)
  default = []
}

variable "update_route_table" {
}