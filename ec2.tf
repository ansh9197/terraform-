# key pair login
resource "aws_key_pair" "my_key" {
    key_name = "ansh-key-ec2"
    public_key = file("ansh-key-ec2.pub")
}
#default vpc
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
# aws security groups
resource "aws_security_group" "my_security_groups" {
  name        = "terra-sg"
  description = "tf generated sg"
  vpc_id      = aws_default_vpc.default.id
#inbound rules
ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
}
ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
}
#outbound rules
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access"
}
  tags = {
    Name = "allow_tls"
  }
}
#ec2 instance 
resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [ aws_security_group.my_security_groups.name]
    instance_type = "t2.micro"
    ami = "ami-04f167a56786e4b09"
root_block_device {
  volume_size = 8
  volume_type = "gp3"
}
  tags = {
    name = "terra-automate"
  }
}