# 🎯 Contexto: Gestão Centralizada de Agentes

## Por que isso existe?
Com a rápida evolução das IAs generativas e fluxos de codificação, o workspace estava caminhando para o que a indústria chama de "AI Agent Sprawl" (descontrole e pulverização de agentes). Scripts soltos, múltiplas dependências globais instaladas sem padrão e prompts duplicados em cada repositório aumentavam a complexidade de manutenção e geravam falta de previsibilidade nos resultados.

## Qual problema resolve?
A proposta anterior exigia que instalássemos manualmente *Langgraph, CrewAI, AutoGen e OpenAI SDK* em toda máquina, além de forçar a criação de um "gerenciador de pacotes" proprietário de *Skills* (`npx skills add`). Isso geraria alto atrito e uma barreira enorme de manutenção.
Este novo arranjo Resolve:
- **Lock-in de Framework:** Adotando o padrão Model Context Protocol (MCP), não ficamos presos a uma CLI de agentes específica.
- **Inflação de Conhecimentos:** Permite que todas as IAs consumam a mesma fonte da verdade de forma externalizada e idempotente.
- **Risco de Ações Destrutivas:** Introduz a "Tríade MVP" de agentes (Orquestrador, Workspace/Criador, Avaliador/Crítico), evitando que uma geração errada execute comandos terminais irreversíveis.

## Qual é o objetivo agora?
Estabelecer um plano de fundação ("Cockpit de IA") baseado nos pilares de *Platform Engineering* já documentados no nosso arquivo `AGENTS.md`.
O escopo agora mira em:
1. Migrar a ideia de "Skills Customizadas" para **Servidores MCP padronizados** (`/skills-mcp/`).
2. Empacotar localmente ferramentas de Observabilidade (LLM tracing) e Memória (Vector DB) usando orquestração já existente (Docker/n8n) para que as decisões dos agentes sejam analisadas e não esquecidas.
