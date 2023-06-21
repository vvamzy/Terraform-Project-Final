variable "f_name" {
  default     = "John"
  type        = string
  description = "client name"
  sensitive   = true
}

variable "l_name" {
  default     = "Doe"
  type        = string
  description = "client name"
  sensitive   = true
}

variable "mobile" {
  default     = 9876543210
  type        = number
  description = "client name"
  sensitive   = true
}