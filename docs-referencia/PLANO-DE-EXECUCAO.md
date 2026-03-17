# Plano de Execução: Workspace DevOps "Premium Standard"

Como especialista DevOps, a arquitetura-alvo que buscaremos transforma este repositório de um "guarda-arquivos" para um **Produto de Engenharia de Plataforma (Platform Engineering)**. 
Tudo deve ser **idempotente** (pode rodar 1000 vezes com o mesmo resultado seguro), **reprodutível** (qualquer máquina) e **seguro** (Shift-Left security).

## 🎯 Arquitetura-Alvo & Padrões Adotados
1. **Configuração de Estação (Machine Setup):** Transição de script bash genérico para **Ansible** (Playbooks locais) + **GNU Stow** (para links simbólicos de dotfiles).
2. **Qualidade Contínua (Shift-Left):** Hooks locais obrigatórios (`pre-commit`, `tflint`, `tfsec`, `shellcheck`, `checkov`).
3. **Padrão IaC (Terraform):** Módulos versionados, state remoto (S3/DynamoDB), separação de ambientes por pastas (Terragrunt style ou TF Workspaces) e remoção de qualquer hardcode.
4. **Segurança de Segredos:** Integração com SOPS ou injeção via gerenciador de senhas (1Password/Vault CLI) - zero segredos em disco.
5. **Documentação:** Adoção de **ADRs** (Architecture Decision Records) para registrar o *porquê* das escolhas técnicas.

---

## 🗺️ Fases de Execução

### Fase 1: Fundação & Bootstrap Idempotente (Setup da Nova Máquina)
- **Objetivo:** Garantir que o setup do seu novo notebook seja feito com um comando, instalando pacotes, ferramentas CLI e linkando dotfiles sem erros se executado múltiplas vezes.
- **Ações:**
  - Criar um `ansible/local-setup.yml` (playbook de bootstrap).
  - Refatorar o `setup-machine.sh` para apenas instalar o Ansible e chamar o playbook.
  - Reestruturar a pasta `dotfiles/` para uso com GNU Stow (ex: `stow vscode`).

### Fase 2: Governança de Código & Qualidade Local
- **Objetivo:** Impedir que código ruim (scripts inseguros, Terraform vulnerável) seja commitado.
- **Ações:**
  - Configurar e rodar o `pre-commit` em todos os arquivos atuais.
  - Adicionar detectores de credenciais (`detect-secrets` ou `trufflehog`).
  - Corrigir os alertas que surgirem nos scripts atuais (`check_devops_env.sh`, `setup-machine.sh`).

### Fase 3: Padronização IaC (Terraform Premium)
- **Objetivo:** Elevar os templates AWS e OVH para padrão Enterprise.
- **Ações:**
  - Estruturar a pasta `templates/terraform-aws-base` para módulos reutilizáveis e composição multi-ambiente (`envs/dev`, `envs/prod`).
  - Aplicar `tflint` e `tfsec` em `ovh-terraform` e nos templates, corrigindo vulnerabilidades.
  - Implementar backend padrão usando S3 + DynamoDB com lock para AWS.

### Fase 4: Automação Contínua (CI pipeline)
- **Objetivo:** Automação invisível que ajuda no dia a dia.
- **Ações:**
  - Criar GitHub Actions (ou similar em `.github/workflows`) para linting de CI.
  - CI de "Terraform Plan" automático (Simulação: validar que PRs não quebram infra).

### Fase 5: Documentação de Classe Mundial
- **Objetivo:** Adotar práticas de engenharia de software para documentação de infra.
- **Ações:**
  - Criar estrutura de `docs/adr` (Architecture Decision Records).
  - Melhorar o README raiz com badges de status de build e diagramas de fluxo (Mermaid.js).
