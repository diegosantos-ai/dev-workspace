#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# DESCRIÇÃO: Script para iniciar o rastreamento do dia.
# ARQUITETURA: Executável de qualquer path (descobre repo root via script path).
#-------------------------------------------------------------------------------

set -euo pipefail

# Resolução de CWD Agnostic (Permite rodar de fora da pasta do dev-workspace)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
WORKLOG_DIR="$REPO_ROOT/rotina-devops/worklog"

DAILY_DIR="${WORKLOG_DIR}/daily"
TEMPLATE_FILE="${WORKLOG_DIR}/templates/daily-template.md"
TODAY=$(date +"%Y-%m-%d")
DAILY_FILE="${DAILY_DIR}/${TODAY}.md"

# 1. Idempotência: Checa se já rodou
if [[ -f "$DAILY_FILE" ]]; then
    echo "✅ Aviso: O worklog de hoje ($TODAY) já foi iniciado!"
    echo "Caminho: $DAILY_FILE"
    exit 0
fi

echo "☕ Bom dia! Vamos planejar o seu worklog de hoje ($TODAY)."
echo "---------------------------------------------------------"

# ...restante da logica interativa...
read -r -p "▶ Projeto principal: " PROJ_MAIN
read -r -p "▶ Projeto secundário (opcional): " PROJ_SEC
read -r -p "▶ Objetivo do dia: " OBJ_DAY

echo "---------------------------------------------------------"
echo "Gerando log do dia..."

# 3. Criação
cp "$TEMPLATE_FILE" "$DAILY_FILE"
sed -i "s/{{DATE}}/$TODAY/g" "$DAILY_FILE"

# 4. Construção do plano
TMP_PLAN=$(mktemp)
PROJ_PREFIX=""
[[ -n "$PROJ_MAIN" ]] && PROJ_PREFIX="[$PROJ_MAIN] "

echo "- [ ] **Principal:** ${PROJ_PREFIX}${OBJ_DAY:-Sem objetivo definido}" > "$TMP_PLAN"
[[ -n "$PROJ_SEC" ]] && echo "- [ ] **Secundário:** [$PROJ_SEC]" >> "$TMP_PLAN"

# 5. Inserção
sed -i '/- \[ \] \[projeto\] Tarefa foco/d' "$DAILY_FILE"
sed -i -e "/## 1. Plano do Dia/r $TMP_PLAN" "$DAILY_FILE"
rm "$TMP_PLAN"

# 6. Auto-abertura segura
echo "---------------------------------------------------------"
if command -v code >/dev/null 2>&1; then
    echo "⚡ Abrindo arquivo no VS Code automaticamente..."
    code "$DAILY_FILE"
else
    echo "💡 Dica: Arquivo pronto em '$DAILY_FILE'"
fi
