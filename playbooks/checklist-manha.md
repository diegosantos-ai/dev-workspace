# 🌅 Checklist da Manhã — Rotina DevOps

> Objetivo: começar o dia com clareza, controle e prioridade definida, aproveitando a automação do nosso Cockpit.

## 1. Auditoria e Telemetria (Automática)
- [ ] Abrir o terminal de controle no diretório onde clonou o workspace (ex: `cd ~/dev-workspace`)
- [ ] Executar a varredura do dia: `make morning`
- [ ] Analisar o output: Existem alertas críticos de segurança? Serviços base offline? Dependências pendentes de atualização não-nativas?

## 2. Alinhamento de Foco e Inteligência Artificial (IA)
- [ ] Revisar tarefas/cards no seu painel ou backlog do dia (Jira, GitHub Issues, etc).
- [ ] Definir a **Única Coisa Importante (The One Thing)**. O que garante o valor do dia?
- [ ] Alinhamento IA: Inicializar sessaão com Copilot/Agente e informar o papel do dia + apontar para governanças se necessário (Ex: *"Copilot, hoje operaremos código de IaC seguindo estritamente as regras de /dev-workspace/AGENTS.md"*).

## 3. Hands-on (Ação e Produção)
- [ ] Mudar para o diretório de trabalho do projeto/cliente (`cd ~/projetos/nome-do-projeto`).
- [ ] Executar validação local de estado *antes* de escrever código (`git fetch`, `make test` ou `terraform plan`).
- [ ] Executar a tarefa desenhada.
