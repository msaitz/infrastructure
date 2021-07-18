resource "aws_iam_user" "bootstrap" {
  count = var.create_master_bootstrap ? 1 : 0

  name = "tf-bootstrap"
  path = "/bootstrap/"

  tags = {
    name       = "boostrap"
    created_by = "terraform"
  }
}

resource "aws_iam_access_key" "bootstrap" {
  count = var.create_master_bootstrap ? 1 : 0

  user    = aws_iam_user.bootstrap[count.index].name
  pgp_key = "keybase:msaitz"
  status  = "Inactive"
}

resource "aws_iam_group" "bootstrap" {
  count = var.create_master_bootstrap ? 1 : 0

  name = "bootstrap"
  path = "/boostrap/"
}

resource "aws_iam_policy_attachment" "bootstrap" {
  count = var.create_master_bootstrap ? 1 : 0

  name       = "bootstrap-attachment"
  groups     = aws_iam_group.bootstrap[*].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_membership" "bootstrap" {
  count = var.create_master_bootstrap ? 1 : 0

  name  = "boostrap-group-membership"
  group = aws_iam_group.bootstrap[count.index].name
  users = aws_iam_user.bootstrap[*].name
}
