locals {
  org_accounts = {
    for account in var.org_accounts : account.account_name => {
      account_name = account.account_name
      email        = account.email
    }
  }
}

resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

resource "aws_organizations_account" "org_account" {
  for_each = local.org_accounts

  name                       = each.value.account_name
  email                      = each.value.email
  parent_id                  = aws_organizations_organization.org.roots[0].id
  role_name                  = "OrganizationAccountAccessRole"
  iam_user_access_to_billing = "DENY"
}
