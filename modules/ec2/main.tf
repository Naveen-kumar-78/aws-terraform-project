resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.name}"
    }
  )
}

resource "aws_ebs_volume" "this" {
  count             = var.create_additional_volume ? 1 : 0
  availability_zone = aws_instance.this.availability_zone
  size              = var.additional_volume_size
  type              = var.additional_volume_type

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-${var.name}-extra-vol"
    }
  )
}

resource "aws_volume_attachment" "this" {
  count       = var.create_additional_volume ? 1 : 0
  device_name = var.additional_volume_device_name
  volume_id   = aws_ebs_volume.this[0].id
  instance_id = aws_instance.this.id
}
