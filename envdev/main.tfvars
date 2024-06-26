vpc = {
    main = {
        cidr = "10.0.0.0/16"
        subnets = {
            public = {
                public1 = {cidr = "10.0.1.0/24",az="us-east-1a"}
                public2 = {cidr = "10.0.2.0/24",az="us-east-1b"}
            }
            app = {
                app1 = {cidr = "10.0.3.0/24",az="us-east-1a"}
                app2 = {cidr = "10.0.4.0/24",az="us-east-1b"}
            }
            db = {
                db1 = {cidr = "10.0.5.0/24",az="us-east-1a"}
                db2 = {cidr = "10.0.6.0/24",az="us-east-1b"}
            }
        }
    }
}

default_vpc_id = "vpc-0d3da8d120733d9e0"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rt = "rtb-0a819725561398b7a"
zone_id = "Z05459522TM73CF1WNKI7"

ssh_ingress_cidr = "172.31.0.0/16"
monitoring_ingress_cids = ["172.31.0.0/16"]
tags = {
    company_name = "ABC Tech"
    bussiness_unit = "Ecommerce"
    project_name = "Roboshop"
    cost_center = "ecom_rs"
    }
env = "dev"

alb = {
    public = {
        internal = false
        lb_type = "application"
        sg_ingress_cidr = ["0.0.0.0/0"]
        sg_port = 80
    }

    private = {
        internal = true
        lb_type = "application"
        sg_ingress_cidr = ["172.31.0.0/16","10.0.0.0/16"]
        sg_port = 80
    }
}


docdb = {
    main = {

        backup_retention_period = 5
        preferred_backup_window = "07:00-09:00"
        skip_final_snapshot = true
        engine_version = "4.0.0"
        family = "docdb4.0"
        instance_count   = 2
        instance_class     = "db.t3.medium"
    }
}

rds = {
    main = {
        rds_type = "mysql"
        from_port = 3306
        to_port = 3306
        engine_family = "aurora-mysql5.7"
        engine = "aurora-mysql"
        engine_version  = "5.7.mysql_aurora.2.11.3"
        backup_retention_period = 5
        preferred_backup_window = "07:00-09:00"
        skip_final_snapshot = true
        instance_class     = "db.t3.medium"
        instance_count     = 1
    }

}

elasticache = {
    main = {

        engine = "redis"
        family =    "redis6.x"
        node_type            = "cache.t3.micro"
        num_cache_nodes      = 1
        parameter_group_name = "default.redis3.2"
        engine_version       = "6.2"
        port                 = 6379
    }
}

rabbitmq = {
    main = {
        instance_type = "t3.small"
        ssh_ingress_cidr = "172.31.0.0/16"
        zone_id = "Z05459522TM73CF1WNKI7"

    }
}

apps = {
    frontend = {
        instance_type = "t3.small"
        port = 80
        desired_capacity   = 1
        max_size           = 3
        min_size           = 1
        priority           = 1
        parameters         = []
        tags               = {Monitor_Nginx = "yes"}
        

    }
    catalogue = {
        instance_type = "t3.small"
        port = 8080
        desired_capacity   = 1
        max_size           = 3
        min_size           = 1
        priority           = 2
        parameters         = ["docdb"]
        tags               = {}
    }
    cart = {
        instance_type = "t3.small"
        port = 8080
        desired_capacity   = 1
        max_size           = 3
        min_size           = 1
        priority           = 3
        parameters         = []
        tags               = {}

    }
    user = {
        instance_type = "t3.small"
        port = 8080
        desired_capacity   = 1
        max_size           = 3
        min_size           = 1
        priority           = 4
        parameters         = ["docdb"]
        tags               = {}
    }
    shipping = {
        instance_type = "t3.small"
        port = 8080
        desired_capacity   = 1
        max_size           = 3
        min_size           = 1
        priority           = 5
        parameters         = ["rds"]
        tags               = {}
    }
    payment = {
        instance_type = "t3.small"
        port = 8080
        desired_capacity   = 1
        max_size           = 3
        min_size           = 1
        priority           = 6
        parameters         = ["rabbitmq"]
        tags               = {}

    }
}