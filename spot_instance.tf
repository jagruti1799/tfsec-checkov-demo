resource "aws_spot_instance_request" "nginx_one_time" {
  ami                  = "ami-041d7b792b930cdc2"
  spot_price           = "0.8"
  instance_type        = "c4.large"
  wait_for_fulfillment = true
  spot_type            = "one-time"
  # block_duration_minutes = 60
  key_name = "ngnix_oregon"
  #valid_until = "2022-11-14T10:45:21+00:00"
  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

resource "aws_spot_instance_request" "nginx_persistent" {
  ami                  = "ami-041d7b792b930cdc2"
  spot_price           = "0.8"
  instance_type        = "c4.large"
  wait_for_fulfillment = true
  spot_type            = "persistent"
  # block_duration_minutes = 60
  key_name = "ngnix_oregon"
  #valid_until = "2022-11-14T10:45:21+00:00"
  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

resource "aws_ec2_tag" "one_time_spot" {
  resource_id = aws_spot_instance_request.nginx_one_time.spot_instance_id
  key         = "Name"
  value       = "nginx_one_time"
}

resource "aws_ec2_tag" "persistent_spot" {
  resource_id = aws_spot_instance_request.nginx_persistent.spot_instance_id
  key         = "Name"
  value       = "nginx_persistent"
}