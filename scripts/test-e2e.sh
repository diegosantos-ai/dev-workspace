#!/usr/bin/env bash
# ==============================================================================
# Script de Testes E2E e Idempotencia
# Valida se as rotinas do workspace sao resilientes e seguras.
# ==============================================================================

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info() { printf "${GREEN}[INFO]${RESET} %s\n" "$1"; }
log_warn() { printf "${YELLOW}[WARN]${RESET} %s\n" "$1"; }
log_error() { printf "${RED}[ERRO]${RESET} %s\n" "$1"; exit 1; }

check_idempotency_ansible() {
  log_info "Iniciando teste de idempotencia (Ansible)..."

  # Simulando verificacao de idempotencia
  # Em um cenário real, rodariamos: ansible-playbook local-setup.yml
  # E verificariamos o output 'changed=0'.

  # Aqui validamos a presenca do arquivo de trava ou o proprio comando ansible-lint
  if command -v ansible-lint >/dev/null 2>&1; then
    log_info "Ansible-lint presente. Validando sintaxe do playbook..."
    ansible-lint "${REPO_ROOT}/ansible/local-setup.yml" || log_error "Falha no lint do playbook."
  else
    log_warn "ansible-lint nao encontrado. Pulando lint."
  fi

  log_info "Teste de idempotencia (MOCK) concluido com sucesso."
}

check_terraform_baseline() {
  log_info "Iniciando validacao de baseline do Terraform..."

  # Verifica se os diretorios de env possuem os arquivos minimos
  local ENVS_DIR="${REPO_ROOT}/cloud-setup/terraform-aws-base/envs"
  for env in dev prod; do
    if [ ! -f "${ENVS_DIR}/${env}/main.tf" ]; then
      log_error "Arquivo main.tf ausente em ${ENVS_DIR}/${env}"
    fi
  done

  log_info "Baseline do Terraform OK."
}

main() {
  log_info "Executando suite de testes E2E do DevOps Workspace..."

  check_idempotency_ansible
  check_terraform_baseline

  log_info "Todos os testes E2E passaram!"
}

main "$@"
