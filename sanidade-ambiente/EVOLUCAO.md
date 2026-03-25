# Roadmap e Evolução da Sanidade-Ambiente (V2+)

Este documento guarda ideias, propostas de design e resoluções de débitos técnicos para evolução sustentável (Platform Engineering) deste módulo sem causar ruído imediato no escopo da V1.

---

## 🛠️ O que queremos melhorar na pipeline do `env-audit.sh`?

### 1. Descoberta Profunda com Python (Resolução de Paths)
Atualmente o shell script baseia-se apenas no `$PATH` disponível para a janela do terminal exata onde se roda o comando.
**O Problema (Detectado na V1):** O `pre-commit` e o `pipx` frequentemente dão falsos alertas de ausência porque estão instalados não-globalmente localizados em `~/.local/bin/`.
**Solução Futura:** Migrar blocos estritos do bash para delegar chamadas de descoberta via Python nativo do repo (usando o módulo `shutil.which` ou `subprocess`) para buscar hard-paths de instâncias isoladas sem demandar que o usuário injete exports no seu shell do momento (Idempotência).

### 2. Implementação de "Auto-Fix" Modular
Na V1 adotou-se o modelo puro de **Read-Only**.
**Próximo Passo:** Mapear *Targets de Correção Silenciosa*.
Se o auditor avisar sobre ferramentas desatualizadas, o Python deve engatilhar scripts isolados num modo interativo.
- _"O pre-commit falhou ou não existe. Deseja realizar a correção e instalar via requirements agora? [Y/n]"_

### 3. Integrações de Rede e IAM
- **Segurança da Identidade (Drift de Chaves SSH):** Listar quando foi a última vez que as chaves em `~/.ssh/` foram rotacionadas, permissão 400 adequada ou se estão corrompidas.
- **Teste de Carga Credencial:** Ping automático rápido (`ssh -T git@github.com` via background e check se credenciais aws respondem localmente).

---

## 🏗️ O que queremos melhorar na pipeline do `daily-check.sh`?

### 1. Abstração de Dados via YAML/Txt (Declaratividade)
- Remover blocos gigantes de `IF/THEN` hardcoded substituindo por iteração de shell ou list comprehension python sob um arquivo `dependencies.yml`.
- Isso permitirá adicionarmos ferramentas à lista de checagens rapidamente sem adicionar 10 linhas de shell code para cada uma.

### 2. Integração com Webhook ou Status Automático
- Exportar o Output das falhas de saúde estrutural nativamente nos *reports* do agente central (N8N ou LLM), de forma que se tentarmos fazer deploy em um ambiente quebrado, o Orchy (Orquestrador) possa ler o estado da máquina matinal autonomamente baseado num Log JSON (`.reports/status.json`).

---

**Nota Final e Responsabilidade Revisor:** As implementações dessas regras precisam passar limpo e ser executáveis sob `set -euo pipefail`. Nunca migrar tudo para Python numa tacada só sem garantir que o interpretador primário continue sobrevivendo isolado.
