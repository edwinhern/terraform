# Challenge: Create file in local machine using terraform

resource "null_resource" "file" {
  provisioner "local-exec" {
    command = "echo 'Message: ${upper("Hello, John!")}' > challenge.txt"
  }
}
