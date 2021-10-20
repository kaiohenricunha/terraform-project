# provider "aws" {
# region = "us-east-1"
# }



# resource "aws_instance" "felipe" {
# ami = "ami-02e136e904f3da870"
# instance_type = "t2.micro"
# vpc_security_group_ids = [aws_security_group.kaio.id]
# subnet_id= "subnet-5175a71b"
# }



# resource "aws_security_group" "kaio" {



# name = "terraform-test-instance"
# vpc_id = "vpc-f7138f91"



# ingress{
# from_port = 80
# to_port = 80
# protocol = "tcp"
# cidr_blocks = ["0.0.0.0/0"]
# }
# }


# provider "aws" {
#   region = "us-west-2"
# }

# resource "aws_instance" "robertom-terraform-ec2-example" {
#   ami = "ami-0c2d06d50ce30b442"
#   instance_type = "t2.micro"
#   key_name= "robertom-terraform-test"
#    subnet_id = "subnet-5f359a38" # PRIVATE-AZ-2A
#    subnet_id = "subnet-4a32f303" # PRIVATE-AZ-2B
#   subnet_id = "subnet-c2e2cd9a" # PRIVATE-AZ-2C

#   vpc_security_group_ids = [aws_security_group.robertom-terraform-sg-example.id]
#   iam_instance_profile = "PingInstanceRole"
#   user_data = file("./scripts/install_nginx.sh")
#   tags = {
#     Name = "robertom-terraform-ec2-example"
#   }