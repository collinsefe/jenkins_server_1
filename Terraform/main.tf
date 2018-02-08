##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = "eu-west-1"
}

# -------------------
# Jenkins ECS Cluster
# -------------------

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}

# ------------------------------
# Jenkins Master Task Definition
# ------------------------------
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family       = "${var.ecs_task_family}"
  network_mode = "${var.ecs_task_network_mode}"

  volume {
    name      = "${var.ecs_task_volume_name}"
    host_path = "${var.ecs_task_volume_host_path}"
  }

  container_definitions = <<EOF
[
  {
    "name": "${var.ecs_task_family}",
    "image": "${var.ecs_task_image}",
    "mountPoints": [
      {
        "sourceVolume": "${var.ecs_task_volume_name}",
        "containerPath": "${var.ecs_task_container_path}"
      }
    ],
      
    "essential": true,
    "cpu": 1024,
    "memory": 992,
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 8080,
        "protocol": "tcp"
      },
      {
        "hostPort": 50000,
        "containerPort": 50000,
        "protocol": "tcp"
      },
       {
        "hostPort": 80,
        "containerPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
}

############################
# SECURITY GROUPS#
############################

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Jenkins Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    cidr_blocks = ["10.0.0.0/8"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    cidr_blocks = ["10.0.0.0/8"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = "50000"
    to_port     = "50000"
    cidr_blocks = ["10.0.0.0/8"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    cidr_blocks = ["10.0.0.0/8"]
    protocol    = "tcp"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = ["10.0.0.0/8"]
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "jenkins-sg"
    Author      = "corighose"
    Environment = "dev"
  }
}

##########################
# EC2 INSTANCE
##########################

resource "aws_instance" "jenkins_server" {
  ami                  = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  user_data            = "${var.user_data}"
  subnet_id            = "${var.subnet_id}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.jenkins_sg.id}"]
  iam_instance_profile = "${module.jenkins_ec2_instance.jenkins_ec2_instance_profile_name}"

  connection {
    user        = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    file_name   = "${var.file_name}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name                   = "jenkins-server"
    Author                 = "corighose"
    Environment            = "dev"
    Termination_protection = "false"
  }
}

# --------------------------
# IAM - EC2 Instance Profile
# --------------------------
module "jenkins_ec2_instance" {
  source = "modules/ec2-profile"
}

#############
# LOAD BALANCER 
#############
module "jenkins_elb" {
  source = "modules/jenkins-elb"

  vpc_id              = "${var.vpc_id}"
  subnet_ids          = ["${var.subnet_ids}"]
  elb_subnets         = ["${var.subnet_ids}"]
  elb_security_groups = ["${var.security_groups}"]
  int_web_port        = "${var.jenkins_web_port}"
  ext_web_port        = "${var.jenkins_ext_web_port}"
  ext_ssl_port        = "${var.jenkins_ext_ssl_port}"

  elb_cookie_expiration_period = "${var.jenkins_elb_cookie_expiration_period}"
}

###############
# S3 BUCKET
###############
/*
  access_logs {
    bucket              = "tf-state-dcuk074-jenkins-dev"
    bucket_prefix       = "tf-state-dcuk074-elb-access"
    interval            = 60
  }

*/

# ----------------------
# IAM - ECS Service Role
# ----------------------

/*
  This should be its own module. But I need to reference a resource in order
  to prevent a potential race condition during ECS service deletion. See this
  NOTE:

    To prevent a race condition during service deletion, make sure to set 
    depends_on to the related aws_iam_role_policy; otherwise, the policy may be 
    destroyed too soon and the ECS service will then get stuck in the DRAINING 
    state.

*/

# ----------------
# ECS Service Role
# ----------------
resource "aws_iam_role" "jenkins_ecs_role" {
  name = "jenkins-ecs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# -----------------------
# ECS Service Role Policy
# -----------------------
resource "aws_iam_role_policy" "jenkins_ecs_policy" {
  name = "jenkins-ecs-policy"
  role = "${aws_iam_role.jenkins_ecs_role.id}"

  #policy = "${data.template_file.ecs_assume_policy.rendered}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "ec2:Describe*",
            "ec2:AuthorizeSecurityGroupIngress"
          ],      
          "Resource": "*"
      }
  ]
}
EOF
}

########################
# Jenkins ECS Service
########################
resource "aws_ecs_service" "jenkins_ecs_service" {
  name            = "${var.ecs_cluster_name}"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
  desired_count   = "1"
  iam_role        = "${aws_iam_role.jenkins_ecs_role.arn}"
  depends_on      = ["aws_iam_role_policy.jenkins_ecs_policy"]

  load_balancer {
    elb_name       = "${module.jenkins_elb.jenkins_elb_name}"
    container_name = "${var.ecs_task_family}"
    container_port = "${var.jenkins_web_port}"
  }
}

# ------------
# Auto Scaling
# ------------
data "template_file" "user_data_jenkins_ecs" {
  template = "${file("user_data_jenkins_ecs.sh")}"

  vars {
    ecs_cluster_name     = "${var.ecs_cluster_name}"
    efs_mountpoint       = "${var.ecs_user_data_efs_mountpoint}"
    aws_region           = "${var.region}"
    efs_filesystem_id    = "${module.efs.efs_filesystem_id}"
    efs_mountpoint_owner = "${var.ecs_user_data_efs_owner}"
  }
}

# ------------------
# EFS Security Group
# ------------------
module "efs_security_group" {
  source = "modules/efs-sg"

  customer_name = "${var.customer_name}"
  environment   = "${var.environment}"
  vpc_id        = "${var.vpc_id}"

  #vpc_cidr_block        = "${module.vpc.vpc_cidr_block}"
  efs_port = "${var.efs_port}"
}

