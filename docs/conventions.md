# Convenções do Repositório

Documento de referência para operação e crescimento do `dev-workspace`. O objetivo é eliminar dependência de conhecimento tácito — qualquer mantenedor ou agente deve conseguir operar o repositório lendo este arquivo.

---

## 1. Convenção de Nomes

O padrão é `kebab-case` minúsculo sem acentos. Aplicado a:

- Arquivos Markdown (`.md`): `onboarding-projetos.md`, `adr-001-docker-core.md`
- Scripts Bash (`.sh`): `daily-check.sh`, `worklog-start.sh`
- Arquivos de configuração (`.yaml`, `.json`, `.toml`): `tools.yaml`, `pre-commit-config.yaml`
- Diretórios novos: `meu-modulo/`, `cloud-setup/`

**Exceções preservadas por convenção de ferramenta:**

| Arquivo | Motivo |
|---|---|
| `Makefile` | Convenção GNU make |
| `Dockerfile` | Convenção Docker |
| `README.md` | Convenção GitHub |
| `CONTRIBUTING.md` | Convenção GitHub |
| `AGENTS.md` | Convenção raiz do workspace |
| `GEMINI.md` | Convenção raiz do workspace |

**Padrões por linguagem:**

| Contexto | Padrão |
|---|---|
| Módulos Python | `snake_case` — `api_client.py` |
| Componentes React/TypeScript | `PascalCase` — `UserCard.tsx` |
| Utilitários Node/TS | `kebab-case` — `format-date.ts` |

**Proibido:** `UPPERCASE` em nomes de arquivo, sufixos genéricos (`-v2`, `-novo`, `-temp`), underscores em nomes de diretório de módulo.

---

## 2. Regra de Uso do `make`

O `Makefile` da raiz é o entrypoint da plataforma. Não é para ser copiado para outros projetos.

| Contexto | O que executar |
|---|---|
| Dentro de `dev-workspace/` | `make bootstrap`, `make doctor`, `make morning`, `make adopt` |
| Dentro de um projeto adotado | `make lint`, `make test`, `make dev` (do Makefile do projeto) |
| Qualquer outro diretório | Nunca executar `make` sem path explícito |

Para acionar o `Makefile` do workspace fora do diretório raiz:
```bash
make -C ~/labs/dev-workspace <target>
```

---

## 3. O que Nunca Vai para o Git

Regras absolutas de exclusão — qualquer exceção é violação de segurança:

- Credenciais, tokens, chaves de API e senhas (em qualquer formato)
- Arquivos `.env` com valores reais (apenas `.env.example` é versionado)
- Binários compilados e artefatos de build
- Arquivos de estado do Terraform (`.tfstate`, `.tfstate.backup`)
- Diretórios de cache e temporários (`__pycache__/`, `.cache/`, `node_modules/`)
- Relatórios gerados em runtime (`sanidade-ambiente/reports/`)
- Conteúdo privado de worklogs (se aplicável à política pessoal)

A configuração está em `.gitignore` e reforçada pelo hook `gitleaks` no `pre-commit`.

---

## 4. Regra para Templates

O diretório `templates/` contém blueprints arquiteturais reutilizáveis. Regras de uso:

- Templates são **modelos de referência**, nunca instâncias diretas.
- Nunca adicionar `backend`, `provider` ou valores de ambiente diretamente em `templates/`.
- Para usar um template: copiar para o diretório de destino correto e parametrizar localmente.
  - IaC real: `gestao-centralizada-agents/infra/<nome-do-lab>/`
  - Projeto novo: diretório do projeto, via `make adopt`
- Templates não devem ter state. Variáveis de ambiente vão em `envs/<env>/terraform.tfvars`.

---

## 5. Regra para Adoção de Projeto

Para aplicar governança do workspace em um projeto externo existente:

```bash
make adopt TARGET=~/labs/projetos/meu-projeto
```

O target `adopt` aplica:
- Cópia do `Makefile` base com targets de `lint`, `test` e `dev`
- Instalação do `pre-commit` com os hooks padrão do workspace
- Criação do `.gitignore` base

Após adoção, o projeto opera de forma autônoma. O `dev-workspace` não gerencia o estado interno de projetos adotados.

---

## 6. Regra para Segredos

- Zero credenciais hardcoded em qualquer arquivo do repositório.
- Variáveis sensíveis são passadas por variáveis de ambiente do sistema (`TF_VAR_`, `export VAR=`).
- Em pipelines CI/CD: usar GitHub Secrets injetados como variáveis de ambiente.
- Localmente: usar gerenciador de senhas (`pass`) ou arquivo `.env` nunca versionado.
- O hook `gitleaks` bloqueia commits com padrões de credencial detectados.

---

## 7. Onde Ficam os Documentos

| Tipo de documento | Diretório correto |
|---|---|
| Guias operacionais, rotinas, checklists | `runbooks/` |
| Decisões arquiteturais (ADRs) | `reference-docs/adr/` |
| Políticas normativas (segredos, naming, env vars) | `reference-docs/` |
| Guia de contribuição | `CONTRIBUTING.md` (raiz) |
| Mapa estrutural e critérios de sucesso | `docs/` |
| Documentação de módulo específico | `<modulo>/README.md` |
| Planejamento e gestão de agentes | `gestao-centralizada-agents/` |

**Regra de decisão rápida:**

- É ação recorrente com passos definidos? → `runbooks/`
- É decisão, política ou contrato normativo? → `reference-docs/`
- É documentação de referência do repo como produto? → `docs/`
- É específico de um módulo? → `<modulo>/README.md`
