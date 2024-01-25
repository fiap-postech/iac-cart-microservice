locals {
  redis = {
    sg = {
      name = "${replace(local.project_name, "-", "_")}_cache_sg"

      ingress = {
        from_port = 6379
        to_port   = 6379
        protocol  = "tcp"
      }

      egress = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    subnet_group = {
      name = "${local.project_name}-redis-subnet-group"
    }

    replication_group = {
      availability_zones         = ["us-east-1a"]
      replication_group_id       = "${local.project_name}-redis"
      description                = "cache for ${lower(local.context_name)} purposes"
      node_type                  = "cache.t3.micro"
      engine                     = "redis"
      engine_version             = "6.x"
      num_cache_clusters         = 1
      parameter_group_name       = "default.redis6.x"
      port                       = 6379
      transit_encryption_enabled = false
    }
  }
}