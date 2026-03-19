#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# DESCRIÇÃO: Gera a base para o fechamento da semana para revisão manual.
# ARQUITETURA: Prepara o arquivo semanal mantendo segurança contra sobrescrita e
#              lista os daily logs recentes para facilitar a consulta.
#-------------------------------------------------------------------------------

set -euo pipefail

# Resolução de CWD Agnostic
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
WORKLOG_DIR="$REPO_ROOT/rotina-devops/worklog"

WEEKLY_DIR="${WORKLOG_DIR}/weekly"
DAILY_DIR="${WORKLOG_DIR}/daily"
TEMPLATE_FILE="${WORKLOG_DIR}/templates/weekly-template.md"

WEEK=$(date +"%Y-W%V")
WEEKLY_FILE="${WEEKLY_DIR}/${WEEK}.md"

echo "========================================================="
echo "📆 Preparando Fechamento Semanal: $WEEK"
echo "========================================================="

# 1. Idempotência / Prevenção de perda de dados
if [[ -f "$WEEKLY_FILE" ]]; then
    echo "✅ Aviso: O documento desta semana já existe!"
    echo "📍 Arquivo: $WEEKLY_FILE"
else
    # 2. Criação a partir do template
    cp "$TEMPLATE_FILE" "$WEEKLY_FILE"
    sed -i "s/{{WEEK}}/$WEEK/g" "$WEEKLY_FILE"
    echo "✅ Arquivo de base gerado!"
fi

echo ""
echo "📄 Logs diários recentes (Últimos 7 dias) para sua consulta:"
echo "---------------------------------------------------------"

if ls -1 "$DAILY_DIR"/*.md >/dev/null 2>&1; then
    ls -1 "$DAILY_DIR"/*.md | sort | tail -n 7 | sed 's/^/> /'
else
    echo "  (Nenhum log diário encontrado para referência)"
fi

# 4. Auto-abertura segura
echo "---------------------------------------------------------"
if command -v code >/dev/null 2>&1; then
    echo "⚡ Abrindo resumo no VS Code para edição..."
    code "$WEEKLY_FILE"
else
    echo "💡 Dica: Arquivo pronto em '$WEEKLY_FILE'"
fi
