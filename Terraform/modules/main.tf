# --------------------------
# Jenkins EFS Security Group
# --------------------------

/*
resource "efs_security_group" "this" {
  name        = "${var.customer_name}_${var.environment}_efs_sg"
  description = "EFS Security Group"
  vpc_id      = "${var.vpc_id}"
*/

resource "aws_security_group" "efs_sg" {
  name        = "${var.customer_name}_${var.environment}_efs_sg"
  description = "EFS Security Group"
  vpc_id      = "${var.vpc_id}"

  # Default EFS Ingress Rule
  ingress {
    from_port = "${var.efs_port}"
    to_port   = "${var.efs_port}"
    protocol  = "tcp"

    # vpc_cidr    = "var.vpc_cidr"
  }

  # Default Egress Rule
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"

    #vpc_cidr    = "var.vpc_cidr"
  }

  lifecycle {
    ignore_changes = ["name"]
  }

  tags {
    Name        = "${var.customer_name}_${var.environment}_efs_sg"
    Author      = "CollinsOrighose"
    Environment = "S{var.environment}"
    Terraform   = "true"
  }
}
