# infra-core

## Propósito

Orquestração unificada dos serviços de infraestrutura central da workstation. Define e opera os containers compartilhados entre todos os projetos do workspace, eliminando conflito de portas e duplicação de banco de dados.

## Quando Usar

- Para inicializar os serviços de banco de dados, cache e observabilidade do workspace.
- Quando um projeto local precisar de Postgres, Redis, ChromaDB ou MLFlow.
- Para verificar ou reinicializar a rede `dev-workspace-net`.

## Serviços Gerenciados

| Container | Imagem | Porta | Função |
|---|---|---|---|
| `core-traefik` | `traefik:v2.10` | 80, 8080 | Gateway de borda e roteamento |
| `core-postgres` | `postgres:15-alpine` | 5432 | Banco relacional multi-tenant |
| `core-redis` | `redis:7-alpine` | 6379 | Cache e coordenação |
| `core-chromadb` | `chromadb/chroma` | 8000 | Vector store para embeddings |
| `core-mlflow` | `ghcr.io/mlflow/mlflow:v2.10.2` | 5000 | Rastreamento de experimentos LLM/ML |

## Dependências

- Docker Desktop instalado e daemon ativo.
- Rede `dev-workspace-net` criada antes de subir os containers.

## Relação com o Core

Módulo de infraestrutura compartilhada. Projetos individuais não devem instanciar bancos próprios com portas mapeadas no host. Em vez disso, devem se conectar ao `infra-core/` declarando a rede externa:

```yaml
networks:
  core-net:
    name: dev-workspace-net
    external: true
```

E acessar os serviços via hostname interno: `postgres`, `redis`, `chromadb`.

## Entrypoint Local

```bash
# A partir da raiz do workspace:
make infra-up      # Cria rede e sobe todos os containers core
make infra-down    # Para os containers (dados preservados em volumes)

# Operação direta (dentro deste diretório):
docker compose up -d
docker compose down
```

Configurações de banco inicial: `config/init-db.sql`.
