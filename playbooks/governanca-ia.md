# Manual de Operação: Governança de Agentes IA

Este documento define as regras arquiteturais, diretrizes de system prompting e boas práticas para operação de grandes modelos de linguagem (LLMs) neste ambiente e em projetos derivados.

## 1. Escopo e Referência Absoluta (Prompt-base)

Agentes autônomos e assistentes de código não devem operar sem carregamento de contexto. A injeção de instruções (`System Prompt`) deve referenciar o repositório central (`dev-workspace`) em vez de manter cópias não atualizadas de diretrizes (`AGENTS.md`) em cada repositório-cliente.

**Prompt Oficial de Inicialização de Sessão:**
> "Atue como Senior Platform Engineer. Antes de sugerir implementações, carregue e submeta-se estritamente às regras documentadas no arquivo global em: `~/docs/dev-workspace/AGENTS.md`."

No Visual Studio Code (Copilot/Cline), esta diretriz é injetada automaticamente via `github.copilot.chat.codeGeneration.instructions` ou `.cursorrules` no nível global de configuração de usuário (`~/.config/Code/User/settings.json`).

## 2. Gestão de Servidores MCP (Model Context Protocol)

O excesso de servidores MCP ativos simultaneamente degrada a precisão do agente e induz alucinação de ferramentas.

**Regras de Operação MCP:**
1. **Princípio de Mínimo Privilégio:** Mantenha ativos no arquivo de configuração do MCP apenas os servidores cruciais para a operação ativa.
2. **Segregação de Especialidade:**
   - **Operações IaC/Backend:** Ative integração de Terminal (Bash), File System e Memória (Qdrant). Desative buscas web ou renderização de browser.
   - **Operações E2E/Frontend:** Ative Playwright/Browser e N8N. Desative acesso de credenciais root CLI.

## 3. Conformidade Orientada por Linting (Shift-Left)

Agentes de IA (Claude, OpenAI, Gemini) possuem vieses formativos variados. A unificação de saída de código deve ser mediada por validação estática de máquina, e não por ajustes de sintaxe em linguagem natural.

**Procedimento Padrão para Resolução de Conflitos LLM:**
1. Solicite a geração do código ao agente.
2. Não realize correções manuais de viés. Acione o framework de validação arquitetural via terminal (`make lint` ou `pre-commit run`).
3. Em caso de falha, repasse as mensagens de standard error (STDERR) literais ao modelo com a instrução:
> "A validação estática local rejeitou a implementação com a saída abaixo. Corrija o código sem usar workarounds ou suprimir regras: [ERRO_LINTER]"

Este método garante que componentes de CI (TFLint, Shellcheck, Gitleaks, Checkov) configurem o comportamento aceitável final da IA.
