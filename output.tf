output "ip" {
  value = "${chomp(data.http.myip.response_body)}"
}

output "ec2-id" {
  value = aws_instance.first.id
}
