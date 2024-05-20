

module "roboshop" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-vpc"

    for_each = var.vpc
    cidr = each.value["cidr"]
    subnets = each.value["subnets"]

}

output "name3" {
    value = module.roboshop
  
}