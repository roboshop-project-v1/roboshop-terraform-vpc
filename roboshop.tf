

module "roboshop" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-vpc"

    for_each = var.vpc
    cidr = each.value["cidr"]

}

output "name" {
    value = var.vpc_details
  
}