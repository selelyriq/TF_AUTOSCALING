variable "launch_template_name" {
  type = string
  description = "The name of the launch template"
}

variable "autoscaling_group_name" {
  type = string
  description = "The name of the autoscaling group"
}

variable "lb_name" {
  type = string
  description = "The name of the load balancer"
}

variable "security_group_name" {
  type = string
  description = "The name of the security group"
}

variable "target_group_name" {
  type = string
  description = "The name of the target group"
}

variable "web_app_ami" {
  type = string
  description = "The AMI ID for the web app"
}

variable "web_app_instance_type" {
  type = string
  description = "The instance type for the web app"
}

variable "web_app_min_size" {
  type = number
  description = "The minimum number of instances for the web app"
}

variable "web_app_max_size" {
  type = number
  description = "The maximum number of instances for the web app"
}
