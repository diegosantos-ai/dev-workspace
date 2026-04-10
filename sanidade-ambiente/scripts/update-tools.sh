#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
REPORT_DIR="${SCRIPT_DIR}/../reports"
TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
REPORT_FILE="${REPORT_DIR}/update-tools-${TIMESTAMP}.log"

export PATH="$HOME/.local/bin:$PATH"

mkdir -p "$REPORT_DIR"

declare -a RESULT_LABELS=()
declare -a RESULT_CHANNELS=()
declare -a RESULT_INSTALLED=()
declare -a RESULT_AVAILABLE=()
declare -a RESULT_STATUSES=()
declare -a RESULT_DETAILS=()

declare -a UPDATE_LABELS=()
declare -a UPDATE_KINDS=()
declare -a UPDATE_REFS=()

log() {
  printf '%s\n' "$*" | tee -a "$REPORT_FILE"
}

normalize_version() {
  local version="${1:-}"

  case "$version" in
    v*) version="${version#v}" ;;
  esac

  printf '%s\n' "$version"
}

command_version() {
  local cmd="$1"
  local output=""

  if ! command -v "$cmd" >/dev/null 2>&1; then
    return 0
  fi

  if command -v timeout >/dev/null 2>&1; then
    output="$(timeout 10 "$cmd" --version 2>/dev/null | head -n 1 || true)"
  else
    output="$("$cmd" --version 2>/dev/null | head -n 1 || true)"
  fi

  printf '%s\n' "$output"
}

npm_latest_version() {
  local package_name="$1"
  local output=""

  if ! command -v npm >/dev/null 2>&1; then
    return 0
  fi

  if command -v timeout >/dev/null 2>&1; then
    output="$(timeout 15 npm view "$package_name" version 2>/dev/null || true)"
  else
    output="$(npm view "$package_name" version 2>/dev/null || true)"
  fi

  printf '%s\n' "$output"
}

code_extension_version() {
  local extension_id="$1"

  if ! command -v code >/dev/null 2>&1; then
    return 0
  fi

  code --list-extensions --show-versions 2>/dev/null |
    awk -F@ -v extension_id="$extension_id" '$1 == extension_id { print $2; exit }'
}

marketplace_latest_extension_version() {
  local extension_id="$1"
  local payload=""
  local output=""

  if ! command -v curl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    return 0
  fi

  payload="$(jq -nc --arg extension_id "$extension_id" \
    '{"filters":[{"criteria":[{"filterType":7,"value":$extension_id}],"pageNumber":1,"pageSize":1,"sortBy":0,"sortOrder":0}],"assetTypes":[],"flags":103}')"

  output="$(curl -fsSL --max-time 15 \
    -H 'Accept: application/json;api-version=7.2-preview.1' \
    -H 'Content-Type: application/json' \
    -X POST 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
    -d "$payload" |
    jq -r '.results[0].extensions[0].versions[0].version // empty' 2>/dev/null || true)"

  printf '%s\n' "$output"
}

queue_update() {
  UPDATE_LABELS+=("$1")
  UPDATE_KINDS+=("$2")
  UPDATE_REFS+=("$3")
}

record_result() {
  RESULT_LABELS+=("$1")
  RESULT_CHANNELS+=("$2")
  RESULT_INSTALLED+=("$3")
  RESULT_AVAILABLE+=("$4")
  RESULT_STATUSES+=("$5")
  RESULT_DETAILS+=("$6")
}

inspect_npm_tool() {
  local label="$1"
  local command_name="$2"
  local package_name="$3"
  local installed="nao-instalado"
  local available="-"
  local status="nao-instalado"
  local detail=""

  if command -v "$command_name" >/dev/null 2>&1; then
    installed="$(normalize_version "$(command_version "$command_name")")"
    available="$(normalize_version "$(npm_latest_version "$package_name")")"

    if [ -z "$installed" ]; then
      installed="desconhecido"
    fi

    if [ -n "$available" ]; then
      if [ "$installed" = "$available" ]; then
        status="ok"
      else
        status="update-disponivel"
        queue_update "$label" "npm-global" "$package_name"
      fi
    else
      available="-"
      status="sem-verificacao-remota"
      detail="Falha ao consultar o registro npm."
    fi
  fi

  record_result "$label" "npm:${package_name}" "$installed" "$available" "$status" "$detail"
}

inspect_vscode_tool() {
  local label="$1"
  local extension_id="$2"
  local binary_name="${3:-}"
  local installed="nao-instalado"
  local available="-"
  local status="nao-instalado"
  local detail=""
  local cli_version=""

  if [ -n "$binary_name" ] && command -v "$binary_name" >/dev/null 2>&1; then
    cli_version="$(command_version "$binary_name")"
  fi

  installed="$(code_extension_version "$extension_id")"
  if [ -n "$installed" ]; then
    available="$(marketplace_latest_extension_version "$extension_id")"

    if [ -n "$available" ]; then
      if [ "$installed" = "$available" ]; then
        status="ok"
      else
        status="update-disponivel"
        queue_update "$label" "vscode-extension" "$extension_id"
      fi
    else
      available="-"
      status="sem-verificacao-remota"
      detail="Falha ao consultar o Marketplace do VS Code."
    fi

    if [ -n "$cli_version" ]; then
      detail="Binario local: ${cli_version}"
    fi
  elif [ -n "$cli_version" ]; then
    installed="$cli_version"
    status="instalado-fora-do-canal"
    detail="Binario presente no PATH, mas a extensao ${extension_id} nao foi encontrada."
  fi

  record_result "$label" "vscode:${extension_id}" "$installed" "$available" "$status" "$detail"
}

