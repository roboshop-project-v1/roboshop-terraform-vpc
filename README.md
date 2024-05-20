# roboshop-terraform

# terraform init -backend-config=envdev/state.tfvars

# terraform apply -var-file=envdev/main.tfvars -auto-approve

# terraform init -backend-config=envprod/state.tfvars 

# rm -rf .terraform

# terraform init -backend-config=envprod/state.tfvars


<!-- dev:
	rm -rf .terraform
	terraform init -backend-config=envdev/state.tfvars
	terraform apply -auto-approve -var-file=envdev/main.tfvars 
prod:
	rm -rf .terraform
	terraform init -backend-config=envprod/state.tfvars
	terraform apply -auto-approve -var-file=envprod/main.tfvars -->
# make dev
