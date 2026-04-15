# Módulo: Scripts (Utilitários Gerais)

Este diretório contém scripts auxiliares que não pertencem exclusivamente a uma "feature" (como rotina ou agents), mas servem como ferramentas de apoio operacional para o workspace.

## 📂 Scripts Disponíveis

- `new-project.sh`: Automação para alocar portas e estrutura base para novos labs.
- `update-tools.sh`: Atualizacao controlada de ferramentas gerenciadas pelo workspace com relatorio em `sanidade-ambiente/reports/`.

## 🛠️ Filosofia de Desenvolvimento

1. **Portable:** Sem caminhos absolutos hardcoded (use `REPO_ROOT`).
2. **Bash 4+:** Compatível com ambientes modernos Linux.
3. **Shellchecked:** Todo script deve passar no `make lint` sem erros de sintaxe ou segurança.
