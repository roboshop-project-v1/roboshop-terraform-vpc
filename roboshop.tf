

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



module "alb" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-alb"

    for_each = var.alb
    env = var.env
    alb_type = each.value["lb_type"]
    tags = var.tags
    internal = each.value["internal"]
    sg_ingress_cidr = each.value["sg_ingress_cidr"]
    vpc_id = each.value["internal"]?local.vpc_id:var.default_vpc_id
    subnet_ids = each.value["internal"]?local.app_subnets:data.aws_subnets.subnets.ids
    sg_port = each.value["sg_port"]

}


module "docdb" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-docdb.git"
    tags = var.tags
    env = var.env

    for_each = var.docdb
    subnet_ids = local.db_subnets
    backup_retention_period = each.value["backup_retention_period"]
    preferred_backup_window = each.value["preferred_backup_window"]
    skip_final_snapshot = each.value["skip_final_snapshot"]
    vpc_id = local.vpc_id
    sg_ingress_cidr = local.app_subnets_cidr
    engine_version = each.value["engine_version"]
    family = each.value["family"]

    instance_count = each.value["instance_count"]
    instance_class     = each.value["instance_class"]

}



module "rds" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-rds.git"
    tags = var.tags
    env = var.env

    for_each = var.rds
    subnet_ids = local.db_subnets    
    vpc_id = local.vpc_id
    sg_ingress_cidr = local.app_subnets_cidr
    from_port = each.value["from_port"]
    to_port = each.value["to_port"]
    engine_family = each.value["engine_family"]
    engine = each.value["engine"]
    engine_version = each.value["engine_version"]
    backup_retention_period = each.value["backup_retention_period"]
    preferred_backup_window = each.value["preferred_backup_window"]
    skip_final_snapshot = each.value["skip_final_snapshot"]
    instance_class = each.value["instance_class"]
    instance_count = each.value["instance_count"]
}


module "elasticache" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-elasticache.git"
    tags = var.tags
    env = var.env
    subnet_ids = local.db_subnets    
    vpc_id = local.vpc_id
    sg_ingress_cidr = local.app_subnets_cidr

    for_each = var.elasticache
    engine = each.value["engine"]
    family =    each.value["family"]
    node_type            = each.value["node_type"]
    num_cache_nodes      = each.value["num_cache_nodes"]
    parameter_group_name = each.value["parameter_group_name"]
    engine_version       = each.value["engine_version"]
    port                 = each.value["port"]


}



module "rabbitmq" {
    source = "git::https://github.com/roboshop-project-v1/tf-module-rabbitmq.git"
    tags = var.tags
    env = var.env

    for_each = var.rabbitmq
    subnet_ids = local.db_subnets    
    vpc_id = local.vpc_id
    sg_ingress_cidr = local.app_subnets_cidr
    instance_type = each.value["instance_type"]
    ssh_ingress_cidr = each.value["ssh_ingress_cidr"]
    zone_id = each.value["zone_id"]

}



module "app" {

    depends_on = [ module.alb,module.docdb,module.elasticache,module.rabbitmq,module.rds ]

    source = "git::https://github.com/roboshop-project-v1/tf-module-apps.git"
    tags = var.tags
    env = var.env
    zone_id = var.zone_id
    ssh_ingress_cidr = var.ssh_ingress_cidr
    default_vpc_id = var.default_vpc_id

    for_each = var.apps
    component = each.key
    subnet_ids = local.app_subnets
    vpc_id = local.vpc_id
    sg_ingress_cidr = local.app_subnets_cidr
    
    port = each.value["port"]
    instance_type = each.value["instance_type"]
    desired_capacity   = each.value["desired_capacity"]
    max_size           = each.value["max_size"]
    min_size           = each.value["min_size"]
    priority           = each.value["priority"]
    parameters         = each.value["parameters"]
    

    private_alb_name = lookup(lookup(lookup(module.alb,"private",null),"alb",null),"dns_name",null)
    private_listener = lookup(lookup(lookup(module.alb,"private",null),"listener",null),"arn",null)

    public_alb_name = lookup(lookup(lookup(module.alb,"public",null),"alb",null),"dns_name",null)
    public_listener = lookup(lookup(lookup(module.alb,"public",null),"listener",null),"arn",null)
   

}
