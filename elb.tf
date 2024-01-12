# Creating Security Group for ELB
resource "aws_security_group" "demosg1" {
  name        = "Demo Security Group"
  description = "Demo Module"
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

resource "aws_s3_bucket" "elb_bucket" {
  bucket = "elka-elb-logs"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  access_logs {
    bucket        = "elka-elb-logs"
    interval      = 5
  }
  security_groups = [
    "${aws_security_group.demosg1.id}"
  ]
  subnets = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]
cross_zone_load_balancing   = true
health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 8
    interval = 60
    target = "HTTP:80/alive"
  }
listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
  depends_on = [aws_s3_bucket_policy.b]
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.elb_bucket.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::127311923021:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::elka-elb-logs/*"
    }
  ]
}
POLICY
}
