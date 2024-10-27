variable "flowlog_role_arn" {
  type = string
  default = ""
}
variable "flowlog_log_destination" {
  type = string
  default = ""
}
variable "flowlog_log_destination_type" {
  type = string
  default = "cloud-watch-logs"
}
variable "flowlog_traffic_type" {
  type = string
  default = "ALL"
}
variable "vpc_id" {
  type = string
  default = ""
}
variable "enable_flow_log"{
  type = bool
  default = true
}
variable "flowlog_tags" {
  type = map(string)
  default = {
    "Terraform" = "true"
  }
}