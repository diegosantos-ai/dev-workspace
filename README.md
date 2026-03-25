# Platform Engineering Workspace

Repositório central de automação de estação de trabalho, templates de infraestrutura e rotina operacional diária.

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Pre-commit](https://img.shields.io/badge/Pre--commit-Quality-2F363D?style=for-the-badge)

## Objetivo

Prover um ambiente local reproduzível, modular e idempotente para operações de engenharia. Integra provisionamento de workstation, gestão de dotfiles, infraestrutura containerizada compartilhada e rotina diária de trabalho.

## Componentes

| Diretório | Função |
|---|---|
| `ansible/` + `dotfiles/` | Provisionamento declarativo de workstation via Ansible e GNU Stow |
| `infra-core/` | Docker Compose com serviços compartilhados (Postgres, Redis, ChromaDB, MLFlow, Traefik) |
| `rotina-devops/` | Scripts e templates de worklog diário e semanal |
| `sanidade-ambiente/` | Scripts de checagem de ferramentas e auditoria de ambiente |
| `gestao-centralizada-agents/` | Governança de agentes de IA com servidor MCP |
| `templates/` | Esqueletos Terraform para AWS e OVH |
| `docs-referencia/` | ADRs, políticas de secrets, versionamento e guias operacionais |

## Onboarding (Fluxo de 7 Passos)

Para instanciar o ambiente em um notebook limpo, execute exatamente a sequência abaixo:

```bash
# 1. Clonar o repositório
git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace

# 2. Acessar o diretório
cd ~/labs/dev-workspace

# 3. Listar comandos disponíveis
make help

# 4. Provisionar a máquina (requer sudo para pacotes de sistema)
make setup-workstation

# 5. Validar a saúde do ambiente
make doctor

# 6. Rodar auditoria de qualidade inicial
make lint

# 7. Iniciar rotina matinal (sanidade + worklog)
make morning
```

## Operação Diária

```bash
make morning       # Sanidade do ambiente + abertura do worklog do dia
make log           # Registra entrada no worklog (interativo)
make day-close     # Consolida worklog e faz push
make env-check     # Checagem rápida de ferramentas (avulso)
make lint          # Roda pre-commit em todos os arquivos
make infra-up      # Sobe serviços compartilhados (Postgres, Redis, etc.)
make help          # Lista todos os targets disponíveis
```

## Pré-requisitos do Notebook Limpo

- Ubuntu/Debian (dependência do playbook Ansible)
- Acesso sudo para instalação inicial
- Chave SSH configurada no GitHub (`~/.ssh/id_ed25519`)
- Conexão com a internet para download de dependências

## Governança de IA

Qualquer agente de IA operando neste repositório deve ler `GEMINI.md` e `AGENTS.md` antes de executar qualquer ação. Esses arquivos definem comportamento esperado, personas operacionais e restrições de escopo.

---

Leia `docs-referencia/CRITERIOS_MAQUINA_PRONTA.md` para a lista de verificação completa pós-setup.
