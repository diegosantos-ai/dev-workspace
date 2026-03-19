#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# DESCRIÇÃO: Script para efetuar o wrap-up do fim de expediente.
# ARQUITETURA: Preenche interativamente a seção final do daily log. É idempotente.
#-------------------------------------------------------------------------------

set -euo pipefail

# Resolução de CWD Agnostic
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
REPO_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
WORKLOG_DIR="$REPO_ROOT/rotina-devops/worklog"

DAILY_DIR="${WORKLOG_DIR}/daily"
TODAY=$(date +"%Y-%m-%d")
DAILY_FILE="${DAILY_DIR}/${TODAY}.md"

# 1. Validação de Estado
if [[ ! -f "$DAILY_FILE" ]]; then
    echo "❌ Erro: O arquivo do worklog de hoje não existe ($DAILY_FILE)."
    echo "💡 Não há um dia aberto para ser fechado."
    exit 1
fi

echo "🏁 Iniciando o Fechamento do dia $TODAY..."
echo "Pressione [Enter] para pular os campos que não quiser preencher."
echo "---------------------------------------------------------"

read -r -p "✅ Concluído (Resumo do saldo): " CONCLUIDO
read -r -p "🚧 Pendente (O que não deu tempo): " PENDENTE
read -r -p "⏭️  Próximo passo (Prioridade pra amanhã): " PROXIMO
read -r -p "🛑 Bloqueios (Teve algum impedimento?): " BLOQUEIOS
read -r -p "🧠 Aprendizado (Anotação útil): " APRENDIZADO

echo "---------------------------------------------------------"
echo "Gravando fechamento no arquivo..."

# 2. Idempotência: Deleta a seção de fechamento antiga (e tudo que houver abaixo)
sed -i '/^## 3. Fechamento/,$d' "$DAILY_FILE"

# 3. Reescreve a seção
echo "" >> "$DAILY_FILE"
echo "## 3. Fechamento" >> "$DAILY_FILE"

# Só injeta os itens que receberam conteúdo
[[ -n "$CONCLUIDO" ]]   && echo "- **Concluído:** $CONCLUIDO" >> "$DAILY_FILE"
[[ -n "$PENDENTE" ]]    && echo "- **Pendente:** $PENDENTE" >> "$DAILY_FILE"
[[ -n "$PROXIMO" ]]     && echo "- **Próximo passo:** $PROXIMO" >> "$DAILY_FILE"
[[ -n "$BLOQUEIOS" ]]   && echo "- **Bloqueios:** $BLOQUEIOS" >> "$DAILY_FILE"
[[ -n "$APRENDIZADO" ]] && echo "- **Aprendizado:** $APRENDIZADO" >> "$DAILY_FILE"

if [[ -z "$CONCLUIDO" && -z "$PENDENTE" && -z "$PROXIMO" && -z "$BLOQUEIOS" && -z "$APRENDIZADO" ]]; then
    echo "- Fechamento rotineiro (sem notas detalhadas)." >> "$DAILY_FILE"
fi

echo "✅ Fechamento gravado com sucesso!"
