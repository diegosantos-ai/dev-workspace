# Servidor de Skills MCP (DevOps Base)

Este diretório contém o nosso Servidor MCP (Model Context Protocol). Ele atua como uma interface padronizada entre a IA (GitHub Copilot / Agentes Locais) e nossas automações externas (n8n, bash scripts, Qdrant).

## Por que MCP?
Em vez de depender de scripts Python soltos e acoplados a uma IA específica, desenvolvemos um protocolo universal. Isso significa que **qualquer front-end de IA compatível** pode consumir essas funções (Skills) através de um contrato TypeScript rígido, usando STDIO.

## Ferramentas Disponíveis
Nesta base, registramos tools como:
- `trigger_n8n_workflow`: Aciona automações de CI/CD, Infra e chamados direto no servidor n8n remoto.
- `check_qdrant_status`: Validador de integridade do nosso banco vetorial local (memória de longo prazo).

## Execução
Para buildar e testar rodando localmente (stdIO):
\`\`\`bash
npm install
npm run build
npm start
\`\`\`

## Operação no Workspace

No `dev-workspace`, o entrypoint operacional do servidor local é:

\`\`\`bash
make start-skills-mcp
\`\`\`

Esse fluxo usa `gestao-centralizada-agents/scripts/start-skills-mcp.sh` para:
- carregar `~/.agents-env` quando existir;
- garantir `node` e `npm` do ambiente ASDF;
- compilar `build/index.js` se estiver ausente ou desatualizado;
- iniciar o servidor MCP por `stdio`.
