resource "aws_waf_web_acl" "waf_acl" {
  depends_on  = ["aws_waf_rule.mitigate_sqli", "aws_waf_rule.mitigate_xss"]
  name        = "${var.env}-${var.project_name}-generic-acl"
  metric_name = "${var.env}${var.project_name}genericacl"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = "${aws_waf_rule.mitigate_sqli.id}"
    type     = "REGULAR"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 2
    rule_id  = "${aws_waf_rule.mitigate_xss.id}"
    type     = "REGULAR"
  }
}
