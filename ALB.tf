# security group 
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.ap-south-1-CICD.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name               = "apache-alb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.ap-south-1-CICD-public-subnet.id,
    aws_subnet.ap-south-1-CICD-public-subnet-2.id
  ]

  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "tg" {
  name        = "apache-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ap-south-1-CICD.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ApacheServer.id
  port             = 80
  depends_on = [
    aws_instance.ApacheServer,
    aws_lb_target_group.tg
  ]
}