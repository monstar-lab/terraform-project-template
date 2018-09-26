resource "aws_wafregional_rule" "mitigate_sqli" {
  depends_on  = ["aws_wafregional_sql_injection_match_set.sql_injection_match_set"]
  name        = "${var.env}-generic-mitigate-sqli"
  metric_name = "${var.env}genericmitigatesqli"

  predicate {
    data_id = "${aws_wafregional_sql_injection_match_set.sql_injection_match_set.id}"
    negated = false
    type    = "SqlInjectionMatch"
  }
}

resource "aws_wafregional_rule" "mitigate_xss" {
  depends_on  = ["aws_wafregional_xss_match_set.xss_match_set"]
  name        = "${var.env}-generic-mitigate-xss"
  metric_name = "${var.env}genericmitigatexss"

  predicate {
    data_id = "${aws_wafregional_xss_match_set.xss_match_set.id}"
    negated = false
    type    = "XssMatch"
  }
}
