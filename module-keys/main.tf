module "dynamic-keys" {
  source  = "mitchellh/dynamic-keys/aws"
  version = "2.0.0"
  # insert the 1 required variable here
}

resource "local_file" "public-key" {
  content = module.dynamic-keys.public_key_openssh
  filename = "hi.txt"
}