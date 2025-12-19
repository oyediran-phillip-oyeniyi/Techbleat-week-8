packer {
    required_version = ">=1.9.0"

    required_plugins {
        amazon = {
            source = "github.com/hashicorp/amazon"
            version = ">= 1.2.0"
        }
    }
}


#-----------------------------
# source: Build AMI for NGINX
#-----------------------------

source "amazon-ebs" "nginx" {
    region = "eu-west-1"
    instance_type = "c7i-flex.large"
    ssh_username = "ec2-user"
    source_ami  = "ami-09c54d172e7aa3d9a"
    ami_name = "nginx-ami"
    ami_virtualization_type  = "hvm"
}


#--------------------------------------
# source: Build AMI for Python
#--------------------------------------

source "amazon-ebs" "python" {
    region = "eu-west-1"
    instance_type = "c7i-flex.large"
    ssh_username = "ec2-user"
    source_ami  = "ami-09c54d172e7aa3d9a"
    ami_name = "python-ami"
    ami_virtualization_type  = "hvm"
}


#--------------------------------------
# source: Build AMI for Java
#--------------------------------------

source "amazon-ebs" "java" {
    region = "eu-west-1"
    instance_type = "c7i-flex.large"
    ssh_username = "ec2-user"
    source_ami  = "ami-09c54d172e7aa3d9a"
    ami_name = "java-ami"
    ami_virtualization_type  = "hvm"
}



#------------------------------------
# build: source + provisioning to do 
#------------------------------------

build  {
    name  = "nginx-ami-build"
    sources = [
        "source.amazon-ebs.nginx" 
    ]

    provisioner "shell" {
        inline = [
            "sudo yum update -y",
            "sudo yum install nginx -y",
            "sudo systemctl enable nginx",
            "sudo systemctl start nginx",
            "echo  '<h1> Welcome Oyediran - Built by Packer </h1>' | sudo tee /usr/share/nginx/html/index.html",
            "sudo yum install git -y"
        ]
    }

    post-processor "shell-local" {
        inline = ["echo 'AMI build is finished For Nginx' "]
    }
}


build  {
    name  = "python-ami-build"
    sources = [
        "source.amazon-ebs.python" 
    ]

    provisioner "shell" {
        inline = [
            "sudo yum update -y",
            "sudo yum install git -y"
        ]
    }

    post-processor "shell-local" {
        inline = ["echo 'AMI build is finished For Python' "]
    }
}


build  {
    name  = "java-ami-build"
    sources = [
        "source.amazon-ebs.java" 
    ]

    provisioner "shell" {
        inline = [
            "sudo yum update -y",
            "sudo yum install git -y"
            "sudo yum install java-17-amazon-corretto -y",
            "sudo yum install maven -y"
        ]
    }

    post-processor "shell-local" {
        inline = ["echo 'AMI build is finished For Java' "]
    }
}


