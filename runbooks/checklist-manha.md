# Checklist da Manhã — Rotina DevOps

> Objetivo: começar o dia com clareza, controle e prioridade definida.

Regra rápida:
- Se o comando é do workspace, execute em `~/labs/dev-workspace`.
- Se o comando é do projeto, execute dentro do projeto.
- `make` puro na `HOME` não faz parte do fluxo.

## ☀️ Execução Diária (Rotina Operacional)
O ciclo completo de trabalho de um engenheiro dentro da plataforma operando local.

1. **`make morning`** (`rotina-devops/scripts/open-devops-routine.sh`)
   - **Comportamento:** A primeira ação do dia. Automaticamente roda o `env-check` (saúde do docker, git, ssh) e aciona o `day-start` em sequência para forçar o planejamento operacional antes do primeiro commit.
2. **`make env-check`** (`sanidade-ambiente/scripts/daily-check.sh`)
   - **Comportamento:** Pode ser acionado avulso a qualquer momento caso ocorram problemas de rede ou permissão.
3. **`make log`** (`rotina-devops/scripts/worklog-add.sh`)
   - **Comportamento:** Ao concluir qualquer ticket, feature ou estudo. Alimenta interativamente o log Markdown diário para compor o output do profissional de forma idempotente.
4. **`make lint`**
   - **Comportamento:** Garante a arquitetura limpa e ausência de hardcoded secrets (pre-commit puro). Deve ser invocado instantes antes de empacotar o código.


## 1. Auditoria e Telemetria (Automática)
- [ ] Abrir o terminal de controle no diretório do clone do workspace (ex: `cd ~/labs/dev-workspace`)
- [ ] Executar a varredura do dia: `make morning`
- [ ] Analisar o output: Existem alertas críticos de segurança? Serviços base offline? Dependências pendentes de atualização não-nativas?

## 2. Alinhamento de Foco e Inteligência Artificial (IA)
- [ ] Revisar tarefas/cards no seu painel ou backlog do dia (Jira, GitHub Issues, etc).
- [ ] Definir a **Única Coisa Importante (The One Thing)**. O que garante o valor do dia?
- [ ] Alinhamento IA: Inicializar sessaão com Copilot/Agente e informar o papel do dia + apontar para governanças se necessário (Ex: *"Copilot, hoje operaremos código de IaC seguindo estritamente as regras de /dev-workspace/AGENTS.md"*).

## 3. Hands-on (Ação e Produção)
- [ ] Mudar para o diretório de trabalho do projeto/cliente (`cd ~/projetos/nome-do-projeto`).
- [ ] Executar validação local de estado *antes* de escrever código usando o `Makefile` do próprio projeto (`git fetch`, `make test` ou `terraform plan`).
- [ ] Executar a tarefa desenhada.
