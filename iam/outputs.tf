output "AWS Account ID" {
  value = "${aws_iam_role.dd_integration_role.arn}"
}

output "AWS Role Name" {
  value = "${aws_iam_role.dd_integration_role.name}"
}
