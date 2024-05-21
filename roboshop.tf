

module "roboshop" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-vpc"

    for_each = var.vpc
    cidr = each.value["cidr"]
    subnets = each.value["subnets"]
    default_vpc_id = var.default_vpc_id

}

output "name2" {
    value = module.roboshop
  
}