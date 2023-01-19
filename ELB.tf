

//////////////////////////////////Load Balencer////////////////////////////////////////

resource "aws_lb" "stanely-lb" {
  name               = "${var.app_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stanely-sg.id]
  subnets            = [aws_subnet.public-subnet.id]

  enable_deletion_protection = true


  tags = {
    Environment = "production"
    name        = "${var.app_name}-lb"
  }
}

///////////////////////////////Target Group/////////////////////////////////////////

resource "aws_lb_target_group" "stanely-tg" {
  name     = "${var.app_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stanely-vpc.id
  target_type = "instance"
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}


resource "aws_lb_target_group_attachment" "stanely-tg-register" {
  target_group_arn = aws_lb_target_group.stanely-tg.arn
  target_id        = aws_instance.stanely-ec2.id
  port             = 80
}

## Listener
resource "aws_lb_listener" "stanely-listener" {
  load_balancer_arn = aws_lb.stanely-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stanely-tg.arn
  }
}
