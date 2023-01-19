

//////////////////////////////////Key-pair///////////////////////////////////
resource "aws_key_pair" "stanelykey" {
  key_name   = "${var.aws_key_pair_name}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC53+UNnKrC+hOeFEHvjfOy9tawyNSjZJFXoyFAIIos5khxBB9khwoY8++AFCr77SW8wsvvQZZ5KQUQveEVWhpEKYawK5rxk40a+fYPfmxvOqCY6XolaGi4GsDNZyxmwMB7C83HdRl3hw5ycJaOZRaG2KPCdvRqbwqgsxCTqmVRq+Lj9/VCO1GnUMQk4rm4d2+2rR0/e3lcfsKcAy4iXfvM4AT/tSBeUKIDeyBTPmG+eaB4kISaH5N75c6NGtAlCk+NNusLc2gSBbum8OGDHN2hRqtafQy1e0ZbShd4b1c3fXg04uNTvOb7uWaJ9Cx4hAL+jFjyTBhQE2hEyDDsThhhsB5kSa9ma1Y+PuJbknBrrLXL01+Lyl0VCLWZGMe8OVP4w+fWvbnv5iAVWNM/0nhlyip2eI0QEGBFVbfYBpNsBaLQWmVq37uVHbFblQCyeklbMTVaTYrXNFxR7EwBLh5eeDP3ZKZfI+Fga6H5JzYyVP7wLaaU6u85mz0gvA/Z298= user@DESKTOP-T0QOBLF"
}


///////////////////////////////////EC2/////////////////////////////////////////

resource "aws_instance" "stanely-ec2" {
  ami                       = "ami-06878d265978313ca"
  instance_type             = "t2.micro"
  subnet_id                 = aws_subnet.public-subnet.id
  vpc_security_group_ids    = [aws_security_group.stanely-sg.id]
  key_name                  = "stanelykey"

  tags = {
    name = "${var.app_name}-EC2"
  }
}

//////////////////////////////////EIP////////////////////////////////////////////

resource "aws_eip" "stanely-eip" {
  instance = aws_instance.stanely-ec2.id
  vpc      = true
}
