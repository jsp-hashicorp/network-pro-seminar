provider "aws" {
  region = var.region
}

provider "consul" {
  address    = "http://${aws_instance.consul.public_ip}:8500"
  datacenter = var.consul_dc
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Canonical 679593333241
}
