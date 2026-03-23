#!/bin/bash

TARGET_DIR=${1:-.}
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../templates" && pwd)"
MANIFEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ ! -d "$TARGET_DIR/.git" ]; then
    exit 1
fi

cp "$TEMPLATE_DIR/docs/CONTEXTO.md" "$TARGET_DIR/CONTEXTO.md"
cp "$TEMPLATE_DIR/docs/ARQUITETURA.md" "$TARGET_DIR/ARQUITETURA.md"
cp "$MANIFEST_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
cp "$MANIFEST_DIR/.pre-commit-config.yaml" "$TARGET_DIR/.pre-commit-config.yaml"

if [ ! -f "$TARGET_DIR/Makefile" ]; then
    cp "$MANIFEST_DIR/Makefile" "$TARGET_DIR/Makefile"
fi

if [ ! -f "$TARGET_DIR/docker-compose.yml" ]; then
    cp "$TEMPLATE_DIR/docker/docker-compose.yml" "$TARGET_DIR/docker-compose.yml"
fi

cd "$TARGET_DIR" || exit
pre-commit install
