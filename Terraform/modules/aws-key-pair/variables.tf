# -------------
# Module Inputs
# -------------
variable "key_pair_name" {
  description = "The name of the key pair"
  default     = "collinsefe.pem"
}

variable "public_key_path" {
  description = "Path to a specified SSH public key file"
  default     = "/Users/corighose/.ssh/id_rsa_pub"
}
