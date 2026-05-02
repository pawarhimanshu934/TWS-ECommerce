
#Create key pair for EC2 instance
resource "aws_key_pair" "aws_key" {
    key_name   = "terraform-key"
    public_key = file("${path.module}/terra-key.pub")
}

#data source to get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#Create default VPC
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}

#Create security group for EC2 instance
resource "aws_security_group" "ec2-sg" {
    vpc_id = aws_default_vpc.default_vpc.id
  
    tags = {
      Name = "EC2 Security Group"
    }
}

#Allow inbound traffic on port 8080 for Jenkins and port 22 for SSH
resource "aws_vpc_security_group_ingress_rule" "allow_jenkins" {
    security_group_id = aws_security_group.ec2-sg.id
    ip_protocol = "tcp"
    from_port        = 8080
    to_port          = 8080
    cidr_ipv4       = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.ec2-sg.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_ipv4 = "0.0.0.0/0"
}

#Allow all outbound traffic from the security group
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.ec2-sg.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}


#Create EC2 instance for Jenkins server
resource "aws_instance" "jenkins" {
  key_name   = aws_key_pair.aws_key.key_name
  ami       = data.aws_ami.ubuntu.id
  security_groups = [aws_security_group.ec2-sg.name]
  instance_type = var.instance_type

  user_data = file("${path.module}/install_tools.sh")


  tags = {
    Name = "Jenkins Server"
  }
}