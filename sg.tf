data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "nginx_sg" {
  name        = "ngnix_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    description = "for egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    #cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
}