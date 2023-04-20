resource "aws_elasticache_subnet_group" "cache-subnet" {
  name       = "memecache"
  subnet_ids = concat(aws_subnet.prv-sub.*.id)
}

resource "aws_elasticache_cluster" "cache" {
  cluster_id           = "memcache"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  subnet_group_name    = aws_elasticache_subnet_group.cache-subnet.name
}