Esses passos garantem que sua estação esteja no estado padronizado pela plataforma.
# Personal Dev Workspace — Platform Engineering (Cloud & MLOps)

Bem-vindo ao repositório central de automação e plataforma. Este projeto define e aplica as políticas, ferramentas e padrões que mantenho como base para todas as minhas estações de trabalho e repositórios de infraestrutura.

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Pre-commit](https://img.shields.io/badge/Pre--commit-Quality-2F363D?style=for-the-badge)

---

## ![ARQUITETURA](https://img.shields.io/badge/-ARQUITETURA-2F363D?style=for-the-badge) Visão geral

Este repositório agrupa:

- Automação de estação (Ansible / scripts)
- Dotfiles e symlinks (GNU Stow)
- Modelos e módulos de infraestrutura (Terraform)
- Regras de governança e agentes (AGENTS.md, ADRs)

Mantemos a **Segurança Shift-Left** com `pre-commit` e detecção local de segredos para evitar vazamento antes do push.

---

## ![ENTRYPOINT](https://img.shields.io/badge/-ENTRYPOINT-2F363D?style=for-the-badge) Primeiros passos

1. Bootstrap (máquina nova):

```bash
./scripts/setup-machine.sh
```

2. Aplicar playbook principal (instala Ansible se necessário):

```bash
make setup-workstation
```

3. Ativar dotfiles (stow):

```bash
cd dotfiles
stow zsh
stow git
stow vscode
```

---

## ![DEV_&_CLOUD](https://img.shields.io/badge/-DEV_&_CLOUD-2F363D?style=for-the-badge) Rotinas principais

Use o `Makefile` como ponto de entrada para tarefas comuns:

```bash
make format      # formata código / terraform
make lint        # roda linters locais e pre-commit
make test        # executa testes unitários
```

Para infra (ex.: `templates/terraform-aws-base/envs/dev`):

```bash
cd infra/<stack>/envs/dev
make plan
make apply
```

---

## ![CHECKLISTS](https://img.shields.io/badge/-CHECKLISTS-2F363D?style=for-the-badge) Operações diárias

Consulte `playbooks/` para runbooks, checklist de início de dia e procedimentos de validação.

---

## Governança e Agentes

Leia `AGENTS.md` e os ADRs em `docs-referencia/adr/` antes de submeter alterações significativas. As regras definem padrões de idempotência, segurança e separação de responsabilidades entre módulos e ambientes.

---

## ![IA_AGENTS](https://img.shields.io/badge/-IA_&_AGENTES-8A2BE2?style=for-the-badge) Gestão Centralizada de Agentes (AI Cockpit)

Para manter a governança arquitetural com uso de IA (ex: GitHub Copilot), foi desenvolvida uma **Plataforma de Agentes em Tríade** conectada a um Servidor MCP, garantindo que IAs codifiquem seguindo nossos templates, possuam memória do projeto e executem webhooks em nuvem.

```mermaid
graph TD
    %% Entidades Principais
    User[👨‍💻 Engenheiro de Software] -->|Contexto via Chat e Prompts| AI{🤖 Agente de IA / Copilot}

    %% Matriz de Personas (Regras)
    subgraph Governança Restrita
        P1(📐 1. Agente Orquestrador)
        P2(🏗️ 2. Agente Executor)
        P3(🛡️ 3. Agente Revisor)
    end

    %% Cargas Cognitivas
    AI -.->|Planeja e delega| P1
    AI -.->|Usa Templates Locais| P2
    AI -.->|Roda Lint / Pre-Commit| P3

    %% Servidor e Comunicação
    AI -->|JSON-RPC via stdio| MCP[⚙️ Servidor MCP \n/skills-mcp]

    %% Cockpit Local e Nuvem
    subgraph Cockpit Operacional
        MCP -->|Tool: check_qdrant_status| Q[(🧠 Memória Vetorial \nQdrant Local)]
        MCP -->|Tool: trigger_n8n_workflow| N8N[⚡ Orquestrador Cloud \nn8n Webhooks]
        N8N -.->|"Telemetria LLM"| LF[📊 Langfuse \nObservabilidade]
    end

    %% Output
    Q -.->|Carrega Histórico de ADRs| AI
    N8N -->|Executa Deploys via Pipeline| Infra[☁️ Infraestrutura / Cloud]

    %% Estilos
    classDef ai fill:#623CE4,stroke:#fff,stroke-width:2px,color:#fff;
    classDef mcp fill:#2496ED,stroke:#fff,stroke-width:2px,color:#fff;
    classDef governanca fill:#2F363D,stroke:#fff,color:#fff;

    class AI ai;
    class MCP,Q,N8N,LF mcp;
    class P1,P2,P3 governanca;
```

### 🧩 Entendendo o Fluxo (Legenda):
- **O Cérebro Limitado (Personas)**: A inteligência artificial neste repositório não tem permissão para escrever código "free-style". Ela é forçada a assumir o papel restrito de arquitetura, execução (copiando templates) ou de auditor severo (Shift-Left).
- **O Tradutor (Servidor MCP)**: É um motor TypeScript local que ensina para as IAs como interagir com as ferramentas da nossa plataforma.
- **A Memória (Qdrant Vector DB)**: Roda embarcado localmente. Permite à IA resgatar "experiências passadas" e diretrizes para ter contexto _antes_ de conversar com o usuário.
- **Os Braços Mecânicos (n8n + Langfuse)**: Em vez do Agente cuspir scripts Python inseguros, ele aperta "botões" no n8n na nuvem, que por sua vez cuida da orquestração real sem expor nossa máquina. O Langfuse rastreia todo custo, tokens e falhas desse fluxo em uma dashboard.

> 💡 **Para operar a IA no dia a dia**, leia o **[Guia de Bolso Oficial](gestao-centralizada-agents/guia-de-bolso.md)** contendo os atalhos e promptings reais.
