#!/usr/bin/env bash

# set -e (Não utilizamos -e global aqui para evitar saída prematura do grep e comandos de verificação)

TARGET_DIR="${1:-$(pwd)}"
# Força o diretório raiz exato deste workspace baseando-se no caminho fixo deste repo principal
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GOVERNANCE_TEXT="$WORKSPACE_DIR/gestao-centralizada-agents/agent-governance-snippet.md"

echo "================================================="
echo "[ INIT ] Iniciando Adoção de Governança (Dev-Workspace)"
echo "[ TARGET ] Alvo: $TARGET_DIR"
echo "================================================="

# 0. Checagem Base
if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ FATAL ] O diretório escolhido não aparenta ser um repositório Git (.git ausente)."
    echo "[ TIP ] Entre na pasta e inicialize-o com 'git init' primeiro."
    exit 1
fi

cd "$TARGET_DIR" || exit 1

# 1. Copiando Regras do Pre-commit (Shift-Left Security)
echo "[ STEP 1/6 ] Sincronizando Pipeline Local (.pre-commit-config.yaml)..."
cp "$WORKSPACE_DIR/.pre-commit-config.yaml" . || echo "   [ WARN ] Falha ao copiar .pre-commit-config.yaml."
echo "   [ OK ] Arquivo de regras copiado com sucesso."

# 2. Avaliando Manifesto de IA
echo "[ STEP 2/6 ] Padronizando IA e Comportamento (AGENTS.md)..."
touch AGENTS.md
if [ -f "$GOVERNANCE_TEXT" ]; then
    if ! grep -q "Padrão de Governança Global" AGENTS.md 2>/dev/null; then
        cat "$GOVERNANCE_TEXT" >> AGENTS.md
        echo "   [ OK ] Texto de governança global injetado no AGENTS.md."
    else
        echo "   [ INFO ] AGENTS.md já estava adequado."
    fi
else
    echo "   [ WARN ] Snippet de governança central não encontrado em $GOVERNANCE_TEXT."
fi

# 3. Entrypoint de Operações (Makefile)
echo "[ STEP 3/6 ] Validando Entrypoint (Makefile)..."
if [ ! -f "Makefile" ]; then
    cp "$WORKSPACE_DIR/Makefile" . || echo "   [ WARN ] Falha ao copiar Makefile base."
    echo "   [ OK ] Makefile original do workspace copiado. (Lembre-se de adaptá-lo ao contexto do projeto)."
else
    echo "   [ INFO ] O projeto já possui um Makefile. Mantendo intacto para evitar sobrescrever customizações."
fi

# 4. Organização Estrutural Básica (Docs e Segredos)
echo "[ STEP 4/6 ] Scaffold e Limpeza Estrutural Básica..."
mkdir -p docs
echo "   [ OK ] Diretório docs/ garantido."
if [ ! -f ".env.example" ]; then
    echo "# Substitua as chaves abaixo e renomeie este arquivo para .env. NUNCA comite o .env real." > .env.example
    echo "   [ OK ] Stub de .env.example gerado."
fi
if [ ! -f ".gitignore" ]; then
    echo -e ".env\n.env.*\n!.env.example\nnode_modules/\nvenv/\n.terraform/\n*.tfstate*\n*.tfvars" > .gitignore
    echo "   [ OK ] .gitignore padrão criado."
fi

# 5. Inicialização Limpeza Mínima de README
echo "[ STEP 5/6 ] Verificando Entrypoint de Entrada do Projeto (README.md)..."
if [ ! -f "README.md" ]; then
    echo -e "# Novo Projeto Adequado\n\nEste repositório foi enquadrado nas diretrizes de Platform Engineering.\n\n## Como iniciar\n\`\`\`bash\nmake setup\n\`\`\`" > README.md
    echo "   [ OK ] README.md base criado."
else
    echo "   [ INFO ] README.md exite. Recomendado limpar excesso de jargões técnicos para focar em entrada (make)."
fi

# 6. Ativando a barreira defensiva globalmente
echo "[ STEP 6/6 ] Configurando e Instalando os Hooks no Git..."
export PATH="$HOME/.local/bin:$PATH"

if command -v pre-commit &> /dev/null; then
    pre-commit install
else
    echo "[ WARN ] 'pre-commit' não achado via shell normal, instalando pacote local via python..."
    pip3 install --user pre-commit --quiet || echo "[ FATAL ] Erro ao tentar usar pip3. Instale manualmente: pip install pre-commit"
    export PATH="$HOME/.local/bin:$PATH"
    pre-commit install
fi

echo ""
echo "================================================="
echo "[ DONE ] ADOÇÃO CONCLUÍDA! O seu repositório agora está operando"
echo "         sob a governança e padronização da plataforma principal."
echo "         Arquivos de base (.env.example, docs/, .gitignore) criados."
echo "         Dê um 'git status', refine o README.md e comite os arquivos."
echo "================================================="
