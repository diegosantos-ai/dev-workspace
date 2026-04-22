#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEV_WORKSPACE_ROOT="$(cd "${AGENTS_DIR}/.." && pwd)"
SKILLS_DIR="${AGENTS_DIR}/skills-mcp"

export PATH="$HOME/.local/bin:$HOME/.asdf/shims:$HOME/.asdf/bin:$PATH"

load_agents_env() {
  if [ -f "$HOME/.agents-env" ]; then
    set -a
    # shellcheck source=/dev/null
    . "$HOME/.agents-env"
    set +a
  fi

  export DEV_WORKSPACE_ROOT
  export MCP_SKILLS_PATH="$SKILLS_DIR"
}

ensure_node_runtime() {
  if [ -f "$HOME/.asdf/asdf.sh" ]; then
    # shellcheck source=/dev/null
    . "$HOME/.asdf/asdf.sh"
  fi

  if ! command -v node >/dev/null 2>&1; then
    printf '[ERRO] Node.js nao encontrado. Rode "make asdf-install".\n' >&2
    exit 1
  fi

  if ! command -v npm >/dev/null 2>&1; then
    printf '[ERRO] npm nao encontrado. Rode "make asdf-install".\n' >&2
    exit 1
  fi
}

ensure_build() {
  cd "$SKILLS_DIR"

  if [ ! -d node_modules ]; then
    if [ -f package-lock.json ]; then
      npm ci >/dev/null
    else
      npm install >/dev/null
    fi
  fi

  if [ ! -f build/index.js ] || find src -type f -newer build/index.js | grep -q .; then
    npm run build >/dev/null
  fi
}

main() {
  load_agents_env
  ensure_node_runtime

  case "${1:-}" in
    --print-root)
      printf '%s\n' "$DEV_WORKSPACE_ROOT"
      ;;
    --ensure-build)
      ensure_build
      printf '[OK] build MCP garantido em %s\n' "$SKILLS_DIR"
      ;;
    *)
      ensure_build
      cd "$SKILLS_DIR"
      exec node build/index.js
      ;;
  esac
}

main "${1:-}"