# ---
# EFS
# ---
module "efs" {
  source = "modules/efs"

  customer_name   = "${var.customer_name}"
  environment     = "${var.environment}"
  vpc_id          = "${var.vpc_id}"
  subnet_ids      = "${var.subnet_ids}"
  subnet_count    = "${length(var.subnet_ids)}"
  security_groups = ["${module.efs_security_group.efs_security_group_id}"]
}

resource "aws_launch_configuration" "jenkins_lc" {
  name_prefix          = "lc_${var.ecs_cluster_name}-"
  image_id             = "${var.ecs_lc_image_id}"
  instance_type        = "${var.ecs_lc_instance_type}"
  iam_instance_profile = "${module.jenkins_ec2_instance.jenkins_ec2_instance_profile_name}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.jenkins_sg.id}"]

  #subnet_id             =  ["${var.subnet_ids}"]


  /*
    name                        = "jenkins-lconfig"
#  name_prefix                 = "${coalesce(var.lc_name, var.name)}-"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  placement_tenancy           = "${var.placement_tenancy}"
  ebs_optimized               = "${var.ebs_optimized}"
  ebs_block_device            = "${var.ebs_block_device}"
  ephemeral_block_device      = "${var.ephemeral_block_device}"
  root_block_device           = "${var.root_block_device}"
*/

  associate_public_ip_address = "false"

  #load_balancers = ["${module.jenkins_elb.jenkins_elb_id}"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# Auto scaling group

resource "aws_autoscaling_group" "jenkins_asg" {
  name                 = "jenkins-asg"
  launch_configuration = "${aws_launch_configuration.jenkins_lc.name}"
  availability_zones   = ["${var.availability_zones}"]
  vpc_zone_identifier  = ["${var.subnet_ids}"]

  #asg_name                  = "jenkins_asg"
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  health_check_type         = "${var.ecs_asg_health_check_type}"
  min_size                  = "${var.ecs_asg_min_size}"
  max_size                  = "${var.ecs_asg_max_size}"
  desired_capacity          = "${var.ecs_asg_desired_capacity}"
  wait_for_capacity_timeout = "${var.ecs_asg_wait_for_capacity_timeout}"

  tags = [
    {
      key                 = "Name"
      value               = "${var.customer_name}_asg"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
  ]
}

# -------------------------------
# Jenkins Cluster Scale Up Policy
# -------------------------------

resource "aws_autoscaling_policy" "jenkins_scale_up_policy" {
  name                      = "${var.customer_name}_jenkins_scale_up_policy"
  adjustment_type           = "${var.scale_up_adjustment_type}"
  autoscaling_group_name    = "${aws_autoscaling_group.jenkins_asg.id}"
  estimated_instance_warmup = "${var.scale_up_estimated_instance_warmup}"
  metric_aggregation_type   = "${var.scale_up_metric_aggregation_type}"
  policy_type               = "${var.scale_up_policy_type}"

  step_adjustment {
    metric_interval_lower_bound = "${var.scale_up_metric_interval_lower_bound}"
    scaling_adjustment          = "${var.scale_up_scaling_adjustment}"
  }
}

# ------------------------------
# Jenkins Cluster Scale Up Alarm
# ------------------------------
module "jenkins_scale_up_alarm" {
  source = "modules/cloudwatch"

  alarm_name        = "${var.customer_name}_jenkins_scale_up_alarm"
  alarm_description = "CPU utilization peaked at 70% during the last minute"
  alarm_actions     = ["${aws_autoscaling_policy.jenkins_scale_up_policy.arn}"]

  dimensions = {
    ClusterName = "${var.ecs_cluster_name}"
  }

  metric_name         = "${var.scale_up_alarm_metric_name}"
  namespace           = "${var.scale_up_alarm_namespace}"
  comparison_operator = "${var.scale_up_alarm_comparison_operator}"
  statistic           = "${var.scale_up_alarm_statistic}"
  threshold           = "${var.scale_up_alarm_threshold}"
  period              = "${var.scale_up_alarm_period}"
  evaluation_periods  = "${var.scale_up_alarm_evaluation_periods}"
  treat_missing_data  = "${var.scale_up_alarm_treat_missing_data}"
}

# ---------------------------------
# Jenkins Cluster Scale Down Policy
# ---------------------------------
resource "aws_autoscaling_policy" "jenkins_scale_down_policy" {
  name                   = "${var.customer_name}_jenkins_scale_down_policy"
  adjustment_type        = "${var.scale_down_adjustment_type}"
  autoscaling_group_name = "${aws_autoscaling_group.jenkins_asg.id}"
  cooldown               = "${var.scale_down_cooldown}"
  scaling_adjustment     = "${var.scale_down_scaling_adjustment}"
}

# --------------------------------
# Jenkins Cluster Scale Down Alarm
# --------------------------------

module "jenkins_scale_down_alarm" {
  source = "modules/cloudwatch"

  alarm_name        = "${var.customer_name}_jenkins_scale_down_alarm"
  alarm_description = "CPU utilization is under 50% for the last 10 min..."
  alarm_actions     = ["${aws_autoscaling_policy.jenkins_scale_down_policy.arn}"]

  dimensions = {
    ClusterName = "${var.ecs_cluster_name}"
  }

  metric_name         = "${var.scale_down_alarm_metric_name}"
  namespace           = "${var.scale_down_alarm_namespace}"
  comparison_operator = "${var.scale_down_alarm_comparison_operator}"
  statistic           = "${var.scale_down_alarm_statistic}"
  threshold           = "${var.scale_down_alarm_threshold}"
  period              = "${var.scale_down_alarm_period}"
  evaluation_periods  = "${var.scale_down_alarm_evaluation_periods}"
  treat_missing_data  = "${var.scale_down_alarm_treat_missing_data}"
}
