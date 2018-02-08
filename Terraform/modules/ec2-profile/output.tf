# --------------
# Module Outputs
# --------------
output "jenkins_ec2_role_arn" {
  value = "${aws_iam_role.jenkins_ec2_role.arn}"
}

output "jenkins_ec2_instance_arn" {
  value = "${aws_iam_instance_profile.jenkins_ec2_instance.arn}"
}

output "jenkins_ec2_instance_profile_name" {
  value = "${aws_iam_instance_profile.jenkins_ec2_instance.name}"
}
