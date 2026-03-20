# Contribuição: Platform Engineering Workspace

Este guia define as regras rígidas para integração de código ou refatoração estrutural neste repositório. Toda submissão deve respeitar o princípio de Idempotência e Shift-Left Security.

## 1. Regras de Ouro
1. **Nenhuma chave hardcoded:** É expressamente proibido versionar credenciais. A detecção prévia via gitleaks deve passar de forma limpa.
2. **Modularidade Fixa:** Toda infraestrutura como código (Terraform) deve manter a separação estrita entre `modules/` (lógica agnóstica) e `envs/` (estado do ambiente).
3. **Padrão de Automação:** Modificações envolvendo a máquina local (`Ansible`/`Stow`) devem prever proteção contra falhas para sistemas secundários (ex: flags WSL) sem engolir erros vitais (`ignore_errors: true` em comandos cruciais).

## 2. Fluxo de Desenvolvimento
1. Crie uma branch com os prefixos semânticos: `feat/`, `fix/`, `chore/` ou `docs/`.
2. Garanta que a sua máquina roda o ambiente primário validado (`make test-sanity`).
3. Modifique os arquivos e ative internamente a cadeia de linters executando:
   ```bash
   make lint
   ```
4. Todo script gerado em shell deve passar sem avisos do `shellcheck`.

## 3. Diretriz para Uso de IA (Copilot, Claude, Cursor)
Caso injete componentes via Large Language Models (LLMs):
- O agente externo **DEVE** estar sob contexto do arquivo `AGENTS.md`.
- Componentes recém-criados devem ser submetidos à revisão estática e não apenas à checagem visual.
- A comunicação técnica em ADRs e READMEs associados não deve conter jargões de produto, emoções em texto, ou uso de emojis, baseando-se estritamente na descrição objetiva dos limites da arquitetura.

## 4. Submissão
1. Valide a conformidade local dos hooks `.pre-commit`.
2. Encaminhe o Pull Request detalhando qual o problema original, as modificações de estrutura e o resultado esperado da checagem idempotente.
