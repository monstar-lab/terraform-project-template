data "template_file" "app_userdata" {
  template = "${file("${path.module}/user_data/app.tpl")}"

  vars {
    newrelic_license = "${aws_ssm_parameter.newrelic.value}"
  }
}

resource "aws_instance" "app" {
  count                = "${var.app_count}"
  ami                  = "${data.aws_ami.ec2_amazon_linux.id}"
  instance_type        = "${var.app_instance_type}"
  key_name             = "${var.project_name}-${var.env}-${var.region}"
  subnet_id            = "${element(var.app_subnet_list, count.index)}"
  security_groups      = ["${aws_security_group.app-sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.app_instance.name}"
  user_data            = "${data.template_file.app_userdata.rendered}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = "8"
  }

  tags {
    Name = "${format("${var.env}-${var.project_name}-app-%02d", count.index + 1)}"
    env  = "${var.env}"
  }

  lifecycle {
    ignore_changes = [
      "id",
      "security_groups",
    ]
  }
}
