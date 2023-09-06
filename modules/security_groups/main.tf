resource "aws_security_group" "load_balancer" {
    name =  "vprovile_ELB_SG"
    description = "For load balancer"
    vpc_id = var.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group_rule" "load_balancer_rule" {
  for_each = toset(var.load_balancer_ports)
  type              = "ingress"
  from_port         = each.key
  to_port           = each.key
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group" "tomcats" {
    name =  "vprovile_tomcats"
    description = "For tomcat instances"
    vpc_id = var.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}


resource "aws_security_group_rule" "tomcat_security_rule_production" {
    for_each = var.environment == "production" ? toset(var.tomcat_production_ports) : toset([])
    type              = "ingress"
    from_port         = each.key
    to_port           = each.key
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    security_group_id = aws_security_group.tomcats.id
  }

  resource "aws_security_group_rule" "tomcat_security_rule_debug" {
    for_each = var.environment == "debug" ? toset(var.tomcat_debug_ports) : toset([])
    type              = "ingress"
    from_port         = each.key
    to_port           = each.key
    protocol          = "tcp"
    cidr_blocks       = var.debug_connection_ip
    ipv6_cidr_blocks  = []
    security_group_id = aws_security_group.tomcats.id
  }

resource "aws_security_group" "backend_services" {
    name =  "vprovile_backend"
    description = "For RabbitMQ, MemcacheD, MySQL"
    vpc_id = var.vpc_id
    
    ingress = [{
        from_port = 0
        to_port = 0
        cidr_blocks = []
        ipv6_cidr_blocks = []
        description = "Allow all internal traffic"
        protocol = -1
        prefix_list_ids = []
        security_groups = []
        self = true
    }]

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

}


resource "aws_security_group_rule" "backend_security_rule_production" {
    for_each = var.environment == "production" ? toset(var.backend_production_ports) : toset([])
    type              = "ingress"
    from_port         = each.key
    to_port           = each.key
    protocol          = "tcp"
    source_security_group_id = aws_security_group.tomcats.id
    security_group_id = aws_security_group.backend_services.id
  }

  resource "aws_security_group_rule" "backend_security_rule_debug" {
    for_each = var.environment == "debug" ? toset(var.backend_debug_ports) : toset([])
    type              = "ingress"
    from_port         = each.key
    to_port           = each.key
    protocol          = "tcp"
    cidr_blocks       = var.debug_connection_ip
    ipv6_cidr_blocks  = []
    security_group_id = aws_security_group.backend_services.id
  }