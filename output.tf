output "subnets_root" {
  value = data.aws_subnets.subnets
}



output "name2" {
    value = module.vpc
  
}

output "alb" {
  value = lookup(lookup(module.alb,"private",null),"dns_name",null)
}

output "alb_module" {
  value = module.alb
}

