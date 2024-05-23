output "vpc" {
  value = data.aws_subnets.subnets
}



output "name2" {
    value = module.vpc
  
}