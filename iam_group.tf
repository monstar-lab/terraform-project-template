resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/"
}

resource "aws_iam_group" "developer" {
  name = "developer"
  path = "/"
}

resource "aws_iam_group_membership" "admin" {
  name = "admin"

  users = [
    "${aws_iam_user.admin.name}",
  ]

  group = "${aws_iam_group.admin.name}"
}

resource "aws_iam_group_membership" "developer" {
  name = "developer"

  users = [
    "${aws_iam_user.developer.name}",
  ]

  group = "${aws_iam_group.developer.name}"
}

resource "aws_iam_group_policy_attachment" "admin" {
  group      = "${aws_iam_group.admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "developer" {
  group      = "${aws_iam_group.developer.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
