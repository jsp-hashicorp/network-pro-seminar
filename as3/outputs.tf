output "app_url" {
  value = "http://${data.terraform_remote_state.infra-config.outputs.F5_IP}:8080"
}
