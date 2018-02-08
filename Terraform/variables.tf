########################
#DATA FILES
########################
variable "security_group_id" {
  default = ""
}

variable "create_lc" {
  description = "Whether to create launch configuration"
  default     = true
}

variable "create_asg" {
  description = "Whether to create autoscaling group"
  default     = true
}

variable "lc_name" {
  description = "Creates a unique name for launch configuration beginning with the specified prefix"
  default     = ""
}

variable "asg_name" {
  description = "Creates a unique name for autoscaling group beginning with the specified prefix"
  default     = ""
}

variable "launch_configuration" {
  description = "The name of the launch configuration to use (if it is created outside of this module)"
  default     = ""
}

# Launch configuration
variable "image_id" {
  description = "The EC2 image ID to launch"
}

variable "instance_type" {
  description = "The size of instance to launch"
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  default     = ""
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the launch configuration"
  type        = "list"
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  default     = false
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  default     = ""
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default."
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = "list"
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = "list"
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as 'Instance Store') volumes on the instance"
  type        = "list"
  default     = []
}

variable "spot_price" {
  description = "The price to use for reserving spot instances"
  default     = 0
}

variable "placement_tenancy" {
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'"
  default     = "default"
}

#########################
#VARAIABLES
#########################
variable "tf_s3_bucket" {
  default = ""
}

variable "jenkins_lc" {
  default = ""
}

variable "jenkins_state_file" {
  default = "jenkins_state_file"
}

variable "region" {
  default = ""
}

variable "subnets" {
  default = []
}

variable "subnet_id" {
  default = ""
}

variable "elb_subnets" {
  default = []
}

variable "ami_id" {
  default = ""
}

variable "efs_security_group" {
  default = []
}

variable "security_group" {
  default = ""
}

variable "private_key_path" {
  default = "/Users/corighose/Documents/aws/collinskeypair01.pem"
}

# EFS
variable "efs_port" {
  description = "Default port for EFS"
  default     = "2049"
}

variable "subnet_count" {
  description = "Number of subnets used to deploy EFS"
  default     = "3"
}

variable "subnet_ids" {
  default = []
}

variable "environment" {
  description = "The programming environment - poc, dev, uat, prod, etc."
  default     = ""
}

variable "customer_name" {
  description = "The customer unique name"
  default     = ""
}

variable "vpc_id" {
  default = ""
}

variable "name" {
  description = "description of the resources"
  default     = "name"
}

# Jenkins
variable "jenkins_web_port" {
  description = "Default port for Jenkins web services"
  default     = "8080"
}

variable "jenkins_jnlp_port" {
  description = "Default port for Jenkins JNLP slave agents"
  default     = "50000"
}

variable "jenkins_ext_web_port" {
  description = "Default external port for Jenkins web services"
  default     = "80"
}

variable "jenkins_ext_ssl_port" {
  description = "Default SSL port for Jenkins web services"
  default     = "443"
}

variable "jenkins_sg" {
  description = "Jenkins security group"
  default     = ""
}

variable "efs_sg" {
  description = "efs security group"
  default     = ""
}

# Jenkins ELB
variable "jenkins_elb" {
  description = "ELB for Jenkins service"
  default     = ""
}

variable "jenkins_elb_cookie_expiration_period" {
  description = "The time period after which the Jenkins session cookie should be considered stale, expressed in seconds."
  default     = ""
}

/*

# ASG

variable "max_size" {
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
}
*/

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = "list"
}

# ECS
variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  default     = ""
}

variable "ecs_task_family" {
  description = "A unique name for your task definition"
  default     = ""
}

variable "ecs_task_image" {
  description = "The specified Docker image to use"
  default     = ""
}

variable "ecs_task_network_mode" {
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, and host"
  default     = ""
}

variable "ecs_task_volume_name" {
  description = "The name of the volume. This name is referenced in the sourceVolume parameter of container definition in the mountPoints section"
  default     = ""
}

variable "ecs_task_volume_host_path" {
  description = "The path on the host container instance that is presented to the container. If not set, ECS will create a nonpersistent data volume that starts empty and is deleted after the task has finished"
  default     = ""
}

variable "ecs_task_container_path" {
  description = "The path on the container that is presented to the host container instance"
  default     = ""
}

