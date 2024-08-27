variable "my_sg_id" {}
variable "my_public_subnets" {}
variable "vpc_id" {}
variable "ec2_instances" {}

resource "aws_lb_target_group" "my_lb_tg" {
  name = "alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
    port = 80
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_lb_target_group_attachment" "my_lb_tg_att" {
  depends_on = [ aws_lb_target_group.my_lb_tg ]
  count = length(var.ec2_instances)
  target_group_arn = aws_lb_target_group.my_lb_tg.arn
  target_id = var.ec2_instances[count.index].id
  port = 80
}

resource "aws_alb" "my_alb" {
  name = "my-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ var.my_sg_id ]
  subnets = [ for subnet in var.my_public_subnets: subnet.id ]
  enable_deletion_protection = false
}

resource "aws_alb_listener" "my_alb_listner" {
  load_balancer_arn = aws_alb.my_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_lb_tg.arn
  }
}
