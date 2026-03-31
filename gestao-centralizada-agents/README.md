# gestao-centralizada-agents

## Propósito

Módulo de infraestrutura e governança para agentes de IA operando no workspace. Centraliza as Personas (comportamentos definidos), o servidor de ferramentas via MCP (Model Context Protocol) e a infraestrutura gerada por agentes.

## Quando Usar

- Para configurar, estender ou testar o servidor MCP de Skills.
- Para consultar ou atualizar as Personas dos agentes (`agents-personas/`).
- Para provisionar infraestrutura gerada por agentes (`infra/`).
- Para depurar o comportamento de um agente ou verificar ferramentas disponíveis.

## Dependências

- `infra-core/` deve estar ativo (`make infra-up`) — os agentes dependem de Postgres e ChromaDB.
- Python com `pipx` instalado (provisionado via `make bootstrap`).
- Rede `dev-workspace-net` criada.

## Relação com o Core

Módulo especializado. Não interfere no bootstrap da workstation. Consome serviços do `infra-core/` via rede interna Docker. O `Makefile` raiz expõe targets de entrada: `make setup-agents`, `make test-skills`, `make start-orquestrador`.

## Entrypoint Local

```bash
# A partir da raiz do workspace:
make setup-agents       # Instala dependências do servidor MCP
make test-skills        # Valida se as Skills estão operacionais
make start-orquestrador # Sobe observabilidade e motor de agentes
```

Para desenvolvimento interno ao módulo, consultar `arquitetura.md` e `planejamento-gestao.md`.
