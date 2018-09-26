resource "aws_wafregional_web_acl" "alb" {
  depends_on  = ["aws_wafregional_rule.mitigate_sqli", "aws_wafregional_rule.mitigate_xss"]
  name        = "${var.env}-${var.project_name}-generic-acl"
  metric_name = "${var.env}${var.project_name}genericacl"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = "${aws_wafregional_rule.mitigate_sqli.id}"
    type     = "REGULAR"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 2
    rule_id  = "${aws_wafregional_rule.mitigate_xss.id}"
    type     = "REGULAR"
  }
}
