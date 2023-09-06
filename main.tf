terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}


module "security_groups" {
  source = "./modules/security_groups"

  environment = var.environment
  vpc_id = aws_vpc.vpc.id
  debug_connection_ip = var.debug_connection_ip
}


resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "terraform-igw"
  }
}

module "subnet" {
  source = "./modules/subnet"
  gateway_id = aws_internet_gateway.internet-gateway.id
  vpc_id = aws_vpc.vpc.id
}

module "iam_s3" {
  source = "./modules/iam_s3_readonly"
}


resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}


module "instances" {
  source = "./modules/instances"

  depends_on = [ module.security_groups, module.subnet, module.iam_s3 ]
  subnet_id = "${module.subnet.subnet_ids[0]}"
  security_group_tomcat_id = "${module.security_groups.security_group_tomcats_id}"
  security_group_backend_services_id = "${module.security_groups.security_group_backend_services_id}"
  iam_instance_profile = module.iam_s3.iam-profile_name
}

resource "aws_route53_zone" "private" {
  name = "vprofile.in"
  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}

resource "aws_route53_record" "backend_services_naming" {
  for_each = {
    "db01.vprofile.in" = module.instances.db01_private_ip
    "mc01.vprofile.in" = module.instances.mc01_private_ip
    "rmq01.vprofile.in" = module.instances.rmq01_private_ip
  }
  zone_id = aws_route53_zone.private.zone_id
  name    = each.key
  type    = "A"
  ttl     = 300
  records = [each.value]
}


module "artifact" {
  source = "./modules/s3_artifact"

  artifact_source = var.artifact_source
  bucket = var.bucket_name
}

module "load_balancer" {
  source = "./modules/load_balancer"

  domain = var.domain_name
  subnet_ids = module.subnet.subnet_ids
  security_group_load_balancer_ids = [module.security_groups.security_group_load_balancer_id]
  app_instance_id = module.instances.app_instance_id
  vpc_id = aws_vpc.vpc.id
}
