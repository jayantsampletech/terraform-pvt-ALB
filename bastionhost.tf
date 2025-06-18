# security group for apache2 
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-ec2-sg"
  vpc_id = aws_vpc.ap-south-1-CICD.id

  ingress {
    from_port   = 22
    to_port     = 22
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

# Instance as a bastion host
resource "aws_instance" "bastionhost" {
  ami                         = var.AMI
  instance_type               = var.INSTANCE_TYPE
  key_name                    = "mackey"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.ap-south-1-CICD-private-subnet.id
  tags = {
    Name = "bastionhost"
  }
}