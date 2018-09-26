resource "aws_iam_user" "admin" {
  name = "admin"
  path = "/"
}

resource "aws_iam_user" "developer" {
  name = "developer"
  path = "/"
}
