resource "tls_private_key" "ngnix_oregon" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ngnix_oregon"
  public_key = tls_private_key.ngnix_oregon.public_key_openssh
}

resource "aws_instance" "first" {
  ami           = "ami-041d7b792b930cdc2"
  instance_type = "t2.nano"
  key_name 		= "ngnix_oregon"
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  subnet_id                   = aws_subnet.public_subnetA.id
  associate_public_ip_address = true
  instance_initiated_shutdown_behavior = "terminate"

  #  metadata_options {
  #    http_tokens = "required"
  #    }  


  root_block_device {
      encrypted = true
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 5
    volume_type = "gp2"
    delete_on_termination = false
    encrypted = true
  }
  
    tags = {
      Name = "boto3fromami" 
    }
   connection {
   host        = aws_instance.first.public_ip
   agent       = true
   type        = "ssh"
   user        = "ubuntu"
   private_key = tls_private_key.ngnix_oregon.private_key_openssh
  }
  provisioner "file" {
    source      = "/home/einfochips/Desktop/terraform/yocto/boto3tutorial.py"
    destination = "/tmp/boto3tutorial.py"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/boto3tutorial.py",
      "python3 /tmp/boto3tutorial.py",
    ]
  }
}
