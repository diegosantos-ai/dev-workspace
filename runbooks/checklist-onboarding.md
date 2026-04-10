# Checklist de Validação — Teste Final (Notebook Limpo)

Este documento define o roteiro de execução e os critérios de aceite para a Baseline de Março/2026 do `dev-workspace`.

## 1. Pré-requisitos (Antes do Clone)

- [ ] SO: Ubuntu 22.04+ ou Debian 12.
- [ ] SSH: Chave `~/.ssh/id_ed25519` criada e vinculada ao GitHub.
- [ ] Acesso: Usuário tem permissão de `sudo`.
- [ ] Git: `git` instalado nativamente no sistema (`sudo apt install git`).

## 2. Roteiro de Execução (Fluxo de 10 Passos)

| Passo | Comando | Suporte Esperado |
|---|---|---|
| **01** | `git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace` | Clone via SSH sem erro de autenticação. |
| **02** | `cd ~/labs/dev-workspace` | Entrada no diretório sem problemas. |
| **03** | `make help` | Lista de 18+ targets formatada e legível. |
| **04** | `make bootstrap` | Executa setup da workstation, runtimes, CLIs de agentes, hooks e motor de agentes sem depender do CWD atual. |
| **05** | `make doctor` | Todos os itens "Essenciais" em `[OK]`. Opcionais podem estar `[WARN]`. |
| **06** | `make lint` | Executa `pre-commit` a partir da raiz real do clone. Fora de contexto Git, falha com mensagem explícita. |
| **07** | `make morning` | Carrega o check de sanidade e dispara o `day-start`. |
| **08** | `make day-start` | Cria `rotina-devops/worklog/daily/<HOJE>.md` com base no template. |
| **09** | `make log ARGS="teste real"` | Inserção da entrada no arquivo MD sem quebra de formatação. |
| **10** | `make day-close` | Preenchimento interativo, consolidação e push para o git. |

## 3. O que Observar Durante o Onboarding (Telemetry Manual)

- **Tempo de setup:** O Ansible demora mais de 10min em algum ponto? (Geralmente Docker Desktop).
- **Prompt interativo:** Algum comando pediu senha inesperada fora do início do `sudo`?
- **Contexto de execução:** O fluxo continua íntegro mesmo que o terminal tenha sido aberto fora do clone e o operador entre manualmente em `~/labs/dev-workspace` antes do `make`?
- **Paths:** Algum script reclamou de arquivo não encontrado em `~/.cache/devops-reports/`?

## 4. Matriz de Aceite (Sucesso vs Falha)

### 🔴 Bloqueadores Reais (Falha Crítica)
- Ansible morre antes de instalar `uv`, `asdf` ou `docker`.
- `make doctor` reporta `[FAIL]` em ferramentas do bloco **Essenciais**.
- `make morning` falha por arquivo de script inexistente, root incorreta ou erro de permissão em `~/.cache`.
- `git push` falha por erro de configuração de credencial (`.gitconfig` quebrado).

### 🟡 Imperfeições Aceitáveis (Dívida Técnica)
- `make doctor` reporta `[WARN]` em `uv`, `ollama` ou `asdf` (se houver fallback funcional).
- `make lint` reporta falha de `shellcheck` em scripts externos de terceiros.
- Lentidão no download de pacotes via `apt` ou `get_url`.
- SSH check do `doctor` em `[WARN]` (se o usuário optar por não configurar chave no momento).

## 5. Estado Alvo (Pós-Teste)
A máquina é considerada **Pronta para Operação** se os passos 01 a 10 forem concluídos e o worklog do dia estiver versionado no repositório remoto.
