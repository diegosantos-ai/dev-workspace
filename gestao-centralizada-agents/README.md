# 📖 Gestão Centralizada de Agentes

Bem-vindo ao Cockpit de IAs e fluxos de trabalho gerados! Esta documentação mostra como você (ou qualquer novo mantenedor) inicia e valida toda a fundação de Agentes deste repositório isolando responsabilidades.

## 🚀 Como Executar o Workspace (Bootstrap)

Tudo ocorre pelo entrypoint do repositório base. Não digite comandos imperativos longos de pacotes no terminal.

**1. Instale o Runtimes Globais**
Para ter o gerenciador de pacotes isolados de Python (`pipx`) e outras dependências sem poluir sua máquina:
```bash
cd dev-workspace/
make setup-agents
```
*(Isso varrerá localmente usando seu setup de automação e instalará seu motor principal de Agentes. E atualizará seu `~/.agents-env` com suas chaves locais omitidas no git)*.

**2. Suba o Cockpit (Observabilidade + Vetores + N8n)**
```bash
make start-orquestrador
```
*(Isso iniciará pela porta injetada de testes a base vetorial e o dashboard para debug de Agentes e fluxos transacionais).*

## 🧪 Como Validar as Skills

**3. Instancie e valide as ferramentas (Skills MCP)**
Todo novo conjunto de ferramentas adicionadas na pasta `/skills-mcp/` precisa respeitar o protocolo:
```bash
make test-skills
```
Se tudo rodou e o lint da plataforma (`make lint`) passou sem chaves expostas, sua "Tríade de Agentes" estará conectada e funcional para planejar e atuar pela sua engenharia.
