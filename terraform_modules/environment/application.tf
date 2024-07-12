resource "aws_eip" "application" {
  depends_on = [aws_instance.application]
  instance = aws_instance.application.id
  domain = "vpc"
  tags = {
    "Name":"${var.stage}-app-eip"
  }
}

resource "aws_instance" "application" {
  depends_on = [aws_key_pair.deployer]
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 20 # 20GB EBS storage
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.stage}-app"
  }
}
