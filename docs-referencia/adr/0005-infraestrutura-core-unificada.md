# ADR 0005: Padronização de Infraestrutura Base (Core Services) em Docker

## Status
Aceito

## Contexto
Durante o desenvolvimento local e a troca de contexto entre diferentes projetos clonados, constatamos frequentes conflitos de uso de portas no host da máquina (exemplo: múltiplos `docker-compose.yml` tentando anexar a porta `5432` da máquina para instanciar sub-bancos de dados PostgreSQL).
A replicação de ambientes como Banco de Dados, Cache de Memória, Gateway e Servidores de Embeddings por projeto consome processamento e gera quebras recorrentes do ecossistema de desenvolvimento, violando o princípio de isolamento e robustez da Plataforma.

## Decisão
A partir deste momento, todos os projetos sob governança desta máquina obedecerão ao modelo de **Rede Unificada e Single Core Infra**:

1. Múltiplos serviços base foram consolidados sob o diretório `dev-workspace/infra-core/docker-compose.yml`.
2. Os serviços centrais subirão escutando a portas fixas locais para facilitar uso de IDEs e comporão a rede externa denominada `dev-workspace-net`.
3. É **expressamente proibido** que os arquivos `docker-compose.yml` dos projetos finais utilizem a diretiva nativa `ports:` apontando para 5432 (PG), 6379 (Redis) ou 8000 (Chroma).
4. Todo projeto que necessite consumir um banco de dados relacional (por exemplo) deve declarar conexão à rede `dev-workspace-net` e apontar o `DATABASE_URL` diretamente para o hostname do serviço central (ex: `postgres:5432/nome_do_projeto`), criando um contêiner virtual apartado via init ou migração.

## Ferramentas Disponíveis na Rede (Sempre Ligados):
* `traefik:80` e `:8080`
* `postgres:5432`
* `redis:6379`
* `chromadb:8000`
* `mlflow:5000`

## Consequências
- Fim definitivo de erros de porta ocupada (Address already in use).
- Economia de recursos da máquina de desenvolvimento.
- Projetos novos precisam explicitar o bloco de `networks` externas nos seus YAMLs e não podem ter a infra "bancada" neles mesmos.
- Obrigatoriedade de criação isolada de esquemas (`logical databases/tenants`) dentro de uma instância de servidor único do PostgreSQL.
