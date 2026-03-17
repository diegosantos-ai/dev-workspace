# 🤖 Manifesto & Governança para Agentes de IA (`AGENTS.md`)

Este documento serve como a **Referência Arquitetural Oficial e Conjunto de Regras (System Prompting)** para toda IA (Copilot, Claude, GPT, etc) que operar dentro deste Workspace (`dev-workspace`).

**ATENÇÃO AGENTE:** Antes de planejar, sugerir comandos de terminal ou alterar arquivos, **você DEVE ler e submeter-se às regras abaixo**. Falhar em seguir estas diretrizes resultará em quebra da esteira de CI/CD (Shift-Left Security) e corrupção da arquitetura Premium estabelecida.

---

## 🏛️ 1. O Padrão Premium (Platform Engineering)
Este repositório deixou de ser um conjunto de scripts soltos para se tornar um Produto de Plataforma. Absolutamente TUDO deve ser:
1. **Idempotente:** Se rodar 1 vez ou 1000 vezes, o resultado é seguro e o mesmo.
2. **Modular:** Separação entre lógica (modules) e estado (envs).
3. **Seguro (Shift-Left):** Zero credenciais hardcoded. Linting local rígido.

---

## 🛠️ 2. Regras de Ouro por Domínio

### 🅰️ Automação de Máquina (OS Setup & Dotfiles)
- **NÃO** adicione comandos imperativos complexos em `scripts/setup-machine.sh`. Este arquivo serve exclusivamentente como bootstrap para instalar o Ansible.
- **USE** o Ansible (`ansible/local-setup.yml`) para qualquer nova instalação de software, gerenciamento de serviços ou permissões.
- **USE** GNU Stow para dotfiles. Se precisar adicionar uma nova configuração de terminal (ex: `nvim`), os arquivos devem ir para `/dotfiles/nvim/` respeitando a árvore de espelhamento do OS, para que o Stow crie os symlinks corretamente.

### ☁️ Infraestrutura as Code (Terraform)
- **NÃO** crie arquivos soltos (`.tf`) na raiz de `templates/` ou `ovh-terraform/`.
- **Módulos Virtuais (`modules/`):** Recursos (`compute`, `network`, etc) DEVEM estar destituídos de ambiente. NUNCA coloque backend variables, instâncias de `provider` diretas ou valores hardcoded aqui.
- **Ambientes (`envs/<env>/`):** É aqui que as variáveis são passadas (`terraform.tfvars`) e onde o state reside. Sempre aponte os módulos usando path relativo (`../../modules/<nome>`).

### 🛡️ Segurança e Linting (CI/CD)
- O projeto usa `pre-commit` com `gitleaks`, `tflint`, `tfsec` e `shellcheck`.
- **NÃO** insira chaves, tokens, senhas ou secrets em nenhum script ou TF. Use passagem de variáveis de ambiente do sistema (`TF_VAR_`, Github Secrets) ou injeção via gerenciador de senhas.
- Garanta que qualquer script shell que você escrever passe limpo sob as regras do `shellcheck`.

### 📚 Operações e Ponto de Entrada (Entrypoint)
- **NÃO Mande o usuário digitar comandos verbosos no terminal.** Todo fluxo operacional de alto nível deve ter um atalho no `Makefile`.
- Se você criar um novo processo recorrente de setup, teste ou deploy, encapsule-o num novo target no arquivo `Makefile`.

---

## 🧠 3. Fluxo de Trabalho Esperado do Agente

Quando o usuário Diego demandar a você a implementação de uma nova ferramenta (feature) sob este diretório, proceda da seguinte forma:

1. **Contexto Contínuo:** Verifique os `docs-referencia/adr/` (Architecture Decision Records) se estiver em dúvida do arranjo atual.
2. **Proposta Arquitetural (ADR):** Caso traga uma refatoração massiva, gere primeiro um ADR em `docs-referencia/adr/` e valide com o usuário.
3. **Separação de Preocupações:** Identifique se a mudança é IaC (Terraform), Automação Local (Ansible) ou CI/CD e aplique direto no diretório final isolado.
4. **Resumo Efetivo:** Ao terminar cada sub-task, traga um resumo de _Estado Arquitetural Anteriror vs Estado Alvo_, lista de _Arquivos Modificados_ e o _Status/Validação_.

**_Agente, se você entendeu esse arquivo, a partir deste momento execute todas as tarefas priorizando este contrato de integridade._**
