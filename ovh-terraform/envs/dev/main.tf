resource "terraform_data" "teste" {
  input = "provider ovh carregado"
}

output "mensagem" {
  value = terraform_data.teste.input
}
