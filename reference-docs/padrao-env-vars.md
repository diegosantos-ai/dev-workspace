# Padrão de Variáveis de Ambiente e `.env` (Ticket 2.4)

Pela premissa do workspace, o ambiente baseia-se na injeção de parâmetros modulares a partir da máquina, isolando o cofre e configurações dinâmicas dos repositórios injetados no controle de versão.

## 1. Topologia de Arquivos .ENV
Não existirá "vários `.env` isolados" bagunçando o repositório nos módulos raiz que operam agentes generalistas.

Implementaremos o modelo *Single Source Of Truth* no diretório de raiz `gestao-centralizada-agents/` onde o projeto buscará ou exportará suas chaves para injetar dependências nas rotinas que precisarem (ex: N8N, Vetores, LLM Keys).

* O arquivo base é e será **único**: `gestao-centralizada-agents/.env`
* Ele será **estritamente excluído do controle de versão** usando um `.gitignore` nativo desta subpasta e coberto pelo Gitleaks.

## 2. Padrões de Declaração de Variáveis
Ao criar variáveis, os seguintes padrões de notação (naming convention) deverão ser observados sem improvisos:

* **Cloud Providers:** Prefixadas sempre com seu provedor: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION_DEFAULT`.
* **Terraform Externo:** Módulos sensíveis consumidos via pipeline remota devem respeitar o prefixo obrigatório exigido, como `TF_VAR_db_password`.
* **Ferramentas e Auth de I.A:** Serviços atrelados a credenciais via API exigem escopo: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `N8N_ENCRYPTION_KEY`.

## 3. O `.env.example` Oficial
A raiz gerencial contará sempre de maneira explícita, auditável e mantida, o arquivo modelo sob a base `gestao-centralizada-agents/.env.example`.

Ele contemplará este esqueleto canônico:

```env
# ==========================================
# ENV TEMPLATE — Workspace DevOps Central
# ==========================================
# Não adicione nenhum valor real neste arquivo.
# Clone ou copie este modelo como `.env` e aplique localmente.

# ---- INFRA PROVIDERS ----
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1

# ---- TERRAFORM STATE / TOKENS ----
TF_VAR_owner_label=
TF_TOKEN_app_terraform_io=

# ---- GESTÃO DE AGENTES / N8N ----
N8N_ENCRYPTION_KEY=
N8N_USER_MANAGEMENT_JWT_SECRET=
OPENAI_API_KEY=
QDRANT_API_KEY=
```

## 4. Ordem de Precedência (Como as vars são lidas e carregadas)
1. Perfil de usuário nativo de terminal (`~/.zshrc` ou export global).
2. Arquivos exportados diretamente no processo (submódulos bash `export $(cat .env | xargs)`).
3. Configurações remotas baseadas do CI (Via `GitHub Secrets`).

Qualquer improvisação ou injeção em linhas de shell script fora desse padrão violará o contrato de reprodutibilidade deste repositório e ativará impedimentos de Linting ativo.
