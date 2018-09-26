resource "aws_wafregional_web_acl_association" "alb" {
  depends_on   = ["aws_alb.nginx", "aws_wafregional_web_acl.alb"]
  resource_arn = "${aws_alb.nginx.arn}"
  web_acl_id   = "${aws_wafregional_web_acl.alb.id}"
}
