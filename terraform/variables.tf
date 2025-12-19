variable "nginx_ami" {
    type = string
    description = "AMI ID for nginx node"
}

variable "python_ami" {
    type = string
    description = "AMI ID for python node"
}

variable "java_ami" {
    type = string
    description = "AMI ID for java node"
}

variable "instance_type" {
    type = string
    description = "EC2 instance"
}

variable "project_subnet" {
    type = string
    description = "Subnet address"
}

variable "key_name" {
    type = string
    description = "SSH key"
}