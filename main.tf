provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test" {
    ami = "ami-00bb6a80f01f03502"
    instance_type = "t2.large"
    key_name = "test_us-west-1-keypair"
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    user_data = templatefile("./install.sh",{})

tags ={
    Name = "test"
}


  root_block_device {
    volume_size = 30
  }

}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
 

  ingress = [
    for port in [22,80,443,8080,9000,80]: {
      description = "inbound rules"
      from_port = port
      to_port = port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false 
    }
  ]


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
}