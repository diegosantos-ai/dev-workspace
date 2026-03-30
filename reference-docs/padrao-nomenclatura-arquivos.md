# Padrão de Nomenclatura de Arquivos (Naming Convention)

Este documento define regras obrigatórias de governança para qualquer humano ou agente de Inteligência Artificial que gerar arquivos dentro deste Workspace.

## 1. Padrão Universal (Kebab-Case)
- O padrão obrigatório e _default_ da plataforma é o **kebab-case** em minúsculas.
- **Não** use espaços, `_` (underscores), acentos ou sufixos incrementais (`-v2`, `-novo`, `temp_`).
- **Exemplos Corretos:** `onboarding-projetos.md`, `setup-env.sh`, `config-infra.yaml`.
- **Exemplos Proibidos:** `ONBOARDING_PROJETOS.md`, `SetupAmbiente.sh`, `script_old.sh`.

## 2. Exceções e Casos Específicos
| Categoria | Formato Requerido | Exemplo de Aplicação |
|---|---|---|
| Documentos Markdown, Scripts, YAML | **kebab-case** | `playbooks/manutencao-mensal.md` |
| Códigos / Módulos Python | **snake_case** | `src/api_client.py` |
| Componentes TS / React (Front) | **PascalCase** | `components/ButtonPrimary.tsx` |

## 3. Preservações Core (Master Files)
Arquivos canônicos impostos por arquitetura de ferramentas globais são imunes à regra do _kebab-case_ e devem ser mantidos como o mercado dita.
- **Exemplos preservados intactos:** `README.md`, `CONTRIBUTING.md`, `Makefile`, `Dockerfile`, `.gitignore`, `AGENTS.md`, `GEMINI.md`.

*(Qualquer script Git hook / Lint deve rejeitar tentativas quebra de commit violando estas premissas para evitar corrupção de Paths de OS).*
