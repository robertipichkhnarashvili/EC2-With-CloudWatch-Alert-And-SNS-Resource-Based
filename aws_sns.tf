resource "aws_sns_topic" "sns_cloudwatch" {
  name = "cloudwatch_alerts_CPU"
}
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.sns_cloudwatch.arn
  protocol = "email"
  for_each = toset(var.emails)
  endpoint = each.value
}
output "sns_topic_arn" {
  value = aws_sns_topic.sns_cloudwatch.arn
}