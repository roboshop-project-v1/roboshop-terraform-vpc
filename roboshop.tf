

module "roboshop" {
    source = "git::https://github.com/roboshop-project-v1/tf-modules-vpc.git"

    for_each = var.vpc
    cidr = each.value["cidr"]

}
