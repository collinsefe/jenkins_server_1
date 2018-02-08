# Terraform AWS SSH Key Pair Module  
This is a Terraform module for AWS that is used to manage SSH Key Pairs.  

**NOTE**: Currently this resource requires an existing user-supplied key pair. This key pair's public key will be registered with AWS to allow logging-in to EC2 instances.  

## Dependencies  
You must first create the SSH key pair (using something like `ssh-keygen`) on your workstation. You then specify the path to your public key and it will be imported to AWS.  

## Variables  
```
key_pair_name:   The name of the key pair
public_key_path: Path to a specified SSH public key file
```

## Example Usage  
```
module "key_pair" {
  source = "../<path-to>/terraform-aws-key-pair"

  key_pair_name   = "MY-KEY-NAME"
  public_key_path = "/path/to/my/key.pub"
}
```
