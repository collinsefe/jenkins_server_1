#########################
#CUSTOMER INPUT
#########################
	
private_key_path 	      =   "/Users/corighose/Documents/aws/collinskeypair01.pem"
jenkins_state_file	    = 	"tf_jenkins.tfstate"
tf_s3_bucket 		        =	  "tf-state-collinsefe-jenkins-dev"
subnet_id 			        = 	"subnet-94d288dd"
subnet_ids			        =	  ["subnet-94d288dd", "subnet-b3f06ce8"]
subnets				          =	  ["subnet-94d288dd", "subnet-b3f06ce8"]
vpc_id                  = 	"vpc-5194b536"
customer_name				    =	  "collinsefe"
environment			        =	  "dev"
region                  =   "eu-west-1"
key_name                =   "collinskeypair01"
availability_zones      =   ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
iam_instance_profile    =   "${aws_iam_instance_profile.jenkins_ecs_instance_profile.name}"


security_groups       	= 	  ["${aws_security_group.jenkins_sg.id}"]
security_group         	= 	  "${aws_security_group.jenkins_sg.id}"





#############
# EFS
#############
efs_port               = "2049"
efs_sg                 = "aws_security_group.efs_sg.id"
efs_vpc_cidr           = "vpc_cidr"
efs_vpc_id             = "vpc_id"


################
# Jenkins ELB
################
jenkins_elb                              =    "jenkins-elb"
jenkins_elb_cookie_expiration_period     =    "3600"
elb_security_group                       =    "elb_sg"
subnet_count          	                 = 	  "2"
security_group_id                        =    "aws_security_group.jenkins_sg.id"
elb_subnets                              =    ["${aws_security_group.jenkins_sg.id}"]
environment           	                 = 	  "dev"


##################
# ECS
##################
jenkins_web_port		    =	"80"
ecs_cluster_name		    = "its-jenkins"


# ECS - task
ecs_task_family           = "jenkins-master"
ecs_task_network_mode     = "bridge"
ecs_task_volume_name      = "data-volume"
ecs_task_volume_host_path = "/data/"
# ecs_task_image          = "jenkinsci/jnlp-slave"
ecs_task_container_path   = "/var/jenkins_home"

# ECS - template for user_data
ecs_user_data_efs_mountpoint = "/data"
ecs_user_data_efs_owner      = "1000"

# ECS - launch configuration
lc_name                     = "ecs_lc"
ecs_lc_image_id             = "ami-4cbe0935"
ami_id                      = "ami-4cbe0935"
image_id                    = "ami-4cbe0935"
ecs_task_image              = "ticketfly/jenkins-example-aws-ecs"
ecs_lc_instance_type        = "t2.medium"
instance_type               = "t2.medium"

ecs_lc_data_block_device_name = "/dev/xvdz"
ecs_lc_data_block_device_type = "gp2"
ecs_lc_data_block_device_size = "24"

ecs_lc_root_device_type       = "gp2"
ecs_lc_root_device_size       = "12"

# ECS - auto scaling group
ecs_asg_health_check_type         = "EC2"
ecs_asg_min_size                  = "1"
ecs_asg_max_size                  = "5"
ecs_asg_desired_capacity          = "1"
ecs_asg_wait_for_capacity_timeout = "0"


# asg
create_asg                      = "true"
health_check_type               = "EC2"
min_size                        = "1"
max_size                        = "5"
desired_capacity                = "1"
wait_for_capacity_timeout       = "0"
#vpc_zone_identifier             =  ["subnet-94d288dd", "subnet-b3f06ce8"]
asg_name                        =   "jenkins_asg"

#root_block_device             

#ebs_block_device
vpc_zone_identifier            = ["${split(",",var.subnet_ids)}"]




# Auto scaling group

  
#vpc_zone_identifier       =  ["{vpc_private_subnets}", "{vpc_public_subnets}"]
  health_check_type         =   "${var.ecs_asg_health_check_type}"
  min_size                  =   "${var.ecs_asg_min_size}"
  max_size                  =   "${var.ecs_asg_max_size}"
  desired_capacity          =   "${var.ecs_asg_desired_capacity}"
  wait_for_capacity_timeout =   "${var.ecs_asg_wait_for_capacity_timeout}"



# Cluster Scaling Policies
scale_up_adjustment_type             = "ChangeInCapacity"
scale_up_estimated_instance_warmup   = "60"
scale_up_metric_aggregation_type     = "Average"
scale_up_policy_type                 = "StepScaling"
scale_up_metric_interval_lower_bound = "0"
scale_up_scaling_adjustment          = "2"

scale_down_adjustment_type          = "PercentChangeInCapacity"
scale_down_cooldown                 = "120"
scale_down_scaling_adjustment       = "-50"

# CloudWatch Alarms
scale_up_alarm_metric_name         = "CPUReservation"
scale_up_alarm_namespace           = "ECS"
scale_up_alarm_comparison_operator = "GreaterThanOrEqualToThreshold"
scale_up_alarm_statistic           = "Maximum"
scale_up_alarm_threshold           = "20"
scale_up_alarm_period              = "30"
scale_up_alarm_evaluation_periods  = "1"
scale_up_alarm_treat_missing_data  = "notBreaching"

scale_down_alarm_metric_name         = "CPUReservation"
scale_down_alarm_namespace           = "ECS"
scale_down_alarm_comparison_operator = "LessThanThreshold"
scale_down_alarm_statistic           = "Maximum"
scale_down_alarm_threshold           = "50"
scale_down_alarm_period              = "120"
scale_down_alarm_evaluation_periods  = "1"
scale_down_alarm_treat_missing_data  = "notBreaching"