variable "ecs_user_data_efs_mountpoint" {
  description = "EFS mount point on the ECS instance"
  default     = ""
}

variable "ecs_user_data_efs_owner" {
  description = "EFS mount point owner on the ECS instance"
  default     = ""
}

variable "ecs_lc_image_id" {
  description = "The AMI image ID for the ECS instance"
  default     = ""
}

variable "ecs_lc_instance_type" {
  description = "The EC2 instance type for the ECS instance"
  default     = ""
}

variable "ecs_lc_data_block_device_name" {
  description = "The name of the EBS data block device for the ECS instance"
  default     = ""
}

variable "ecs_lc_data_block_device_type" {
  description = "The type of the EBS data block device for the ECS instance"
  default     = ""
}

variable "ecs_lc_data_block_device_size" {
  description = "The size (GB) of the EBS data block device for the ECS instance"
  default     = ""
}

variable "ecs_lc_root_device_type" {
  description = "The type of the root block device for the ECS instance"
  default     = ""
}

variable "ecs_lc_root_device_size" {
  description = "The size of the root block device for the ECS instance"
  default     = ""
}

variable "ecs_asg_health_check_type" {
  description = "Controls how health checking is done (EC2 or ELB)"
  default     = ""
}

variable "ecs_asg_min_size" {
  description = "The minimum size of the auto scale group"
  default     = ""
}

variable "ecs_asg_max_size" {
  description = "The maximum size of the auto scale group"
  default     = ""
}

variable "ecs_asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  default     = ""
}

variable "ecs_asg_wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
  default     = ""
}

variable "ecs_task_name" {
  description = "A name for ecs task definition"
  default     = ""
}

variable "availability_zones" {
  description = "A list of subnet IDs to launch resources in"
  type        = "list"
  default     = []
}

### Cluster Scaling Policies

variable "asg_autoscaling_group_name" {
  default = "corighose.jenkins"
}

variable "scale_up_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity"
  default     = ""
}

variable "scale_up_estimated_instance_warmup" {
  description = "The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics"
  default     = ""
}

variable "scale_up_metric_aggregation_type" {
  description = "The aggregation type for the policy's metrics"
  default     = ""
}

variable "scale_up_policy_type" {
  description = "The policy type, either SimpleScaling or StepScaling"
  default     = ""
}

variable "scale_up_metric_interval_lower_bound" {
  description = " The lower bound for the difference between the alarm threshold and the CloudWatch metric"
  default     = ""
}

variable "scale_up_scaling_adjustment" {
  description = "The number of instances by which to scale"
  default     = ""
}

variable "scale_down_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity"
  default     = ""
}

variable "scale_down_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
  default     = ""
}

variable "scale_down_scaling_adjustment" {
  description = ""
  default     = "The percentage of instances by which to scale down"
}

# CloudWatch Alarms
variable "scale_up_alarm_metric_name" {
  description = "The name for the alarm's associated metric"
  default     = ""
}

variable "scale_up_alarm_namespace" {
  description = "The namespace for the alarm's associated metric"
  default     = ""
}

variable "scale_up_alarm_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold"
  default     = ""
}

variable "scale_up_alarm_statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  default     = ""
}

variable "scale_up_alarm_threshold" {
  description = "The value against which the specified statistic is compared"
  default     = ""
}

variable "scale_up_alarm_period" {
  description = "The period in seconds over which the specified statistic is applied"
  default     = ""
}

variable "scale_up_alarm_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  default     = ""
}

variable "scale_up_alarm_treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points"
  default     = ""
}

variable "scale_down_alarm_metric_name" {
  description = "The name for the alarm's associated metric"
  default     = ""
}

variable "scale_down_alarm_namespace" {
  description = "The namespace for the alarm's associated metric"
  default     = ""
}

variable "scale_down_alarm_comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold"
  default     = ""
}

variable "scale_down_alarm_statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  default     = ""
}

variable "scale_down_alarm_threshold" {
  description = "The value against which the specified statistic is compared"
  default     = ""
}

variable "scale_down_alarm_period" {
  description = "The period in seconds over which the specified statistic is applied"
  default     = ""
}

variable "scale_down_alarm_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  default     = ""
}

variable "scale_down_alarm_treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points"
  default     = ""
}
