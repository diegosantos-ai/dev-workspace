#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

REMOTE="${REMOTE:-origin}"
BASE_BRANCH="${BASE_BRANCH:-main}"
HEAD_BRANCH="${HEAD_BRANCH:-develop}"
DEFAULT_TITLE="release: promover develop para main"
PR_TITLE="${TITLE:-${PR_TITLE:-${DEFAULT_TITLE}}}"
MAX_ITEMS="${MAX_ITEMS:-30}"

error() {
  printf '[ERRO] %s\n' "$1" >&2
}

info() {
  printf '[INFO] %s\n' "$1"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    error "Comando obrigatorio nao encontrado: $1"
    exit 1
  fi
}

ensure_clean_worktree() {
  if [ -n "$(git status --porcelain)" ]; then
    error "Worktree possui alteracoes locais. Finalize commit/stash antes de abrir o PR de release."
    git status --short
    exit 1
  fi
}

ensure_current_branch() {
  local current_branch
  current_branch="$(git branch --show-current)"

  if [ "${current_branch}" != "${HEAD_BRANCH}" ]; then
    error "Este fluxo deve ser executado a partir da branch ${HEAD_BRANCH}. Branch atual: ${current_branch:-detached HEAD}."
    exit 1
  fi
}

ensure_remote_branch() {
  local branch="$1"

  if ! git rev-parse --verify --quiet "${REMOTE}/${branch}" >/dev/null; then
    error "Branch remota nao encontrada: ${REMOTE}/${branch}"
    exit 1
  fi
}

ensure_pr_delta() {
  local commit_count
  commit_count="$(git rev-list --count "${REMOTE}/${BASE_BRANCH}..${REMOTE}/${HEAD_BRANCH}")"

  if [ "${commit_count}" -eq 0 ]; then
    error "Nao ha commits em ${REMOTE}/${HEAD_BRANCH} pendentes de promocao para ${REMOTE}/${BASE_BRANCH}."
    exit 1
  fi
}

print_limited_list() {
  local total="$1"
  local label="$2"
  local remaining
  shift 2

  if [ "${total}" -eq 0 ]; then
    printf -- '- Nenhum item identificado.\n'
    return 0
  fi

  local count=0
  for item in "$@"; do
    if [ "${count}" -ge "${MAX_ITEMS}" ]; then
      break
    fi

    if [ "${label}" = "file" ]; then
      printf -- '- `%s`\n' "${item}"
    else
      printf -- '- %s\n' "${item}"
    fi

    count=$((count + 1))
  done

  if [ "${total}" -gt "${MAX_ITEMS}" ]; then
    remaining=$((total - MAX_ITEMS))
    printf -- '- ... mais %d itens\n' "${remaining}"
  fi
}

create_pr_body() {
  local body_file="$1"
  local commit_range="${REMOTE}/${BASE_BRANCH}..${REMOTE}/${HEAD_BRANCH}"
  local diff_range="${REMOTE}/${BASE_BRANCH}...${REMOTE}/${HEAD_BRANCH}"
  local commits_total files_total
  local -a commits files

  mapfile -t commits < <(git log --no-merges --pretty=format:'%s (%h)' "${commit_range}")
  mapfile -t files < <(git diff --name-only "${diff_range}")

  commits_total="${#commits[@]}"
  files_total="${#files[@]}"

  {
    printf '## Objetivo\n'
    printf 'Promover a branch `%s` para `%s` apos estabilizacao da fase atual.\n\n' "${HEAD_BRANCH}" "${BASE_BRANCH}"

    printf '## Escopo\n'
    printf 'Commits incluidos:\n'
    print_limited_list "${commits_total}" "commit" "${commits[@]}"
    printf '\nArquivos alterados:\n'
    print_limited_list "${files_total}" "file" "${files[@]}"

    printf '\n## Estatisticas\n'
    git diff --stat "${diff_range}" | sed 's/^/    /'

    printf '\n## Validacao\n'
    printf -- '- `make lint`\n\n'

    printf '## Observacoes\n'
    printf -- '- PR de promocao `%s` -> `%s` gerado por automacao local.\n' "${HEAD_BRANCH}" "${BASE_BRANCH}"
  } >"${body_file}"
}

main() {
  local body_file existing_pr_url

  cd "${REPO_ROOT}"

  require_command git
  require_command gh
  require_command make

  if ! gh auth status >/dev/null 2>&1; then
    error "GitHub CLI nao esta autenticado. Execute gh auth login antes de abrir o PR."
    exit 1
  fi

  ensure_current_branch
  ensure_clean_worktree

  info "Sincronizando referencias remotas."
  git fetch "${REMOTE}" --prune
  ensure_remote_branch "${BASE_BRANCH}"
  ensure_remote_branch "${HEAD_BRANCH}"

  info "Atualizando ${HEAD_BRANCH} por fast-forward."
  git pull --ff-only "${REMOTE}" "${HEAD_BRANCH}"

  info "Executando validacao local."
  make lint

  info "Publicando ${HEAD_BRANCH}."
  git push "${REMOTE}" "${HEAD_BRANCH}"
  git fetch "${REMOTE}" "${BASE_BRANCH}" "${HEAD_BRANCH}" --prune

  ensure_pr_delta

  existing_pr_url="$(
    gh pr list \
      --base "${BASE_BRANCH}" \
      --head "${HEAD_BRANCH}" \
      --state open \
      --json url \
      --jq '.[0].url // empty'
  )"

  if [ -n "${existing_pr_url}" ]; then
    info "PR aberto ja existe: ${existing_pr_url}"
    exit 0
  fi

  body_file="$(mktemp)"
  trap 'rm -f "${body_file}"' EXIT
  create_pr_body "${body_file}"

  info "Abrindo PR ${HEAD_BRANCH} -> ${BASE_BRANCH}."
  gh pr create \
    --base "${BASE_BRANCH}" \
    --head "${HEAD_BRANCH}" \
    --title "${PR_TITLE}" \
    --body-file "${body_file}"
}

main "$@"
