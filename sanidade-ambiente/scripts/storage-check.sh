#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Script: storage-check.sh
# Propósito: Telemetria matinal de consumo de disco focado no inchaço comum
#            das ferramentas DevOps (Docker images, dangling volumes, caches).
# ==============================================================================

CYAN='\033[0;36m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- Varedura de Armazenamento Operacional ---${NC}"

# 1. Telemetria do Docker
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    echo "📊 Resumo de Consumo Docker:"
    docker system df

    echo -e "\n${YELLOW}💡 Ação Gerencial Sugerida:${NC}"
    echo "Se o espaço recuperável (RECLAIMABLE) ou imagens build-cache estiverem infladas,"
    echo "execute manualmente no terminal: ${CYAN}docker system prune -a --volumes${NC}"
else
    echo -e "${RED}[!] Docker não está rodando. Telemetria pulada.${NC}"
fi

# 2. Varredura de Caches Ocultos no Home
echo -e "\n📂 Maiores ofensores de disco cacheado na sua Home (Top 5 Pastas):"
# Ignoramos erros do `du` pois cache/configs têm permissões variadas
du -sh ~/.cache ~/.npm ~/.composer ~/.asdf ~/.docker ~/.cargo ~/.local/share 2>/dev/null | sort -hr | head -n 5 || true

echo -e "${CYAN}---------------------------------------------${NC}"
exit 0
