variable "password" {
  type        = string
  description = "FTD Password"
}

variable "region" {
  type = string
  description = "AWS region"
}

variable "az-a" {
  type = string
  description = "AWS first AZ "
}

variable "az-b" {
  type = string
  description = "AWS second AZ "
}