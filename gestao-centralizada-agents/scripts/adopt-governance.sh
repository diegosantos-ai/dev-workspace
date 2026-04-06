#!/bin/bash

set -euo pipefail

TARGET_DIR="${1:-$(pwd)}"
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../templates" && pwd)"
MANIFEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

log_error() {
    printf "[ ERRO ] %s\n" "$1" >&2
}

echo "================================================="
echo "[ INIT ] Iniciando Adoção de Governança (Dev-Workspace)"
echo "[ TARGET ] Alvo: $TARGET_DIR"
echo "================================================="

# 0. Checagem Base
if [ ! -d "$TARGET_DIR" ]; then
    log_error "Diretorio alvo nao existe: $TARGET_DIR"
    exit 1
fi

if ! git -C "$TARGET_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    log_error "TARGET nao e um repositorio Git valido: $TARGET_DIR"
    log_error "Inicialize com 'git init' ou informe a raiz de um repositorio existente."
    exit 1
fi

if ! command -v pre-commit >/dev/null 2>&1; then
    log_error "pre-commit nao encontrado no PATH. Rode 'make bootstrap' no dev-workspace."
    exit 1
fi

cp "$TEMPLATE_DIR/docs/contexto.md" "$TARGET_DIR/contexto.md"
cp "$TEMPLATE_DIR/docs/arquitetura.md" "$TARGET_DIR/arquitetura.md"
cp "$MANIFEST_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
cp "$MANIFEST_DIR/.pre-commit-config.yaml" "$TARGET_DIR/.pre-commit-config.yaml"

if [ ! -f "$TARGET_DIR/Makefile" ]; then
    cp "$MANIFEST_DIR/Makefile" "$TARGET_DIR/Makefile"
fi

if [ ! -f "$TARGET_DIR/docker-compose.yml" ]; then
    cp "$TEMPLATE_DIR/docker/docker-compose.yml" "$TARGET_DIR/docker-compose.yml"
fi

if [ -d "$TEMPLATE_DIR/ports" ] && [ ! -f "$TARGET_DIR/ports.md" ]; then
    cp "$TEMPLATE_DIR/ports/ports.md" "$TARGET_DIR/ports.md"
fi

# Run scaffolding to allocate app ports and ensure external network is configured
if [ -f "$MANIFEST_DIR/scripts/new-project.sh" ] && [ -x "$MANIFEST_DIR/scripts/new-project.sh" ]; then
    bash "$MANIFEST_DIR/scripts/new-project.sh" "$TARGET_DIR" || echo "Warning: port allocation script failed"
elif [ -f "$MANIFEST_DIR/scripts/new-project.sh" ]; then
    # run with bash even if not executable (some policies may have blocked chmod)
    bash "$MANIFEST_DIR/scripts/new-project.sh" "$TARGET_DIR" || echo "Warning: port allocation script failed"
fi

cd "$TARGET_DIR"
pre-commit install

printf "[ OK ] Governanca aplicada com sucesso em %s\n" "$TARGET_DIR"
