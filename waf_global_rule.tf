resource "aws_waf_rule" "mitigate_sqli" {
  depends_on  = ["aws_waf_sql_injection_match_set.sql_injection_match_set"]
  name        = "${var.env}-${var.project_name}-generic-mitigate-sqli"
  metric_name = "${var.env}${var.project_name}genericmitigatesqli"

  predicates {
    data_id = "${aws_waf_sql_injection_match_set.sql_injection_match_set.id}"
    negated = false
    type    = "SqlInjectionMatch"
  }
}

resource "aws_waf_rule" "mitigate_xss" {
  depends_on  = ["aws_waf_xss_match_set.xss_match_set"]
  name        = "${var.env}-${var.project_name}-generic-mitigate-xss"
  metric_name = "${var.env}${var.project_name}genericmitigatexss"

  predicates {
    data_id = "${aws_waf_xss_match_set.xss_match_set.id}"
    negated = false
    type    = "XssMatch"
  }
}
