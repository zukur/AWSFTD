###########################################
#### Define variables
###########################################

variable "password" {
  type        = string
  description = "FTD Password"
}

variable "region" {
  type = string
  description = "AWS region"
}