#!/usr/bin/env bash

# set -e (Não utilizamos -e global aqui para evitar saída prematura do grep e comandos de verificação)

TARGET_DIR="${1:-$(pwd)}"
WORKSPACE_DIR="$HOME/dev-workspace"
GOVERNANCE_TEXT="$WORKSPACE_DIR/templates/agent-governance-snippet.md"

echo "================================================="
echo "[ INIT ] Iniciando Adoção de Governança (Dev-Workspace)"
echo "[ TARGET ] Alvo: $TARGET_DIR"
echo "================================================="

# 0. Checagem Base
if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ FATAL ] O diretório escolhido não aparenta ser um repositório Git (.git ausente)."
    echo "[ TIP ] Entre na pasta de um projeto clonado ou inicialize-o com 'git init' primeiro."
    exit 1
fi

cd "$TARGET_DIR" || exit 1

# 1. Copiando Regras do Pre-commit (Shift-Left Security)
echo "[ STEP 1/4 ] Sincronizando Pipeline Local (.pre-commit-config.yaml)..."
cp "$WORKSPACE_DIR/.pre-commit-config.yaml" .
echo "   [ OK ] Arquivo de regras copiado com sucesso."

# 2. Avaliando Manifesto de IA
echo "[ STEP 2/4 ] Padronizando IA e Comportamento (AGENTS.md)..."
touch AGENTS.md # Garante que o arquivo exista
if ! grep -q "Padrão de Governança Global" AGENTS.md 2>/dev/null; then
    cat "$GOVERNANCE_TEXT" >> AGENTS.md
    echo "   [ OK ] Texto de governança global injetado no AGENTS.md."
else
    echo "   [ INFO ] AGENTS.md já estava adequado."
fi

# 3. Entrypoint de Operações (Makefile)
echo "[ STEP 3/4 ] Validando Entrypoint (Makefile)..."
if [ ! -f "Makefile" ]; then
    cp "$WORKSPACE_DIR/Makefile" .
    echo "   [ OK ] Makefile original do workspace copiado. (Lembre-se de adaptá-lo ao contexto do projeto)."
else
    echo "   [ INFO ] O projeto já possui um Makefile. Mantendo intacto para evitar sobrescrever customizações."
fi

# 4. Ativando a barreira defensiva globalmente
echo "[ STEP 4/4 ] Configurando e Instalando os Hooks no Git..."
export PATH="$HOME/.local/bin:$PATH"

if command -v pre-commit &> /dev/null; then
    pre-commit install
else
    echo "[ WARN ] 'pre-commit' não achado via shell normal, instalando pacote local via python..."
    pip3 install --user pre-commit --quiet || echo "[ FATAL ] Erro ao tentar usar pip3. Instale manualmente: pip install pre-commit"

    # Recarrega variáveis do pip e instala
    export PATH="$HOME/.local/bin:$PATH"
    pre-commit install
fi

echo ""
echo "================================================="
echo "[ DONE ] ADOÇÃO CONCLUÍDA! O seu repositório agora está operando"
echo "         sob a governança e padronização da plataforma principal."
echo "         Dê um 'git status' logo mais e comite os arquivos."
echo "================================================="
