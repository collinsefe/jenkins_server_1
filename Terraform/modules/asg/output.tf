# Launch configuration

output "jenkins_lc_name" {
  description = "The name of the launch configuration"
  value       = "${aws_launch_configuration.jenkins_lc.name}"
}

output "jenkins_asg_name" {
  description = "The autoscaling group name"
  value       = "${aws_autoscaling_group.jenkins_asg.name}"
}

/*

output "jenkins_lc_launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = "${var.launch_configuration == "" && var.create_lc ? element(concat(aws_launch_configuration.jenkins_lc.*.id, list("")), 0) : var.launch_configuration}"
}

# Autoscaling group
output "jenkins_asg_id" {
  description = "The autoscaling group id"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.id, list("")), 0)}"
}


output "jenkins_asg_min_size" {
  description = "The minimum size of the autoscale group"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.min_size, list("")), 0)}"
}

output "jenkins_asg_max_size" {
  description = "The maximum size of the autoscale group"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.max_size, list("")), 0)}"
}

output "jenkins_asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.desired_capacity, list("")), 0)}"
}

output "jenkins_asg_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.default_cooldown, list("")), 0)}"
}

output "jenkins_asg_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.health_check_grace_period, list("")), 0)}"
}

output "jenkins_asg_health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done"
  value       = "${element(concat(aws_autoscaling_group.jenkins_asg.health_check_type, list("")), 0)}"
}
*/


//output "this_vpc_zone_identifier" {
//  description = "The VPC zone identifier"
//  value       = "${element(concat(aws_autoscaling_group.this.vpc_zone_identifier, list("")), 0)}"
//}
//
//output "this_load_balancers" {
//  description = "The load balancer names associated with the autoscaling group"
//  value       = "${aws_autoscaling_group.this.load_balancers}"
//}
//
//output "this_target_group_arns" {
//  description = "List of Target Group ARNs that apply to this AutoScaling Group"
//  value       = "${aws_autoscaling_group.this.target_group_arns}"
//}

