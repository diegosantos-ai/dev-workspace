# 📐 Arquitetura: Plataforma de Agentes

## Como as partes se organizam e se relacionam?
Atuamos com a premissa de um *Golden Path*, onde a máquina atua restrita aos limites de arquitetura definidos. Separamos responsabilidades em 3 camadas claras:

### 1. Engine de Orquestração (Controle e Workflows)
- Todo o peso cíclico transacional reside no **n8n / Makefile Base**. Em vez de rodarmos múltiplos agentes independentes em loops no ar, nós empacotamos e atrelamos as tarefas principais ao orquestrador visual. Ele possui "Triggers" e "Nodes" validados.

### 2. A Tríade de Agentes (Workers MVP)
- **1. O Orquestrador (Manager):** Interpreta o desejo de software/setup e escolhe quais skills/ferramentas serão usadas. É o único capaz de encadear ferramentas MCP.
- **2. O Executor (Criador):** Gera `Terraform`, lógicas em Python ou provisionamento através dos artefatos da plataforma (`templates/*`).
- **3. O Crítico (Revisor Shift-Left):** Jamais escreve, ele apenas injeta restrições: aplica `tflint`, analisa `gitleaks` e confere se a saída do Criador respeitou a governança do workspace.

### 3. Ecossistema MCP (Memória e Habilidades)
- **Diretório Local:** `dev-workspace/gestao-centralizada-agents/skills-mcp/`
- **Por que MCP?:** Ao invés de um padrão limitante de `.md` consumido exclusivamente via scripts Python, nossas competências (ex: validar qualidade de dados, buscar senhas do dev-workspace e interagir com logs de IaC) se tornarão "Servidores de Ferramentas MCP". Isso significa que elas podem ser consumidas tanto por runtimes CLI na máquina principal quanto pela própria IDE (GitHub Copilot / Cursor).
- **Observabilidade:** Um container dedicado (ex: Langfuse/ChromaDB leves) injetado ao projeto receberá logs sobre: "Quantos tokens foram gastos?" e "Por que o agente tomou essa decisão estrutural?". Esta é a nossa blindagem anti-alucinação persistente.
