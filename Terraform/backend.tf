terraform {
  backend "s3" {
    bucket  = "tf-state-dcuk074-jenkins-dev"
    key     = "tf_jenkins_tfstate"
    encrypt = true
    region  = "eu-west-1"
  }
}
