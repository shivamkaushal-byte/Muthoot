resource "aws_security_group" "ssh-allowed" {
    vpc_id = var.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
}

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
       from_port   = 80
       to_port     = 80
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
       Name = "ssh-allowed"
   }
}
resource "aws_key_pair" "developer" {
  key_name   = "developer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCe/aFSIaaMxfZraAVw9FbCMlH7NtSdGE/z26uGwd6OSqJMQBmQfnaIyWePpMI/musy5NJ60Jqtk9rv3m40BOlRNpGxdPdSdQAOu4j5cQQ8l7gZMq+f3oFlbzSJxBY6RdvV7X2raNu3oUzhcgYz72vbW1CxekXOCQfwzX6sWu3z/1pr4UgSXCOEOlR1tMI7+ik/de5+YLGfIGVN9tePdSiZ54EWv8HZh8/sI8dNVDhWbibm7d5NIAihoLRWuylCvzpmtijh1fTb/TpWec5rfV2bvmNa26Q3PxOdAGx67q/4DfrOgZldGiPOvViMIzGyA4PWlscq3dv/HFoTVu97q5aqpUUwchfinKFjGPpDF8If4e9gzbHNbr4efgQGh+XLiZHlXmkukLphFPqneOv8yxnqNIkjBTiKTMaeAfim1Jgk/                 IdIhn65haep9kRdVW9lot3EFBSQZkWnN0NJ3NQkqpGX8R08yQMcODE3V4Clh+VQeVpbrTzaHvP7b+JHedgRywc=ec2-user@ip-172-31-95-127.ec2.internal"
  }

resource "aws_instance" "instance-1" {
      ami = var.ami_id
      instance_type = var.instance_type
      subnet_id = var.subnet_id
      vpc_security_group_ids =[aws_security_group.ssh-allowed.id]
      key_name = aws_key_pair.developer.id
      tags = {
        Name = "prod instance"
    }
    provisioner "remote-exec" {
    inline = [
       "sudo yum update -y",
       "sudo yum install -y httpd",
       "sudo systemctl enable httpd",
       "sudo service httpd start",
       "sudo echo '<h1>OneMuthoot - APP-1</h1>' | sudo tee /var/www/html/index.html",
       "sudo mkdir /var/www/html/app1",
       "sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html",
       "sudo yum install docker",
       "sudo usermod -a -G docker ec2-user",
       "sudo systemctl enable docker.service",
       "sudo systemctl start docker.service",
     ]
     connection {
     host = self.public_ip
     type = "ssh"
     user = "ec2-user"
     private_key = file("./developer")
  }
  }
}
