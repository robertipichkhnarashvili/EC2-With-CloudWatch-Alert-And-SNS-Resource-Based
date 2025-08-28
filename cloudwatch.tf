# Creating Cloudwatch metric alarm

resource "aws_cloudwatch_metric_alarm" "cloudwatch" {
  alarm_name = "terraform-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  period = 60
  statistic = "Average"
  namespace = "AWS/EC2"
  threshold = var.default_CPU_treshold
  alarm_description = "This metric monitors EC2's CPU Utilization"

# Connecting SNS to cloudwatch
  alarm_actions = [aws_sns_topic.sns_cloudwatch.arn]
  dimensions = {
    InstanceId = aws_instance.my_instance.id
}
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.cloudwatch.alarm_name
}