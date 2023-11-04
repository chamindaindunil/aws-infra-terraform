module "aws-vpc" {
  source                    = "./modules/vpc"
  project                   = var.project
  environment               = var.environment
  main_vpc_cidr_block       = var.main_vpc_cidr_block
  secondary_vpc_cidr_blocks = var.secondary_vpc_cidr_blocks
  az_set                    = var.az_set
  public_subnets            = var.public_subnets
  private_subnets           = var.private_subnets
  db_private_subnets        = var.db_private_subnets
  enable_natgw              = var.enable_natgw
}

module "bastion" {
  source                = "./modules/bastion"
  project               = var.project
  bastion_ami           = var.bastion_ami
  vpc_id                = module.aws-vpc.vpc_id
  bastion_subnet_id     = module.aws-vpc.bastion_pub_subnet_id
  bastion_instance_type = var.bastion_instance_type
  bastion_disk_size     = var.bastion_disk_size
}

module "aws-eks" {
  source             = "./modules/eks"
  project            = var.project
  eks_vpc_id         = module.aws-vpc.vpc_id
  eks_subnet_ids     = module.aws-vpc.pvt_subnet_ids
  eks_endpoint_sg_id = module.aws-vpc.eks_endpoint_sg_id
  eks_instance_types = var.eks_instance_types
  eks_ami_type       = var.eks_ami_type
  node_count         = var.node_count
  eks_version        = var.eks_version
}

module "aws-rds" {
  source             = "./modules/rds"
  project            = var.project
  environment        = var.environment
  vpc_id             = module.aws-vpc.vpc_id
  rds_subnet_ids     = module.aws-vpc.db_pvt_subnet_ids
  rds_instace        = var.rds_instace
  rds_az_set         = var.rds_az_set
  rds_disk_size      = var.rds_disk_size
  rds_username       = var.rds_username
  rds_password       = var.rds_password
  rds_databases_list = var.rds_databases_list
}

module "aws-s3" {
  source      = "./modules/s3"
  project     = var.project
  environment = var.environment
}

module "aws-cf" {
  source             = "./modules/cloudfront"
  project            = var.project
  waf_acl_id         = module.wafv2.web_acl_id
  cf_custom_domain   = var.cf_custom_domain
  cf_enable_acm_cert = var.cf_enable_acm_cert
  http_apigw_url     = var.http_apigw_url
}

module "wafv2" {
  source  = "trussworks/wafv2/aws"
  version = "2.4.0"

  name  = "${var.project}-cf-waf"
  scope = "CLOUDFRONT"

  managed_rules = var.managed_rules

  providers = {
    aws = aws.useast1
  }
}

module "aws-redis" {
  source                   = "./modules/redis"
  project                  = var.project
  environment              = var.environment
  redis_subnet_ids         = module.aws-vpc.db_pvt_subnet_ids
  redis_az_set             = var.az_set
  vpc_id                   = module.aws-vpc.vpc_id
  redis_instance           = var.redis_instance
  redis_password           = var.redis_password
  snapshot_retention_limit = var.snapshot_retention_limit
  eks_subnets              = var.private_subnets
  bastion_private_ip       = module.bastion.bastion_private_ip
}