# --------------
# Module Outputs
# --------------

# SSH Key Name
output "key_pair_name" {
  description = "The key pair name"
  value       = "${aws_key_pair.this.key_name}"
}

# SSH Key Finger Print
output "key_pair_fingerprint" {
  description = "The MD5 public key fingerprint"
  value       = "${aws_key_pair.this.fingerprint}"
}
