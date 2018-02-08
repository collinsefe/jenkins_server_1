#############
# LOAD BALANCER 
#############

# --------------------------
# Jenkins ELB Security Group
# --------------------------
resource "aws_security_group" "jenkins_elb_sg" {
  name        = "jenkins-elb-sg"
  description = "Jenkins ELB Instance Security Group"
  vpc_id      = "${var.vpc_id}"

  # Jenkins EXT WEB Ingress Rule
  ingress {
    from_port   = "${var.ext_web_port}"
    to_port     = "${var.ext_web_port}"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Jenkins EXT SSL Ingress Rule
  ingress {
    from_port   = "${var.ext_ssl_port}"
    to_port     = "${var.ext_ssl_port}"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Default Egress Rule
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name      = "jenkins-elb-sg"
    Terraform = "true"
    Author    = "corighose"
  }
}

########################
#Jenkins ELB
########################
resource "aws_elb" "jenkins_elb" {
  name            = "jenkins-elb"
  security_groups = ["${aws_security_group.jenkins_elb_sg.id}"]
  subnets         = ["${var.subnet_ids}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "tcp"
    lb_port           = 8080
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  # instances                   = ["${aws_instance.jenkins_svr.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name        = "jenkins-elb"
    Author      = "corighose"
    Environment = "dev"
  }
}
