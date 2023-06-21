resource "tls_private_key" "pk_gen" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.pk_gen.private_key_pem
  filename = "tf-gen-key.pem"
  file_permission = "0600"
}