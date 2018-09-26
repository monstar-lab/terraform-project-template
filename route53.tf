resource "aws_route53_zone" "private" {
  name       = "${var.env}-sample.com"
  vpc_id     = "${lookup(var.vpc, "vpc_id")}"
  vpc_region = "${var.region}"
}

resource "aws_route53_record" "db_master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "db"
  type    = "CNAME"
  ttl     = "10"
  records = ["${aws_db_instance.mysql-master.address}"]
}

resource "aws_route53_record" "cache_endpoint" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "cache"
  type    = "CNAME"
  ttl     = "10"
  records = ["${aws_elasticache_replication_group.cache.configuration_endpoint_address}"]
}
