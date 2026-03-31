# DevOps Workspace — Plataforma Local de Engenharia

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Pre-commit](https://img.shields.io/badge/Pre--commit-Security-2F363D?style=for-the-badge) ![Shell](https://img.shields.io/badge/Shell-Validated-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

---

## 1. Problema

Máquinas de desenvolvimento acumulam inconsistências ao longo do tempo: ferramentas instaladas manualmente, versões divergentes entre ambientes, dotfiles fora de controle de versão, ausência de validação automatizada e onboarding dependente de memória operacional.

O resultado prático é **drift de ambiente** — a máquina funciona, mas de forma não reproduzível. Cada reconfiguração consome tempo, gera erros silenciosos e aumenta o atrito entre desenvolvimento local e pipelines de CI/CD.

---

## 2. Objetivo

Tratar a workstation como infraestrutura gerenciada. O repositório define, de forma declarativa e idempotente, o estado esperado do ambiente de desenvolvimento: ferramentas instaladas, configurações versionadas, serviços core ativos e rotinas operacionais padronizadas.

O entrypoint é único: `make`.

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

## What this repository demonstrates

This repository is a personal engineering platform built to manage a development workstation as managed infrastructure. It serves as a practical demonstration of the following capabilities:

| Capability | Implementation |
|---|---|
| Workstation bootstrap | Idempotent provisioning via Ansible (`make bootstrap`) |
| Environment standardization | ASDF runtimes, GNU Stow dotfiles, unified toolchain manifest |
| Automation via Make + Ansible | Single entrypoint (`make`) for all platform operations |
| Validation and troubleshooting | `make doctor` for environment diagnosis; runbooks for incident response |
| Security shift-left | gitleaks, tflint, tfsec, shellcheck enforced via pre-commit hooks |
| Reusable developer platform patterns | `make adopt` propagates governance to external projects; shared `infra-core/` network |

Full case documentation: [`docs/case-evidence.md`](docs/case-evidence.md)
