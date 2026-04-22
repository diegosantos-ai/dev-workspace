resource "terraform_data" "teste" {
  input = "provider ovh carregado em producao"
}

output "mensagem" {
  value = terraform_data.teste.input
}
