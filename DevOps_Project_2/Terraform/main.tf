resource "aws_instance" "dev_machine" {
  ami = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"

  tags = {
    Name = "nginx-machine"
  }
}
