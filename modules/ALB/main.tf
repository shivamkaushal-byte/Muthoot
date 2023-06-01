resource "aws_lb" "prod_lb" {
  name = "prod-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = var.public_subnet

  tags = {
    name = "prod_alb"
  }
}
resource "aws_security_group" "alb_sg" {
vpc_id = var.vpc_id

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

resource "aws_lb_target_group" "target_group" {
  name     = "first-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
    port = "80"
  }
}
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_id
  port             = 80
}
