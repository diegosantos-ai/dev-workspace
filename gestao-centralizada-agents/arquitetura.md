# 📐 Arquitetura: Plataforma de Agentes

## Topologia do Sistema
Este repositório adota um modelo operacional estrito (Golden Path) para IAs. As responsabilidades são segregadas em três camadas arquiteturais para mitigar execuções destrutivas e alucinações.

### 1. Engine de Orquestração (Workflows)
A gestão de estado e sequenciamento de rotinas não é delegada à inferência do LLM. O orquestrador visual (n8n) e o CLI (Makefile) retêm o controle do ciclo de vida das requisições.

### 2. Personas (Comportamentos Definidos)
O fluxo de trabalho autônomo é balizado por três instâncias de contexto (Personas), cada uma com escopo e limitações bem definidas nas chamadas do servidor MCP:

- **Orquestrador (Orchy):** Atua como roteador de contexto. Interpreta a requisição inicial, mapeia os artefatos locais, consulta os Architecture Decision Records (ADRs) e distribui a carga de execução. É proibido de gerar código final diretamente.
- **Executor (Dev):** Atua na síntese. Gera scripts e módulos Terraform baseando-se estritamente na árvore de `templates/`. Garante a aplicação de idempotência e de separação de ambientes definida pela plataforma.
- **Revisor (Shift-Left):** Atua na auditoria. Valida a configuração por meio de ferramentas estáticas (`make lint`, `tflint`, `shellcheck`, `gitleaks`). Bloqueia qualquer PR ou refatoração que apresente credenciais em plain text ou contornos locais (`ignore_errors`).

### 3. Integração com Servidor MCP (Skills)
- **Caminho Fisico:** `dev-workspace/gestao-centralizada-agents/skills-mcp/`
- **Justificativa Operacional:** O uso do protocolo Model Context Protocol (MCP) padroniza a entrega e a consumição de ferramentas (`skills`) de forma agnóstica às extensões da IDE (Copilot/Cursor) e CLI. As integrações via APIs (GitHub, Gerenciadores de Senha, Terraform Cloud) operam via JSON-RPC restrito.
- **Camada de Memória:** Estruturas relacionais em um vector database (ex: Qdrant) garantem persistência de contexto em sessões distintas, permitindo rastrear o histórico de decisões e custo de inferência (observabilidade LLMOps).
