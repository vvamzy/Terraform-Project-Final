variable "file_name" {
  default = "hello6.txt"
}

variable "message" {
  default     = true
  type        = bool
  description = "this contains message to be in the file"
}

variable "prefix" {
  default = 2023
  type    = number
}

variable "content" {
  type = map(string)
  default = {
    "India"     = "New Delhi"
    "Telangana" = "Hyderabad"
  }
}
