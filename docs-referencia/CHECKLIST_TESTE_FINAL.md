# Checklist — Teste Final em Notebook Limpo

Data de congelamento: 2026-03-25
Branch: `chore/freeze-onboarding-baseline`

## 1. Pré-requisitos

- [ ] Ubuntu 22.04 LTS ou Debian 12 (bookworm) instalado
- [ ] Acesso sudo disponível
- [ ] Chave SSH gerada (`~/.ssh/id_ed25519`)
- [ ] Chave SSH adicionada ao GitHub (Settings > SSH Keys)
- [ ] Conexão de rede estável

## 2. Clone e Bootstrap

```bash
git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace
cd ~/labs/dev-workspace
make bootstrap
```

- [ ] Clone concluiu sem erro
- [ ] `make bootstrap` executou Ansible sem falha fatal
- [ ] Docker Desktop instalado: `docker --version`
- [ ] Docker Compose V2 disponível: `docker compose version`
- [ ] Terraform instalado: `terraform --version`
- [ ] AWS CLI instalado: `aws --version`
- [ ] Ollama instalado: `ollama --version`
- [ ] uv instalado: `uv --version`
- [ ] Lazygit instalado: `lazygit --version`
- [ ] ASDF instalado: `asdf --version`
- [ ] Node.js ativo via ASDF: `node --version`
- [ ] Python ativo via ASDF: `python --version`
- [ ] pre-commit hook instalado: `ls .git/hooks/pre-commit`
- [ ] CrewAI instalado via pipx: `crewai --version`
- [ ] Arquivo `~/.agents-env` gerado

## 3. Dotfiles

- [ ] GNU Stow aplicado para `zsh`: `ls -la ~/.zshrc` (deve ser symlink)
- [ ] GNU Stow aplicado para `git`: `ls -la ~/.gitconfig` (deve ser symlink)
- [ ] GNU Stow aplicado para `vscode`: `ls -la ~/.config/Code/User/settings.json` (deve ser symlink)
- [ ] Alias `morning` disponível no shell: `type morning`

## 4. Rotina Diária

```bash
make morning      # deve completar sem erro
make env-check    # deve retornar OK ou apenas WARNs (não FAILs)
make log          # deve abrir prompt interativo de registro
make day-close    # deve consolidar worklog e fazer push
```

- [ ] `make morning` executou sem erro fatal
- [ ] `make env-check` não retornou FAILs estruturais
- [ ] Worklog do dia criado em `rotina-devops/worklog/daily/YYYY-MM-DD.md`
- [ ] `make day-close` fez push para o repositório remoto

## 5. Infraestrutura Core (Opcional no Dia 1)

```bash
make infra-up
docker ps
```

- [ ] Rede `dev-workspace-net` criada
- [ ] `core-postgres` rodando
- [ ] `core-redis` rodando
- [ ] `core-chromadb` rodando

## 6. Shift-Left (Lint)

```bash
make lint
```

- [ ] `make lint` executou sem erros de shellcheck, gitleaks ou yamllint

## 7. Riscos Residuais Conhecidos

| Item | Risco | Impacto |
|---|---|---|
| `gestao-centralizada-agents/skills-mcp` | Depende de Node.js via ASDF. Testar só após confirmar `node --version`. | Baixo (não bloqueia rotina diária) |
| `make infra-up` (MLFlow) | MLFlow faz `pip install psycopg2-binary` na inicialização. Pode ser lento. | Baixo |
| `cloud-setup/terraform-*` | Módulos IaC para AWS e OVH. Não testados nesta baseline. | Fora de escopo |
| SSH para GitHub | Se `~/.ssh/id_ed25519` não existir, `git push` vai falhar. | Deve ser configurado manualmente antes do bootstrap. |

## 8. Itens Explicitamente Adiados

- Configuração real de credenciais em `~/.agents-env` (OpenAI, Anthropic, Langfuse)
- `make test-skills` — validar servidor MCP Node
- Módulos Terraform (`cloud-setup/`)
- `make week-close` — relevante a partir da segunda semana
- `backup-setup/` — diretório vazio, sem conteúdo operacional
