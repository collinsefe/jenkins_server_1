# --------------
# Module Outputs
# --------------
output "cloudwatch_metric_alarm_id" {
  description = "The ID of the health check"
  value       = "${aws_cloudwatch_metric_alarm.jenkins_scale_down_alarm.id}"
}
