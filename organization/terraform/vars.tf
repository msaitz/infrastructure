variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "org_accounts" {
  type = list(object({
    account_name = string
    email        = string
  }))
}
