# Portfolio Index — Diego Santos

Índice dos projetos e repositórios que compõem a evidência técnica de engenharia.

---

## dev-workspace — Plataforma Local de Engenharia

**Repositório:** `platform/dev-workspace`
**Categoria:** Platform Engineering / DevOps / Automação

### Posição no Portfólio

Este é o ativo operacional mais forte do portfólio em termos de evidência de engenharia de plataforma. Demonstra capacidade de tratar a infraestrutura local como código, aplicar governança e reproduzir ambientes de forma confiável.

### O que Demonstra

| Competência | Evidência no Repositório |
|---|---|
| Base operacional imediata | `make bootstrap` provê ambiente funcional do zero em uma máquina limpa |
| Automação de infraestrutura | Ansible idempotente para provisionamento de workstation |
| Platform thinking | Padrões que se propagam para outros projetos via `make adopt` |
| Governança local | Convenções explícitas (`docs/conventions.md`, `AGENTS.md`) |
| Shift-Left Security | gitleaks, tflint, tfsec, shellcheck via pre-commit |
| Reprodutibilidade | Estado declarativo verificável via `make doctor` |
| Ambiente de desenvolvimento confiável | Infra core unificada, rotina matinal automatizada, worklogs |

### Documentos de Referência

- [`docs/case-evidence.md`](docs/case-evidence.md) — prova prática de valor
- [`docs/structure-map.md`](docs/structure-map.md) — mapa arquitetural
- [`docs/success-criteria.md`](docs/success-criteria.md) — critérios objetivos de validação
- [`docs/conventions.md`](docs/conventions.md) — convenções e governança
- [`manifests/tools.yaml`](manifests/tools.yaml) — contrato explícito do toolchain

### Critérios de Case Forte (Autoavaliação)

Responde sim para todos os 8 critérios definidos:
resolve problema claro, tem arquitetura explicada, bootstrap reprodutível, valida ambiente, reduz ação manual, tem convenções explícitas, é seguro para uso diário, é compreensível por terceiros.

---

## Outros Projetos

*(Adicionar demais projetos aqui conforme avançam)*
