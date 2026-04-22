# ADR 0006: Integração MCP para Agentes de IA Locais

## Status
Aceito

## Contexto
O workspace foi projetado para atuar como uma Plataforma de Engenharia que suporta automação severa. Com a ascensão de assistentes de IA (como GitHub Copilot, Gemini CLI, Claude Code e agentes locais baseados no Model Context Protocol - MCP), tornou-se necessário padronizar a forma como esses agentes interagem com a infraestrutura local (ex: banco vetorial Qdrant, orquestradores como n8n, e automações bash).
A integração direta de scripts ad-hoc para cada agente geraria acoplamento forte e fragmentação das ferramentas operacionais.

## Decisão
Adotamos o **Model Context Protocol (MCP)** como a interface universal de comunicação entre agentes de IA e a infraestrutura do laboratório.
- Um servidor MCP (escrito em TypeScript para forte tipagem e compatibilidade padrão) será mantido em `gestao-centralizada-agents/skills-mcp`.
- O servidor rodará via STDIO, fornecendo "Skills" (tools) que qualquer cliente MCP (IDE ou CLI) possa invocar.
- Nenhuma credencial será injetada no código do servidor MCP; ele consumirá o arquivo de estado `.env` padronizado na gestão centralizada.

## Consequências
- **Positivas:** Agentes agnósticos. Podemos trocar a interface do usuário (ex: de um CLI para uma extensão de IDE) sem reescrever as automações subjacentes. A segurança é mantida via Shift-Left.
- **Negativas:** Adiciona uma camada de complexidade e dependência do runtime do Node.js (`asdf` será estritamente necessário para garantir a versão do Node).
