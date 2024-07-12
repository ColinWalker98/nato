resource "aws_instance" "database" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 20 # 20GB EBS storage
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.stage}-db"
  }
}