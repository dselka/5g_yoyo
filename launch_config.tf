resource "aws_launch_configuration" "web" {
  name_prefix = "web-"
image_id = "ami-0c7217cdde317cfec" 
  instance_type = "t2.micro"
  key_name = "tests"
security_groups = [ "${aws_security_group.demosg2.id}" ]
  associate_public_ip_address = true
  user_data = "${file("data.sh")}"
lifecycle {
    create_before_destroy = true
  }
}


# Creating Security Group for EC2
resource "aws_security_group" "demosg2" {
  name        = "Demo Security Group 2"
  description = "Demo Module 2"
  vpc_id      = "${aws_vpc.demovpc.id}"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}