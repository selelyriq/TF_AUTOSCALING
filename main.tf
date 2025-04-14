data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "labs3terraformbackend"
    key    = "three-tier-app-terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_launch_template" "web_app_template" {
  name          = var.launch_template_name
  image_id      = var.web_app_ami
  instance_type = var.web_app_instance_type
}

resource "aws_autoscaling_group" "web_app_asg" {
  name = var.autoscaling_group_name
  launch_template {
    id      = aws_launch_template.web_app_template.id
    version = "$Latest"
  }
  min_size            = 2
  max_size            = 4
  vpc_zone_identifier = [data.terraform_remote_state.vpc.outputs.public_subnets]
}

resource "aws_lb" "web_app_lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_app_sg.id]
  subnets            = [data.terraform_remote_state.vpc.outputs.public_subnets]
}

resource "aws_security_group" "web_app_sg" {
  name        = var.security_group_name
  description = "Security group for the web app"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_security_group_rule" "web_app_sg_rule" {
  security_group_id = aws_security_group.web_app_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_app_sg_rule_outbound" {
  security_group_id = aws_security_group.web_app_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "web_app_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_target_group.arn
  }
}

resource "aws_lb_target_group" "web_app_target_group" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
}

# XD