inspect_claude_tool() {
  if command -v claude >/dev/null 2>&1; then
    inspect_npm_tool "Claude Code" "claude" "@anthropic-ai/claude-code"
    return 0
  fi

  inspect_vscode_tool "Claude Code" "anthropic.claude-code" "claude"
}

npm_update_command() {
  local package_name="$1"
  local npm_prefix=""

  npm_prefix="$(npm config get prefix 2>/dev/null || true)"

  if [ -n "$npm_prefix" ] && [ ! -w "$npm_prefix" ] && [ ! -w "${npm_prefix}/lib" ]; then
    printf 'sudo npm install -g %q\n' "${package_name}@latest"
  else
    printf 'npm install -g %q\n' "${package_name}@latest"
  fi
}

run_update() {
  local kind="$1"
  local reference="$2"

  case "$kind" in
    npm-global)
      eval "$(npm_update_command "$reference")"
      ;;
    vscode-extension)
      code --install-extension "$reference" --force
      ;;
    *)
      return 1
      ;;
  esac
}

print_table() {
  local i=0

  log ""
  log "Ferramenta         | Canal                            | Local           | Disponivel      | Status"
  log "-------------------+----------------------------------+-----------------+------------------+-----------------------"

  for ((i = 0; i < ${#RESULT_LABELS[@]}; i += 1)); do
    printf '%-19s | %-32s | %-15s | %-16s | %s\n' \
      "${RESULT_LABELS[$i]}" \
      "${RESULT_CHANNELS[$i]}" \
      "${RESULT_INSTALLED[$i]}" \
      "${RESULT_AVAILABLE[$i]}" \
      "${RESULT_STATUSES[$i]}" | tee -a "$REPORT_FILE"

    if [ -n "${RESULT_DETAILS[$i]}" ]; then
      printf '  detalhe: %s\n' "${RESULT_DETAILS[$i]}" | tee -a "$REPORT_FILE"
    fi
  done
}

prompt_choice() {
  local reply="${WORKSPACE_UPDATE_CONFIRM:-}"

  case "${reply,,}" in
    y|yes|true|1)
      printf 'y\n'
      return 0
      ;;
    n|no|false|0)
      printf 'n\n'
      return 0
      ;;
  esac

  if [ ! -t 0 ] || [ ! -t 1 ]; then
    printf 'n\n'
    return 0
  fi

  printf 'Aplicar as atualizacoes disponiveis? [y/N] '
  read -r reply
  printf '%s\n' "${reply:-n}"
}

main() {
  local answer=""
  local i=0
  local ok_count=0
  local update_count=0
  local missing_count=0
  local unknown_count=0

  cd "$REPO_ROOT"

  : > "$REPORT_FILE"
  log "Rotina de manutencao de ferramentas do workspace"
  log "Repositorio: ${REPO_ROOT}"
  log "Relatorio: ${REPORT_FILE}"
  log "Data: $(date --iso-8601=seconds)"

  inspect_npm_tool "Gemini CLI" "gemini" "@google/gemini-cli"
  inspect_vscode_tool "Codex CLI" "openai.chatgpt" "codex"
  inspect_npm_tool "OpenCode CLI" "opencode" "opencode-ai"
  inspect_claude_tool

  print_table

  for ((i = 0; i < ${#RESULT_STATUSES[@]}; i += 1)); do
    case "${RESULT_STATUSES[$i]}" in
      ok)
        ok_count=$((ok_count + 1))
        ;;
      update-disponivel)
        update_count=$((update_count + 1))
        ;;
      nao-instalado)
        missing_count=$((missing_count + 1))
        ;;
      *)
        unknown_count=$((unknown_count + 1))
        ;;
    esac
  done

  log ""
  log "Resumo:"
  log "  - ok: ${ok_count}"
  log "  - com update: ${update_count}"
  log "  - nao instalados: ${missing_count}"
  log "  - sem verificacao ou fora do canal: ${unknown_count}"

  if [ ${#UPDATE_LABELS[@]} -eq 0 ]; then
    log ""
    log "Nenhuma atualizacao elegivel foi encontrada."
    exit 0
  fi

  answer="$(prompt_choice)"
  case "${answer,,}" in
    y|yes)
      log ""
      log "Aplicando atualizacoes confirmadas..."

      for ((i = 0; i < ${#UPDATE_LABELS[@]}; i += 1)); do
        log ""
        log "[UPDATE] ${UPDATE_LABELS[$i]} via ${UPDATE_KINDS[$i]} (${UPDATE_REFS[$i]})"
        if run_update "${UPDATE_KINDS[$i]}" "${UPDATE_REFS[$i]}"; then
          log "[OK] ${UPDATE_LABELS[$i]} atualizado."
        else
          log "[FAIL] Falha ao atualizar ${UPDATE_LABELS[$i]}."
        fi
      done

      log ""
      log "Atualizacao concluida. Rode 'make update' novamente para um novo relatorio validado."
      ;;
    *)
      log ""
      log "Modo relatorio: nenhuma alteracao foi aplicada."
      ;;
  esac
}

main "$@"
