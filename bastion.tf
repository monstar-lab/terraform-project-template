data "template_file" "bastion_userdata" {
  template = "${file("${path.module}/user_data/bastion.tpl")}"

  vars {
    newrelic_license = "${aws_ssm_parameter.newrelic.value}"
  }
}

resource "aws_instance" "bastion" {
  count                = "${var.bastion_count}"
  ami                  = "${data.aws_ami.ec2_amazon_linux.id}"
  instance_type        = "${var.bastion_instance_type}"
  key_name             = "${var.project_name}-${var.env}-${var.region}"
  subnet_id            = "${lookup(var.vpc, "front-a")}"
  security_groups      = ["${aws_security_group.bastion-sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.bastion_instance.name}"
  user_data            = "${data.template_file.bastion_userdata.rendered}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = "8"
  }

  tags {
    Name = "bastion"
  }

  lifecycle {
    ignore_changes = [
      "id",
      "security_groups",
    ]
  }
}
