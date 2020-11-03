data "terraform_remote_state" "infra-config" {
  backend = "remote"

  config = {
    organization = "network-pro-webinar"
    workspaces = {
      name = "infra-config"
    }
  }
}


provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = data.terraform_remote_state.infra-config.outputs.F5_IP
  password = data.terraform_remote_state.infra-config.outputs.F5_Password
}
# pin to 1.1.2
#terraform {
#  required_providers {
#    bigip = "~> 1.1.2"
#  }
#}


# download rpm
resource "null_resource" "download_as3" {
  provisioner "local-exec" {
    command = "wget ${var.as3_rpm_url}"
  }
}

# install rpm to BIG-IP
resource "null_resource" "install_as3" {
  provisioner "local-exec" {
    command = "./install_as3.sh ${data.terraform_remote_state.infra-config.outputs.F5_IP}:${var.port} admin:${data.terraform_remote_state.infra-config.outputs.F5_Password} ${var.as3_rpm}"
  }
  depends_on = [null_resource.download_as3]
}

# deploy application using as3
resource "bigip_as3" "nginx" {
  as3_json    = file("nginx.json")
  #tenant_filter = "consul_sd"
  depends_on  = [null_resource.install_as3]
}
