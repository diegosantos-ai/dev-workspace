# Módulo: Infra-Core (Serviços Compartilhados)

Centralização de serviços de infraestrutura local executados via Docker. Estes serviços são compartilhados entre diferentes projetos do workspace para evitar colisão de portas e desperdício de recursos.

## 📂 Serviços Inclusos

- **Banco de Dados:** Postgres (Porta 5432 interna)
- **Cache/Mensageria:** Redis (Porta 6379 interna)
- **Vetores (IA):** ChromaDB / Qdrant
- **Observabilidade:** MLFlow / Langfuse
- **Proxy/Ingress:** Traefik (Opcional)

## 🌐 Rede Unificada

Todos os containers deste módulo e de projetos externos devem se conectar à rede externa:
**`dev-workspace-net`**

## 🚀 Como Operar

Acionado via root `Makefile`:
```bash
make infra-up    # Sobe todos os serviços core em background
make infra-down  # Encerra e remove containers core
```

## ⚠️ Atenção
- **Não exponha portas** de banco diretamente para o host se estiver em projetos individuais; use o hostname interno (ex: `POSTGRES_HOST=postgres`).
- Verifique o `.env.example` na raiz para as credenciais padrão.
