# General
variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

# SPN
variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

# Service Plan
variable "asp_os_type" {
  type = string
}

variable "asp_sku_name" {
  type = string
}

# Github
variable "gh_repo_owner" {
  type = string
}

variable "gh_repo_name" {
  type = string
}
