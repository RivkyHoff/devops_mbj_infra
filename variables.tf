variable "project_id" {

description = "The ID of the project"

type = string

}


variable "region" {

description = "The region to deploy resources"

type = string

default = "us-central1"

}
variable "zone" {
  description = "The zone for the resources"
  type        = string
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 2
}

variable "myname" {
  description = "Prefix for resource names"
  type        = string
  default     = "myname"
}