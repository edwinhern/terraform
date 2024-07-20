# Goal: Create EC2 instances
resource "aws_instance" "web" {
  ami           = var.aws_instance_ami
  instance_type = var.aws_instance_type
  tags = {
    Name = var.aws_instance_name
  }
}


resource "github_repository" "repository" {
  name        = "terraform-created-repo"
  description = "Terraform created repository"
  visibility  = "public"
}


output "IPAddress" {
  value = aws_instance.web.public_ip
}


output "DNS" {
  value = aws_instance.web.public_dns
}
