variable "instance_type" {
  description = "The type of instance to use for the EC2 instance."
  type        = string
  default     = "t3.medium"
}

variable "root_volumeSize" {
  description = "Size of disk for Jenkins Server"
  type        = string
  default     = "20"
}
