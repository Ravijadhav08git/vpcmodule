variable "subnet_ids" {}
variable "security_groups_vpn" {}
variable "vpnClientName" {
    type = string
    default = "VPNConnection"
}

variable "vpn_client_cidr_block" {
    description = "CIDR for client to assign"
    type = string
    default = "20.0.0.0/16"
}

variable "vpn_server_certificate_arn" {
    type = string
}

variable "vpc_user_certificate_arn" {
   type = string
}

variable "create_client_vpn_endpoint" {
    type = bool
    default = true
}