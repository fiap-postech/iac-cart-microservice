data "aws_vpc" "main" {
  tags = {
    Name = local.vpc_name
  }
}

data "aws_subnets" "private_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Scope"
    values = ["private"]
  }

  depends_on = [data.aws_vpc.main]
}


data "aws_subnet" "private_selected" {
  for_each = toset(data.aws_subnets.private_subnet_ids.ids)
  id       = each.value

  depends_on = [data.aws_subnets.private_subnet_ids]
}

data "aws_subnets" "database_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Scope"
    values = ["database"]
  }

  depends_on = [data.aws_vpc.main]
}


data "aws_subnet" "database_selected" {
  for_each = toset(data.aws_subnets.database_subnet_ids.ids)
  id       = each.value

  depends_on = [data.aws_subnets.database_subnet_ids]
}


data "aws_ecs_cluster" "cluster" {
  cluster_name = local.ecs.cluster_name
}

data "aws_security_group" "vpc_endpoint_sm_cl" {
  name = "vpc-endpoints-secretsmanager-cloudwatchlogs-sg"
}

data "aws_apigatewayv2_api" "tech_challenge_api" {
  api_id = local.api_gateway.id
}

data "aws_apigatewayv2_vpc_link" "gateway_vpc_link" {
  vpc_link_id = local.api_gateway.vpc_link.id
}

data "aws_lb" "customer_alb" {
  name = local.ecs.integration.customer_alb
}

data "aws_lb" "product_alb" {
  name = local.ecs.integration.product_alb
}