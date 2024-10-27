resource "aws_flow_log" "flowlog" {
  count = var.enable_flow_log ? 1: 0
  iam_role_arn          = var.flowlog_role_arn
  log_destination       = var.flowlog_log_destination
  log_destination_type  = var.flowlog_log_destination_type
  traffic_type          = var.flowlog_traffic_type
  vpc_id                = var.vpc_id
  tags                  = var.flowlog_tags
}

output "flowlog_id" {
  value = aws_flow_log.flowlog.*.id
}
output "flowlog_arn" {
  value = aws_flow_log.flowlog.*.arn
}
# data "aws_iam_policy_document" "flow_log_s3" {
#   statement {
#     sid = "AWSLogDeliveryWrite"

#     principals {
#       type        = "Service"
#       identifiers = ["delivery.logs.amazonaws.com"]
#     }

#     actions = ["s3:PutObject"]

#     resources = ["arn:aws:s3:::${local.s3_bucket_name}/AWSLogs/*"]
#   }

#   statement {
#     sid = "AWSLogDeliveryAclCheck"

#     principals {
#       type        = "Service"
#       identifiers = ["delivery.logs.amazonaws.com"]
#     }

#     actions = ["s3:GetBucketAcl"]

#     resources = ["arn:aws:s3:::${local.s3_bucket_name}"]
#   }
# }