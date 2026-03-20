#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# DESCRIÇÃO: Script para adicionar uma entrada (log entry) no dia atual.
# ARQUITETURA: Realiza append no arquivo do dia com suporte CLI ou Interativo.
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
    echo "💡 Execute primeiro 'make day-start'."
    exit 1
fi

# 2. Resolução de Modo (Interativo vs CLI)
if [[ $# -eq 0 ]]; then
    echo "📝 Adicionando Log (Modo Interativo)"
    echo "---------------------------------------------------------"
    read -r -p "▶ Projeto (ex: dev-workspace): " PROJETO

    # Loop de Validação: Tipo
    while true; do
        read -r -p "▶ Tipo (planejamento|execucao|correcao|documentacao|estudo|manutencao): " TIPO
        case "$TIPO" in
            planejamento|execucao|correcao|documentacao|estudo|manutencao) break ;;
            *) echo "  ❌ Inválido. Digite uma das opções acima." ;;
        esac
    done

    read -r -p "▶ Ação (o que foi feito?): " ACAO
    read -r -p "▶ Resultado (qual foi a entrega?): " RESULTADO

    # Loop de Validação: Impacto
    while true; do
        read -r -p "▶ Impacto (baixo|medio|alto): " IMPACTO
        case "$IMPACTO" in
            baixo|medio|alto) break ;;
            *) echo "  ❌ Inválido. Digite: baixo, medio ou alto." ;;
        esac
    done

elif [[ $# -eq 5 ]]; then
    PROJETO="$1"
    TIPO="$2"
    ACAO="$3"
    RESULTADO="$4"
    IMPACTO="$5"

    case "$TIPO" in
        planejamento|execucao|correcao|documentacao|estudo|manutencao) ;;
        *) echo "❌ Erro: Tipo '$TIPO' inválido."; exit 1 ;;
    esac

    case "$IMPACTO" in
        baixo|medio|alto) ;;
        *) echo "❌ Erro: Impacto '$IMPACTO' inválido."; exit 1 ;;
    esac
else
    echo "❌ Erro: Quantidade incorreta de parâmetros."
    echo "Uso Interativo: make log"
    echo "Uso CLI: make log ARGS=\"<projeto> <tipo> <acao> <resultado> <impacto>\""
    exit 1
fi

# 3. Formatação da nova entrada
HHMM=$(date +"%H:%M")
NOVO_EVENTO="- **${HHMM}** | ${PROJETO} | ${TIPO} | ${ACAO} | ${RESULTADO} | impacto: ${IMPACTO}"

# 4. Inserção Inteligente (Antes da seção '3. Fechamento')
sed -i "s@^## 3. Fechamento@${NOVO_EVENTO}\n\n## 3. Fechamento@" "$DAILY_FILE"

echo "---------------------------------------------------------"
echo "✅ Log registrado com sucesso em: $DAILY_FILE"
