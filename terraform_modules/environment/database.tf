resource "random_shuffle" "random-private-subnet" {
  input = aws_subnet.default_private.*.id
  result_count = 1
}

resource "aws_eip" "database" {
  depends_on = [aws_instance.database]
  instance = aws_instance.database.id
  domain = "vpc"
  tags = {
    "Name":"${var.stage}-db-eip"
  }
}

resource "aws_instance" "database" {
  depends_on = [aws_key_pair.deployer]
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = random_shuffle.random-private-subnet.result[0]

  root_block_device {
    volume_size = 20 # 20GB EBS storage
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.stage}-db"
  }
}