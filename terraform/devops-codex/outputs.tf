output "canonical_user_id" {
  value = "${data.aws_canonical_user_id.current.id}"
}
output "billing_account_id" {
  value = "${data.aws_billing_service_account.main.id}"
}