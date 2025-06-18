variable "zone1" {
  description = "this is public zone"
  default     = "ap-south-1a"
  type        = string
}

variable "zone2" {
  description = "this is private zone"
  default     = "ap-south-1b"
  type        = string
}

variable "AMI" {
  description = "this is the ami of ubuntu 24 image"
  default     = "ami-0dee22c13ea7a9a67"
  type        = string
}

variable "INSTANCE_TYPE" {
  description = "t2.medium with 4gb ram is used"
  default     = "t2.small"
  type        = string
}
