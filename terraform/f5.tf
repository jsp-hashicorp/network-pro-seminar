resource "random_string" "password" {
  length  = 10
  special = false
}

data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["${var.f5_ami_search_name}"]
  }
}

resource "aws_instance" "f5" {

  ami = "${data.aws_ami.f5_ami.id}"
  instance_type               = "m5.xlarge"
  private_ip                  = "10.0.0.200"
  associate_public_ip_address = true
  subnet_id                   = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids      = ["${aws_security_group.f5.id}"]
  user_data                   = "${data.template_file.f5_init.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.bigip.name}"
  key_name                    = "${aws_key_pair.demo.key_name}"
  root_block_device { delete_on_termination = true }

  tags = {
    Name = "${var.prefix}-f5-bigip"
    Env  = "consul"
  }

}


data "template_file" "f5_init" {
  template = "${file("../scripts/f5.tpl")}"

  vars = {
    password = random_string.password.result
  #  s3_bucket = "${aws_s3_bucket.s3_bucket.id}"
  }
}

/*
# Add Configuration to Consul as access
resource "consul_key_prefix" "f5" {
  # Prefix to add to prepend to all of the subkey names below.
  path_prefix = "f5/config"
  depends_on = [aws_instance.consul]
  
  subkeys = {
    "public_ip"       = "${aws_eip.f5.public_ip}"
    "username"        = "admin"
    "password"        = "${random_string.password.result}"
    "user_interface"  = "https://${aws_eip.f5.public_ip}:8443"
  }
}
*/
