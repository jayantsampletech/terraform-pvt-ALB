# security group for apache2 
resource "aws_security_group" "private_sg" {
  name   = "private-ec2-sg"
  vpc_id = aws_vpc.ap-south-1-CICD.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For SSH from bastion or your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instance with apache installed 
resource "aws_instance" "ApacheServer" {
  ami                         = var.AMI
  instance_type               = var.INSTANCE_TYPE
  key_name                    = "mackey"
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  subnet_id                   = aws_subnet.ap-south-1-CICD-private-subnet.id
  user_data                   = file("apache.sh")
  tags = {
    Name = "ApacheServer"
  }
  depends_on = [
    aws_nat_gateway.example,
    aws_route_table.ap-south-1-CICDprivateRT
  ]
}