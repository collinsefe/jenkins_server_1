# Author: Collins Orighose - Jan 2018 \

make_image: packer build ....
	@cd Terraform/jenkins

init_jenkins: clean_jenkins
	@cd Terraform/ && \
	terraform init

plan_jenkins: init_jenkins fmt_jenkins get_jenkins
	@cd Terraform/ && \
	terraform plan -out=terraform.tfplan

plan_jenkins_download: init_jenkins clone_app_files fmt_jenkins get_jenkins
	@cd Terraform/ && \
	terraform plan -out=terraform.tfplan

jenkins: plan_jenkins
	@cd Terraform/ && \
	terraform apply terraform.tfplan

jenkins_download: clone_app_files plan_jenkins 
	@cd Terraform/ && \
	terraform apply terraform.tfplan

outputs_jenkins: init_jenkins
	@cd Terraform/ && \
	terraform output

plan_destroy_jenkins: init_jenkins
	@cd Terraform/ && \
	terraform plan -destroy

destroy_jenkins: plan_destroy_jenkins
	@cd Terraform/ && \
	terraform destroy

fmt_jenkins:
	@cd Terraform/ && \
	terraform fmt

get_jenkins:
	@cd Terraform/ && \
	terraform get

clone_app_files:
	@echo "Downloading file from repo..."
	@cd ./terraform_files/application && \
	rm -rf * && \
	git clone https://code.deloittecloud.co.uk/ITS/Project_Questionnaire.git && \
	cd Project_Questionnaire/Lambda_function && \
	zip sendmail_for_questionnaire.zip sendmail_for_questionnaire.js
	cd ../../../..


clean_jenkins:
	@echo "Cleaning up..."
	@cd Terraform/ && \
	rm -rf ./.terraform *.tfstate *.backup

