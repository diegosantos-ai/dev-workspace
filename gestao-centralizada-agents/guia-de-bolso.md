# 📘 Guia de Bolso: Operando a Plataforma de Agentes

Este guia serve como a referência primária (Cheat Sheet) de uso no dia a dia para a **Gestão Centralizada de Agentes**.

## 1. O que é essa Feature?
Chega de *prompts* genéricos. Essa feature transforma a IA do seu editor (Ex: GitHub Copilot) em um funcionário de plataforma disciplinado. Ela entrega:
- **Regras Imutáveis:** A IA assume "Personas" que a obrigam a seguir os padrões de arquitetura (Zero hardcode de secrets, uso de templates, idempotência).
- **Memória Cativa (Qdrant):** O contexto do repositório é armazenado. A IA não pede que você explique o projeto do zero toda vez.
- **Braços Operacionais (MCP + n8n):** A IA ganha a habilidade de "clicar" em ferramentas virtuais (`Skills`) para disparar automações de CI/CD, aprovação de tickets, ou envio de mensagens via webhooks no n8n.

## 2. Quando usar?
- **Planejamento:** Para extrair diagramas, desenhar ADRs (Decisões de Arquitetura) baseado no histórico.
- **Desenvolvimento:** Para provisionar instâncias no Terraform baseadas estritamente nos `templates/` locais.
- **Revisão e CI/CD:** Antes de comitar código, para caçar vazamentos pontuais de chaves de API e quebras de padrão.
- **Operação Nuvem:** Para mandar um comando direto pelo chat: *"Rodar pipeline X no n8n"*.

---

## 3. Como usar na Prática (O Fluxo Diário)

Ao abrir o chat da IA, em vez de pedir algo livre, você **anexa a Mente (Persona)** usando o comando `#file` e cita a regra do jogo:

*   **Para Arquitetura & Planejamento:**
    *   *Prompt:* "Atue como o `#01-orquestrador.md`. Analise a pasta `docs-referencia` e me dê um ADR sobre adicionar um Redis à infra."
*   **Para Código Infra/App:**
    *   *Prompt:* "Atue como `#02-executor.md`. Gere o diretório `infra/redis` usando a base do nosso `#templates`. Não declare variáveis sem usar arquivos `.tfvars` isolados."
*   **Para Revisão:**
    *   *Prompt:* "Atue como `#03-revisor.md`. Olhe a aba de Source Control, veja se as minhas edições YAML passariam no `make lint`."
*   **Para Acionar Automações Reais:**
    *   *Prompt:* "Acesse a tool do MCP `trigger_n8n_workflow`, envie para webhook `deploy-prod` com payload `{'env': 'producao'}`."

---

## 4. Como Adotar em NOVOS PROJETOS
Sua infra de motores (Servidor MCP, n8n, Qdrant) roda no background da sua máquina. Para inicializar a inteligência em um repositório vazio, você só injeta a governança:

1. Vá para o repo novo:
   `cd /caminho/do/projeto-novo`
2. Puxe a esteira de Git Hooks e Makefile:
   `bash /home/diego/dev-workspace/scripts/adopt_governance.sh`
3. Copie as rédeas da IA (Os Manifestos):
   `cp /home/diego/dev-workspace/AGENTS.md ./`
   `cp -r /home/diego/dev-workspace/agents-personas ./`

Pronto. O Copilot agora obedece esse sistema lá dentro.

---

## 5. Como Adotar em PROJETOS EM ANDAMENTO (Legados)
O fluxo é o mesmo dos novos, **com um bônus de adequação**. Se você injetar a governança em um código velho, o `pre-commit` vai estourar bloqueando possíveis commits ruins herdados.

1. Vá para o repo legado:
   `cd /caminho/do/projeto-antigo`
2. Injete a Governança e copie os manifestos (mesmos passos da Seção 4).
3. **Auditoria Progressiva:**
   Utilize o Agente Revisor no VSCode para consertar aos poucos:
   *Prompt:* "Use o `#03-revisor.md`. Rode o comando `make lint` via terminal, veja tudo que quebrou neste código antigo e me sugira pequenas refatorações pontuais focadas em remover hardcode secrets e arrumar os lintings do shell/aws."
