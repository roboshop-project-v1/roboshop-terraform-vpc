

module "roboshop" {
    source = "git::https://github.com/roboshop-project-v1/tf-modules-roboshop.git"

    for_each = var.components
    component = each.key
    ami = var.ami
    instance_type = var.instance_type
    zone_id = var.zone_id
    vpc_security_group_ids = var.vpc_security_group_ids
}
