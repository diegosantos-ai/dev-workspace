# Separação de Documentação: Runbooks e Reference Docs

Este documento define a regra de classificação para todo documento novo criado no repositório. O objetivo é que cada arquivo entre em um lugar óbvio, sem ambiguidade.

---

## Critério de Separação

A divisão central é entre **ação** e **referência**:

| Pergunta | Diretório |
|---|---|
| Este documento descreve **o que fazer** em uma situação recorrente? | `runbooks/` |
| Este documento define **uma política, padrão ou decisão** de arquitetura? | `reference-docs/` |

---

## `runbooks/` — Documentação Operacional

Contém guias orientados à execução. O leitor abre um runbook para realizar uma tarefa específica, não para consultar definições.

**Características:**
- Escrito na segunda pessoa ou em forma de passos sequenciais.
- Inclui comandos executáveis e critérios de verificação.
- Atualizado quando o procedimento muda, não quando a política muda.

**Exemplos de conteúdo:**

| Documento | Descrição |
|---|---|
| `onboarding.md` | Passo a passo para configurar uma máquina nova do zero |
| `manutencao-infra-core.md` | Procedimento para reinicializar, atualizar ou migrar containers core |
| `rotina-diaria.md` | Sequência de comandos da rotina matinal e encerramento do dia |
| `checklist-deploy-vps.md` | Validações antes e depois de um deploy em VPS |
| `recuperacao-docker.md` | Passos para restaurar Docker após falha crítica do daemon |

---

## `reference-docs/` — Documentação Normativa

Contém políticas, padrões e registros de decisão. O leitor consulta `reference-docs/` para entender **por que** algo funciona de determinada forma ou qual é a regra vigente.

**Características:**
- Escrito de forma declarativa e normativa.
- Não inclui tutoriais passo a passo.
- Atualizado quando uma decisão ou política é revisada.
- ADRs (`adr/`) registram decisões arquiteturais com contexto e consequências.

**Exemplos de conteúdo:**

| Documento | Descrição |
|---|---|
| `adr/adr-001-docker-core.md` | Decisão de centralizar bancos em `infra-core/` |
| `politica-segredos.md` | Regras sobre onde e como armazenar credenciais |
| `politica-versionamento.md` | Estratégia de branches, tags e releases |
| `padroes-env-vars.md` | Convenção de nomenclatura para variáveis de ambiente |
| `naming.md` | Padrão de nomes de arquivos, diretórios e recursos |
| `limites-escopo.md` | O que o repositório não cobre e por quê |

---

## Regra para Documentos Híbridos

Se um documento mistura procedimento e política, separe os conteúdos:

1. A parte de **execução** vai para `runbooks/` como guia operacional.
2. A parte de **definição** vai para `reference-docs/` como política ou ADR.

Nunca crie um documento que seja ao mesmo tempo tutorial e norma — isso dificulta manutenção e localização.

---

## Locais Reservados

| Diretório | Não deve conter |
|---|---|
| `runbooks/` | ADRs, políticas, definições abstratas |
| `reference-docs/` | Checklists operacionais, sequências de comandos |
| `docs/` | Runbooks ou políticas — apenas documentação do repo como produto |
