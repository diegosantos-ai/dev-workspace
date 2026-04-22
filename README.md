# DevOps Workspace Central

![Make](https://img.shields.io/badge/GNU_Make-Orchestration-455a64?labelColor=333333&style=flat-square&logo=gnu&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-455a64?labelColor=333333&style=flat-square&logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Automation-455a64?labelColor=333333&style=flat-square&logo=ansible&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containers-455a64?labelColor=333333&style=flat-square&logo=docker&logoColor=white)
![MCP](https://img.shields.io/badge/MCP-AI_Agents-455a64?labelColor=333333&style=flat-square&logo=probot&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-Validated-455a64?labelColor=333333&style=flat-square&logo=gnubash&logoColor=white)
![Security](https://img.shields.io/badge/Shift--Left-Validated-455a64?labelColor=333333&style=flat-square)

---

## 1. Escopo Técnico

Este repositório gerencia o estado declarativo de uma workstation de engenharia. O objetivo é eliminar o drift de ambiente através de provisionamento idempotente, gestão de dotfiles versionados e padronização de runtimes.

A operacionalização é centralizada no `Makefile`, garantindo que toda ação de manutenção seja rastreável e reproduzível.


---

## 3. Arquitetura do Repositório

O repositório é dividido em três camadas:

### Core
| Componente | Função |
|---|---|
| `Makefile` | Entrypoint unificado de todas as operações da plataforma |
| `ansible/` | Provisiona workstation de forma idempotente (pacotes, runtimes, permissões) |
| `dotfiles/` | Configurações de usuário versionadas, espelhadas via GNU Stow |
| `scripts/` | Automações utilitárias validadas por shellcheck |
| `templates/` | Blueprints de IaC, pipelines e configuração para novos módulos |
| `runbooks/` | Procedimentos operacionais para manutenção e resposta a incidentes |

### Apoio
| Componente | Função |
|---|---|
| `reference-docs/` | ADRs, guias de contribuição e documentação de arquitetura |
| `sanidade-ambiente/` | Scripts de validação e diagnóstico do estado do ambiente |

### Módulos Especializados
| Componente | Função |
|---|---|
| `infra-core/` | Orquestração dos containers centrais (Postgres, Redis, ChromaDB, MLFlow) via rede `dev-workspace-net` |
| `rotina-devops/` | Telemetria matinal, worklogs diários e relatórios de ambiente |
| `cloud-setup/` | Provisionamento e configuração de instâncias VPS externas |
| `gestao-centralizada-agents/` | Infra de agentes de IA via MCP: Skills, Personas e servidor central de ferramentas |

Referência completa: [`docs/structure-map.md`](docs/structure-map.md).

---

## 4. Fluxo Principal

```
git clone → make bootstrap → make doctor → make morning → trabalho diário
```

1. `make bootstrap` instala o Ansible, provisiona workstation, ativa dotfiles, configura pre-commit e sobe os serviços core.
2. `make doctor` verifica se todas as dependências críticas estão presentes e operacionais.
3. `make morning` executa o check de sanidade matinal e abre o worklog do dia.
4. Para adotar um projeto existente com governança: `make adopt TARGET=<caminho>`.

---

## 5. Onboarding

**Pré-requisitos:** Ubuntu 22.04+ ou Debian 12+, acesso sudo, chave SSH autorizada no GitHub.

```bash
git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace
cd ~/labs/dev-workspace
make bootstrap
make doctor
make morning
```

Após o bootstrap, o fluxo correto é trabalhar dentro dos projetos individuais, não continuar executando comandos no `dev-workspace`:

```bash
make adopt TARGET=~/labs/projetos/meu-projeto
cd ~/labs/projetos/meu-projeto
make lint && make test
```

**Regra de contexto do `make`:**

| Onde você está | O que rodar |
|---|---|
| `~/labs/dev-workspace` | `make bootstrap`, `make doctor`, `make morning`, `make adopt` |
| `~/labs/projetos/meu-projeto` | `make lint`, `make test`, `make dev` |
| Qualquer outra pasta | Não execute `make` sem path explícito |

---

## 6. Comandos Principais

| Comando | Descrição |
|---|---|
| `make bootstrap` | Onboarding completo: workstation, runtimes, pre-commit e agentes |
| `make setup-workstation` | Reprovisionamento isolado da workstation |
| `make doctor` | Diagnóstico de dependências e integridade do ambiente |
| `make update-report` | Gera um relatorio de atualizacoes disponiveis sem alterar o sistema |
| `make update-tools` | Atualiza ferramentas gerenciadas do workspace e gera relatorio |
| `make update` | Sincroniza o repositorio e aplica a rotina de atualizacao das ferramentas |
| `make lint` | Validação de segurança e estilo (gitleaks, tflint, tfsec, shellcheck) |
| `make morning` | Check de sanidade + abertura do worklog diário |
| `make log` | Registra entrada no worklog do dia |
| `make day-close` | Consolida notas do dia e publica no repositório |
| `make infra-up` | Inicializa os serviços core (Postgres, Redis, ChromaDB, MLFlow) |
| `make adopt TARGET=<path>` | Aplica governança (Makefile, pre-commit) em um projeto externo |
| `make help` | Lista todos os targets disponíveis com descrição |

---

## 7. Critérios de Sucesso

O ambiente está funcional quando:

- `make doctor` retorna sem nenhum `[FAIL]`.
- `make lint` passa sem erros em todos os validadores.
- `make infra-up` sobe os containers sem conflito de porta.
- `make morning` abre o worklog e exibe o relatório de sanidade.
- Um novo clone do repositório em máquina limpa reproduz o mesmo estado após `make bootstrap`.

---

## 8. Troubleshooting

| Sintoma | Ação |
|---|---|
| `make doctor` reporta `[FAIL]` | Rode `make setup-workstation` ou instale o item ausente manualmente |
| `make lint` falha por contexto Git | Execute a partir do clone real ou use `make -C ~/labs/dev-workspace lint` |
| `make lint` falha no `pre-commit` | Corrija os erros reportados pelo linter indicado |
| `make morning` não abre worklog | Verifique se `rotina-devops/worklog/daily` existe e se `code` está no PATH |
| Erro de permissão no Docker | Confirme que o usuário está no grupo `docker` (requer logout/login após o setup) |
| Falha crítica sem diagnóstico claro | Execute `make doctor`, salve o output e consulte `reference-docs/onboarding-guide.md` |

Logs em: `~/.cache/devops-reports/`.

---

## 9. Limites e Escopo

Este repositório é uma **plataforma pessoal/local de engenharia**. Ele não é:

- Um produto SaaS ou ferramenta de uso geral.
- Uma solução multi-tenant ou com autenticação de usuário externo.
- Um substituto para ferramentas de CM corporativas como Chef ou Puppet.

O escopo cobre uma máquina de desenvolvimento (workstation) e, por extensão, instâncias VPS gerenciadas manualmente via `cloud-setup/`. Ambientes de produção em escala exigem arquitetura dedicada.

---

## 10. Roadmap

| Item | Status |
|---|---|
| Bootstrap idempotente via Ansible | Concluído |
| Gestão de dotfiles com GNU Stow | Concluído |
| Infra core unificada (Docker + rede interna) | Concluído |
| Rotina matinal + worklogs automatizados | Concluído |
| Integração de agentes IA via MCP | Em andamento |
| Provisionamento de VPS via `cloud-setup` | Em andamento |
| Documentação arquitetural completa (ADRs) | Em andamento |
| Testes de idempotência automatizados end-to-end | Planejado |

---

Documentação detalhada disponível em [`docs/`](docs/) e [`reference-docs/`](reference-docs/).
