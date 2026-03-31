# Evidência Prática — dev-workspace como Case de Engenharia

Este documento descreve o que o repositório resolve, o que foi automatizado e o que pode ser demonstrado de forma objetiva.

---

## 1. O Problema Antes

Sem um repositório de plataforma, a realidade de uma workstation de engenharia era:

- **Máquina nova = horas perdidas:** Cada setup começava do zero com instalações manuais, sequência dependente de memória e ausência de validação.
- **Drift acumulado:** Ferramentas com versões divergentes entre máquinas ou ao longo do tempo, sem rastreabilidade.
- **Dotfiles espalhados:** Configurações de editor, shell e terminal copiadas manualmente ou recriadas do zero.
- **Onboarding de projetos inconsistente:** Cada projeto novo sem padrão de lint, sem pre-commit, sem Makefile.
- **Ausência de validação:** Sem forma sistemática de confirmar se o ambiente estava operacional antes de iniciar o trabalho.
- **Segredos em risco:** Sem gate automatizado para detectar credenciais expostas antes de um commit.

---

## 2. O que Foi Automatizado

| Área | O que era manual | O que foi automatizado |
|---|---|---|
| Setup de máquina | Instalação item a item | `make bootstrap` via Ansible (idempotente) |
| Dotfiles | Cópia manual de configs | GNU Stow via playbook Ansible |
| Runtimes | `nvm`, `pyenv` locais sem padrão | ASDF com `.tool-versions` versionado |
| Validação | Nenhuma | `make doctor` com checagem sistemática de dependências |
| Linting e segurança | Opcional, inconsistente | `pre-commit` com gitleaks, tflint, tfsec, shellcheck |
| Infra local | Containers soltos por projeto | `infra-core/` com rede unificada e containers compartilhados |
| Rotina diária | Sem registro estruturado | `rotina-devops/` com worklog, abertura e fechamento via `make` |
| Adoção de projetos | Setup manual por projeto | `make adopt TARGET=<path>` |

---

## 3. Tarefas que Ficaram Reproduzíveis

- Configurar uma máquina Ubuntu/Debian do zero sem improviso.
- Garantir que git, ssh, docker, python e node estejam nas versões corretas.
- Validar o ambiente antes de iniciar trabalho com resultado binário: `[OK]` ou `[FAIL]`.
- Iniciar e registrar o dia de trabalho sem abrir nenhuma ferramenta externa.
- Adicionar um projeto ao padrão de governança em um único comando.
- Detectar credenciais expostas antes de qualquer push.

---

## 4. Entrypoints Estáveis

Estes comandos são o contrato operacional do repositório. Não mudam com o tempo:

| Comando | O que estabiliza |
|---|---|
| `make bootstrap` | Setup completo da máquina a partir de zero |
| `make doctor` | Diagnóstico objetivo do estado do ambiente |
| `make lint` | Validação de segurança e estilo antes de qualquer commit |
| `make morning` | Início de dia padronizado com check + worklog |
| `make infra-up` | Infraestrutura local funcional em um comando |
| `make adopt TARGET=<path>` | Governança aplicada a um projeto externo |

---

## 5. Riscos Operacionais Reduzidos

| Risco | Mecanismo de mitigação |
|---|---|
| Credencial exposta no git | `gitleaks` via pre-commit bloqueia o commit |
| Script shell com bug silencioso | `shellcheck` valida antes do merge |
| IaC com misconfiguration | `tflint` e `tfsec` rodam no pre-commit |
| Ferramenta ausente descoberta tarde | `make doctor` reporta no início do dia |
| Conflito de porta entre serviços locais | `infra-core/` centraliza bancos com rede interna |
| Setup de máquina não reproduzível | Ansible idempotente com estado declarado |

---

## 6. O que Este Repositório Prova em Termos de DevOps

**Infraestrutura como código aplicada localmente:** O ambiente de desenvolvimento é tratado como infraestrutura gerenciada, com estado declarado e provisionamento idempotente via Ansible.

**Platform thinking:** O repositório não resolve apenas um problema pontual. Define padrões que se propagam para outros projetos via `make adopt`, cria uma rede interna de serviços compartilhados e centraliza convenções.

**Shift-Left Security:** A validação de segurança ocorre antes do commit, não na pipeline de CI. `gitleaks`, `tflint`, `tfsec` e `shellcheck` são gates locais.

**Reprodutibilidade:** Um clone do repositório em uma máquina limpa deve produzir o mesmo estado após `make bootstrap`. Isso é verificável via `make doctor`.

**Redução de atrito operacional:** O `Makefile` como entrypoint único elimina a necessidade de memorizar sequências de comandos. Qualquer tarefa operacional tem um atalho documentado.

**Observabilidade local:** `make morning` e `make doctor` fornecem visibilidade sobre o estado do ambiente antes de qualquer trabalho começar.

---

## 7. Demonstração Narrativa (Para Entrevistas)

> "Meu `dev-workspace` é uma plataforma local de engenharia que trata a workstation como infraestrutura gerenciada. Um único comando — `make bootstrap` — instala ferramentas, configura dotfiles, ativa pre-commit e sobe containers locais de forma idempotente via Ansible. O `make doctor` valida o ambiente com resultado binário. O `make lint` roda gitleaks, tflint, tfsec e shellcheck antes de qualquer commit. A infra local — Postgres, Redis, ChromaDB, MLFlow — opera numa rede interna Docker compartilhada, sem conflito de porta. Existe uma rotina matinal automatizada e um sistema de worklog via terminal. Qualquer projeto novo pode ser adotado no padrão da plataforma com `make adopt`."

Esse repositório responde a 8 de 8 critérios de case forte:

| Critério | Status |
|---|---|
| Resolve um problema claro | Sim — drift de ambiente e setup manual |
| Tem arquitetura explicada | Sim — `docs/structure-map.md`, README |
| Tem fluxo de bootstrap reprodutível | Sim — `make bootstrap` + Ansible |
| Valida o ambiente | Sim — `make doctor`, `make lint` |
| Reduz ação manual | Sim — Makefile, Ansible, pre-commit, adoção |
| Tem convenções explícitas | Sim — `docs/conventions.md`, AGENTS.md |
| É seguro para uso diário | Sim — gitleaks, tflint, tfsec, shellcheck |
| Outra pessoa consegue entender e executar | Sim — README, runbooks, READMEs por módulo |
