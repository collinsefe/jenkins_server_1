# ----------------
# Cloudwatch Alarm
# ----------------
resource "aws_cloudwatch_metric_alarm" "jenkins_scale_down_alarm" {
  alarm_name        = "${var.alarm_name}"
  alarm_description = "${var.alarm_description}"

  alarm_actions = ["${var.alarm_actions}"]

  metric_name         = "${var.metric_name}"
  namespace           = "${var.namespace}"
  comparison_operator = "${var.comparison_operator}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"
  period              = "${var.period}"
  evaluation_periods  = "${var.evaluation_periods}"
  treat_missing_data  = "${var.treat_missing_data}"

  dimensions = "${var.dimensions}"
}

resource "aws_cloudwatch_metric_alarm" "jenkins_scale_up_alarm" {
  alarm_name        = "${var.alarm_name}"
  alarm_description = "${var.alarm_description}"

  alarm_actions = ["${var.alarm_actions}"]

  metric_name         = "${var.metric_name}"
  namespace           = "${var.namespace}"
  comparison_operator = "${var.comparison_operator}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"
  period              = "${var.period}"
  evaluation_periods  = "${var.evaluation_periods}"
  treat_missing_data  = "${var.treat_missing_data}"

  dimensions = "${var.dimensions}"
}
