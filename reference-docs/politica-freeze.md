# Política de Congelamento de Baseline (Freeze Policy)

Este documento define as regras de estabilidade e o rito de transição para o uso prático do `dev-workspace`.

## 1. Filosofia: "Funcional sobre Perfeito"
A partir da versão **v1.2**, o repositório entra em estado de **Congelamento Operacional**.
- O foco é cessar refatorações estruturais ou cosméticas.
- A maturidade do projeto agora virá do uso diário, histórico de logs e detecção de falhas reais.

## 2. Critérios de Aceite para "Pronto para Uso"
Um release de baseline é considerado estável se, e somente se:
1. **Onboarding (10 Passos):** Executado com sucesso em máquina limpa (via checklist no `playbooks/`).
2. **Doctor Check:** Bloqueio 100% verde para itens **Essenciais**.
3. **Lint Check:** 100% verde (Shellcheck, Gitleaks, Yamllint).
4. **Idempotência:** O comando `make setup-workstation` pode ser rodado N vezes sem corromper o estado ou duplicar entradas em arquivos de config (`.zshrc`, `.env`).

## 3. Matriz de Decisão: Corrigir vs Adiar (Issue)

| Cenário | Ação Imediata | Ação Posterior (Issue) |
|---|---|---|
| Falha no setup de binário essencial | Sim (Bloqueador) | - |
| Erro de path em script de rotina | Sim (Bloqueador) | - |
| Sugestão de nova feature de automação | Não | Criar Issue / Backlog |
| Melhoria visual em logs ou relatórios | Não | Criar Issue / Backlog |
| Documentação ambígua ou duplicada | Sim (Bloqueador) | - |

## 4. Regras Pós-Onboarding
Após a entrada em operação real no notebook novo:
- **Zero Bypass:** Nenhuma alteração entra na `main` sem passar pelo `make lint` local.
- **Idempotência Obrigatória:** Qualquer novo script ou tarefa Ansible deve prever reexecução segura.
- **Documentação Localizada:** Playbooks em `playbooks/`, Referências em `docs-referencia/`.

---
**Baseline Atual:** `v1.2` (Março/2026)
**Manutenção:** Somente correções críticas de segurança ou funcionalidade de setup.
