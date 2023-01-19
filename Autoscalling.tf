/////////////////////////////////Launch configuratons////////////////////////////////////

resource "aws_launch_configuration" "stanely-lc" {
  name          = "${var.app_name}-lc"
  image_id      = "ami-06878d265978313ca"
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
  
  key_name                    = aws_key_pair.stanelykey.id
  security_groups             = [aws_security_group.stanely-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update -y

EOF
}
////////////////////////////////Auto scalling Group///////////////////////////////////

resource "aws_autoscaling_group" "stanely-ASG" {
  name                      = "${var.app_name}-ASG"
  launch_configuration      = aws_launch_configuration.stanely-lc.name
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = [aws_subnet.public-subnet.id]

  target_group_arns     = [aws_lb_target_group.stanely-tg.arn]
  protect_from_scale_in = true
  lifecycle {
    create_before_destroy = true
  }
}
