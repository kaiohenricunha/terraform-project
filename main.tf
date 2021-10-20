provider "aws" {
  region = "us-west-2"
}

# launch configuration
resource "aws_launch_configuration" "kaiocm-terraform-lc" {
  image_id = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    service httpd start
    chkconfig httpd on   
    echo "My web server configured with Terraform!" > /var/www/html/index.html # Create a file called index.html in the webserver's root directory 
    EOF

#   subnet_id = "subnet-c2e2cd9a" # PRIVATE-AZ-2C

  security_groups = [aws_security_group.kaioc-terraform-sg.id]
  iam_instance_profile = "PingInstanceRole" # has some safety policies from hp

 lifecycle {
 create_before_destroy = true
 }
}

# auto-scaling group
resource "aws_autoscaling_group" "kaiocm-terraform-asg" {
  launch_configuration = aws_launch_configuration.kaiocm-terraform-lc.name
  vpc_zone_identifier = ["subnet-5f359a38", "subnet-4a32f303"]
  min_size = 2
  max_size = 4
  target_group_arns = [aws_lb_target_group.kaioc-terraform-tg.arn]
  health_check_grace_period = 300
  health_check_type = "ELB"
  # health_check_type = "EC2"

  tag {
    key = "Name"
    value = "kaiocm-terraform-asg"
    propagate_at_launch = true
  }
}

# load balancer
resource "aws_lb" "kaioc-terraform-lb" {
 name = "kaiocm-terraform-lb"
 internal = true
 load_balancer_type = "application"
 subnets = ["subnet-5f359a38", "subnet-4a32f303"]
 security_groups = [aws_security_group.kaioc-terraform-sg.id,"sg-adb5a8d5"] #HP-Core
 enable_deletion_protection = false
}

# lb listener

resource "aws_lb_listener" "kaioc-terraform-lblistener" {
 load_balancer_arn = aws_lb.kaioc-terraform-lb.arn
 port = 80
 protocol = "HTTP"

 default_action {
 type = "fixed-response"

   fixed_response {
   content_type = "text/plain"
   message_body = "404: page not found"
   status_code = 404
   }
 }
}

# target group

resource "aws_lb_target_group" "kaioc-terraform-tg" {
 name = "kaioc-terraform-tg"
 port = 80
 protocol = "HTTP"
 vpc_id = "vpc-faf77d9d"

 health_check {
   path = "/"
   protocol = "HTTP"
   matcher = "200"
   interval = 25
   timeout = 5
   healthy_threshold = 2
   unhealthy_threshold = 2
 }
}

# lb listener rule

resource "aws_lb_listener_rule" "kaioc-terraform-lrule" {
  listener_arn = aws_lb_listener.kaioc-terraform-lblistener.arn
  priority = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.kaioc-terraform-tg.arn
  }
}

# url

output "alb_dns_name" {
 value = aws_lb.kaioc-terraform-lb.dns_name
 description = "The domain name of the load balancer"
}

# security group
resource "aws_security_group" "kaioc-terraform-sg" {
  name = "kaioc-terraform-sg"
  vpc_id = "vpc-faf77d9d"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"] # hp subnets + hp vpn
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"] # inside out
  }
  tags = {
    Name = "kaioc-terraform-sg"
  }
}