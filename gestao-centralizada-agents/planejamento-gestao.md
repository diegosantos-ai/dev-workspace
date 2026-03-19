# 🗺️ Planejamento de Execução: Gestão Centralizada de Agentes

Este documento divide a implementação da nossa plataforma de IA em fases macro e tarefas atômicas. Siga as tarefas (Tasks) sequencialmente para manter o controle, garantir *idempotência* e evitar quebras no repositório principal.

## Fase 1: Fundação & Tooling Global (Bootstrap)
**Objetivo:** Garantir que o ambiente base (S.O.) tenha as dependências de orquestração de IA instaladas de forma limpa, global e centralizada, sem sujar repositórios individuais.

- [x] **Task 1.1:** Atualizar roles do `ansible/local-setup.yml` (ou playbooks atrelados) para garantir instalação do `pipx` e Docker.
- [x] **Task 1.2:** Criar o script `scripts/setup-agents.sh` que usa o `pipx` para instalar os runtimes globais (ex: motor CLI escolhido) e configurar o diretório `~/.agents-env`.
- [x] **Task 1.3:** Atualizar o `Makefile` na raiz adicionando a regra `setup-agents` (fazendo a ponte para o script configurado acima).

## Fase 2: Plataforma Local & Observabilidade (O Cockpit)
**Objetivo:** Criar a base de execução (containers) onde viverão o orquestrador de workflows, o banco vetorial (memória) e o telemetria (observabilidade) para rastrear custos de tokens e alucinações.

- [x] **Task 2.1:** Criar um `docker-compose.yml` base na pasta da feature (ou em `infra/agents-cockpit/`) provisionando: n8n, Langfuse (ou similar de tracking) e ChromaDB/Qdrant.
- [x] **Task 2.2: Vincular n8n, Langfuse e Qdrant (Híbrido) no Cockpit**
- [x] **Task 2.3: Validar Telemetria Básica**

## Fase 3: Estruturação MCP (Skills & Ferramentas)
**Objetivo:** Abandonar scripts pythons espalhados e criar a base do "Model Context Protocol", permitindo que IDEs e CLI leiam o mesmo diretório de Skills.

- [x] **Task 3.1:** Criar o diretório `/skills-mcp/` na raiz do `dev-workspace` e documentar seu propósito internamente via `README.md`.
- [x] **Task 3.2:** Desenvolver e testar o template da primeira *Skill MCP* (ex: um validador de secrets simplificado que qualquer IA possa consumir).
- [x] **Task 3.3:** Adicionar target `make test-skills` no Makefile para validar se os servidores MCP instanciam corretamente sem quebrar na máquina local.

## Fase 4: Implementação da Tríade MVP de Agentes
**Objetivo:** Instanciar os 3 guardiões da fundação e garantir que apenas interajam dentro da governança do Cockpit, antes de escalarmos para dúzias de outras IAs.

- [x] **Task 4.1:** Desenhar o papel (instruções restritas) do **Agente Orquestrador (Manager)** no sistema.
- [x] **Task 4.2:** Desenhar o papel do **Agente Executor (Criador)**, moldando-o para usar os `/templates/` e seguir a política de *zero-trust*.
- [x] **Task 4.3:** Desenhar o papel do **Agente Crítico (Shift-Left Revisor)**, que acionará o Makefile para lintar e quebrar a build se o Criador errar um yaml.

## Fase 5: Validação End-to-End & Merge
**Objetivo:** Testar se um projeto externo (ex: portfólio) ou o próprio dev-workspace podem se beneficiar da nova matriz, validar a formatação final e fechar a branch.

- [x] **Task 5.1:** Executar do zero: `make setup-agents` → `make start-orquestrador` → `make test-skills` simulando uma máquina recém limpa.
- [x] **Task 5.2:** Executar `make lint` geral no projeto para garantir que as novas adições (scripts `.sh`, `.yml`, `.md`) passaram no pre-commit hook (trailing spaces, etc).
- [x] **Task 5.3:** Consolidar atualizações no `AGENTS.md` (Manifesto Root) referenciando este novo arsenal.
- [x] **Task 5.4:** Commit de encerramento (`chore: implementacao do modulo gestao-centralizada-agents`) e aprovação de PR/Merge na main.
