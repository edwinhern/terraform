variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region"
}

variable "access_key" {
  type        = string
  description = "The AWS access key"
}

variable "secret_key" {
  type        = string
  description = "The AWS secret key"
}

variable "github_token" {
  type        = string
  description = "The GitHub access token"
}

variable "aws_instance_ami" {
  type        = string
  description = "The AMI to use for the EC2 instance"
  validation {
    condition     = length(var.aws_instance_ami) > 4 && substr(var.aws_instance_ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "aws_instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
}


variable "aws_instance_name" {
  type        = string
  description = "The name of the EC2 instance"
}
