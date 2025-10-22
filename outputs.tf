output "wiz_connector_arn" {
  description = "The ARN of the IAM role created for the Wiz AWS connector."
  value       = module.wiz.role_arn
}
