# DevOps Workspace — Baseline Operational

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Pre-commit](https://img.shields.io/badge/Pre--commit-Quality-2F363D?style=for-the-badge)

Workspace central para automação de workstation, infraestrutura as-code e rotina operacional de engenharia.

## Para que serve
- **Padronização:** Garante que todo notebook de desenvolvimento tenha as mesmas ferramentas e versões.
- **Automação:** Provisiona via Ansible pacotes de sistema, dotfiles, runtimes (ASDF) e infra core (Docker).
- **Governança:** Estabelece ritos diários (worklogs) e padrões de segurança (pre-commit/gitleaks).
- **Agentes:** Prover infraestrutura para execução de agentes de IA com skills centralizadas.

## Pré-requisitos
- **Ubuntu 22.04+** ou **Debian 12+**.
- Acesso **sudo** (instalação de pacotes).
- Chave **SSH** (`~/.ssh/id_ed25519`) autorizada no GitHub.
- Conexão estável com a internet.

## Onboarding (7 Passos)
```bash
git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace
cd ~/labs/dev-workspace
make help
make setup-workstation
make doctor
make lint
make morning
```

## Comandos Principais
| Comando | Descrição |
|---|---|
| `make morning` | Inicia o dia: check de sanidade + abertura de worklog |
| `make doctor` | Diagnóstico completo do ambiente e dependências |
| `make lint` | Executa validação de estilo e segurança (Shift-Left) |
| `make log` | Adiciona entrada rápida no worklog diário |
| `make day-close` | Encerra o dia, consolida notas e faz push |
| `make infra-up` | Sobe serviços core (Postgres, Redis, ChromaDB, MLFlow) |

## Troubleshooting & Falhas
- **`make doctor` falhou:** Verifique a lista de ferramentas ausentes. Rode `make setup-workstation` novamente ou instale manualmente o item reportado como `[FAIL]`.
- **`make lint` falhou:** Corrija os erros reportados (whitespaces, segredos expostos, erros de yaml). O `pre-commit` é bloqueante.
- **`make morning` não abre o worklog:** Verifique se o diretório `rotina-devops/worklog/daily` existe e se você tem o VS Code (`code`) no PATH.
- **Erro de permissão no Docker:** Garanta que seu usuário está no grupo `docker` (o setup faz isso, mas requer logout/login).

---
**Em caso de falha crítica:**
1. Execute `make doctor` e salve o output.
2. Verifique os logs em `~/.cache/devops-reports/`.
3. Consulte `docs-referencia/ONBOARDING_GUIDE.md` para erros conhecidos.
