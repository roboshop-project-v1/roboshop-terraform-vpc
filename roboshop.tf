

module "vpc" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-vpc"

    for_each = var.vpc
    cidr = each.value["cidr"]
    subnets = each.value["subnets"]
    default_vpc_id = var.default_vpc_id
    default_vpc_cidr = var.default_vpc_cidr
    default_vpc_rt = var.default_vpc_rt
    tags = merge(var.tags,{env = var.env})

}



# module "alb" {
#     source = "git::https://github.com/roboshop-project-v1/tf-module-alb"

#     for_each = var.alb
#     env = var.env
#     alb_type = each.value["lb_type"]
#     tags = var.tags
#     internal = each.value["internal"]
#     sg_ingress_cidr = each.value["sg_ingress_cidr"]
#     vpc_id = each.value["internal"]?local.vpc_id:var.default_vpc_id
#     subnet_ids = each.value["internal"]?local.app_subnets:data.aws_subnets.subnets.ids
#     sg_port = each.value["sg_port"]

# }

