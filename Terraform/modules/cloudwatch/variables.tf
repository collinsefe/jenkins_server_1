# -------------
# Module Inputs
# -------------
variable "alarm_name" {
  description = "The descriptive name for the alarm"
  default     = ""
}

variable "alarm_description" {
  description = "The description for the alarm"
  default     = ""
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state"
  type        = "list"
  default     = []
}

variable "metric_name" {
  description = "The name for the alarm's associated metric"
  default     = ""
}

variable "namespace" {
  description = "The namespace for the alarm's associated metric"
  default     = ""
}

variable "comparison_operator" {
  description = "The namespace for the alarm's associated metric"
  default     = ""
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  default     = ""
}

variable "threshold" {
  description = "The value against which the specified statistic is compared"
  default     = ""
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied"
  default     = ""
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  default     = ""
}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points"
  default     = ""
}

variable "dimensions" {
  description = "The dimensions for the alarm's associated metric"
  default     = {}
}
