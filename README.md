# DevOps Workspace

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

## Regra de Uso do `make`

Leia assim:

- Se você está em `~/labs/dev-workspace`, o `make` que vale é o do workspace.
- Se você está dentro de um projeto seu, o `make` que vale é o do projeto.
- Não rode `make <target>` puro na `HOME`.
- Não copie `Makefile` manualmente entre repositórios.

Tabela rápida:

| Onde você está | O que pode rodar | Observação |
|---|---|---|
| `~/labs/dev-workspace` | `make bootstrap`, `make doctor`, `make morning`, `make adopt ...` | Opera a máquina e a plataforma |
| `~/labs/projetos/meu-projeto` | `make lint`, `make test`, `make dev` | Só depois que esse projeto tiver o próprio `Makefile` |
| `~/home/diego` ou qualquer pasta aleatória | `make <target>` puro: **não** | Se precisar, use `make -C ~/labs/dev-workspace <target>` |

## Onboarding
```bash
git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace
cd ~/labs/dev-workspace
make help
make bootstrap
make doctor
make lint
make morning
```

`make bootstrap` é o fluxo padrão de onboarding. `make setup-workstation` permanece para reprovisionar apenas a workstation. `make setup` existe apenas como alias de compatibilidade para `make setup-workstation`.

Depois que a máquina estiver preparada, o próximo passo não é continuar rodando tudo no `dev-workspace`. O fluxo correto é:

1. entrar no projeto que você quer trabalhar;
2. garantir que ele tenha governança e `Makefile`;
3. rodar o `make` desse projeto.

Exemplo:

```bash
cd ~/labs/dev-workspace
make adopt TARGET=~/labs/projetos/meu-projeto

cd ~/labs/projetos/meu-projeto
make lint
make test
```

## Comandos Principais
| Comando | Descrição |
|---|---|
| `make bootstrap` | Onboarding: workstation, runtimes, pre-commit e agentes |
| `make setup-workstation` | Provisiona apenas workstation, dotfiles e toolchain |
| `make doctor` | Diagnóstico completo do ambiente e dependências |
| `make lint` | Executa validação de estilo e segurança (Shift-Left) |
| `make morning` | Inicia o dia: check de sanidade + abertura de worklog |
| `make log` | Adiciona entrada rápida no worklog diário |
| `make day-close` | Encerra o dia, consolida notas e faz push |
| `make infra-up` | Sobe serviços core (Postgres, Redis, ChromaDB, MLFlow) |

## Troubleshooting & Falhas
- **`make doctor` falhou:** Verifique a lista de ferramentas ausentes. Rode `make setup-workstation` novamente ou instale manualmente o item reportado como `[FAIL]`.
- **`make lint` falhou por contexto Git:** Garanta que o comando foi executado a partir do clone real do workspace ou use `make -f /caminho/para/dev-workspace/Makefile lint`.
- **`make lint` falhou no `pre-commit`:** Corrija os erros reportados. O target valida primeiro se a raiz calculada pelo `Makefile` pertence a um repositório Git válido.
- **`make morning` não abre o worklog:** Verifique se o diretório `rotina-devops/worklog/daily` existe e se você tem o VS Code (`code`) no PATH.
- **Erro de permissão no Docker:** Garanta que seu usuário está no grupo `docker` (o setup faz isso, mas requer logout/login).

---
**Em caso de falha crítica:**
1. Execute `make doctor` e salve o output.
2. Verifique os logs em `~/.cache/devops-reports/`.
3. Consulte `docs-referencia/onboarding-guide.md` para erros conhecidos.
