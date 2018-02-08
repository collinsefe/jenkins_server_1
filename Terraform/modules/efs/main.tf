# --------------
# EFS Filesystem
# --------------
resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = "jenkins-dev"

  tags {
    Name        = "jenkins-efs"
    Environment = "dev"
    Terraform   = "true"
    Author      = "corighose"
    Protected   = "false"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -----------------
# EFS Mount targets
# -----------------
resource "aws_efs_mount_target" "efs_mount_target" {
  count           = "${var.subnet_count}"
  security_groups = ["${var.security_groups}"]
  file_system_id  = "${aws_efs_file_system.jenkins_efs.id}"
  subnet_id       = "${element(var.subnet_ids, count.index)}"
}
