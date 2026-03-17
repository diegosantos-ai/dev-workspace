# 🧠 Playbook: Governança de IA (LLM, Copilot, MCP)

Este guia resolve o problema das "IAs Frankenstein", garantindo que qualquer grande modelo de linguagem (LLM) atuando localmente na sua máquina trabalhe sob as exatas mesmas regras e mantenha seu ambiente limpo.

---

## 1. O Problema do "Espaço Absurdo" e Copiar Pastas
Você **NÃO** precisa copiar regras (`AGENTS.md`) soltas para dentro da pasta de cada cliente que você atende, poluindo o Git deles.

**A Solução de "Referência Absoluta":**
Sempre que ligar um modelo (Cursor, Cline, Github Copilot, Claude CLI) num projeto legado, inicie o Chat com este prompt-base (Mestre):
> *"Atue como Senior Platform Engineer. Antes de me sugerir qualquer refatoração, leia estritamente as regras de ouro documentadas no arquivo global em: `/home/diegosantos/docs/dev-workspace/playbooks/playbook-padrao-operacional-trabalho.md`."* 

No caso do VS Code (Copilot), resolvemos isso definindo a configuração: `github.copilot.chat.codeGeneration.instructions` global no seu `settings.json`. O modelo injeta essa instrução a cada mensagem sua sem você perceber. Acabei de ativar isso no seu Setup.

---

## 2. Dieta de Servidores MCP (Model Context Protocol)
Seu log acusou um JSON colossal de Servidores MCP simultâneos instalados. 
*O problema:* Cada MCP age como uma "ferramenta na mão da IA". Se você dá acesso a banco de dados, browser, CLI bash, Jira e fetch websockets ao mesmo tempo, a IA "alucina" tentando usar todas e frequentemente recusa ações simples achando que precisa chamar um servidor.

**Regra do Zero Trust MCP:**
1. **Desative tudo que não usar hoje:** O `mcp.json` deve ter idealmente 1 a 3 servidores vitais para o projeto do dia.
2. **Separe Especialidades:** 
   - Se for dia de mexer em **Infra/Terraform**, desative os MCPs de Playwright (Navegador) ou Busca Web e deixe a IA ciente apenas de Bash (Terminal) local. 
   - Se o dia for debugar **UI/FrontEnd**, desative os MCPs de AWS/DB e ligue a automação de navegadores.  

---

## 3. Os 3 Padrões para Domesticar Diferentes LLMs
Cada IA (Claude, Gemini, OpenAI) possui um "estilo" nativo (O Claude é verboso, a OpenAI pende mais para refazer funções invés de consertar, e o Gemini gosta de listar recursos). Para alinhar, sempre utilize o nosso `.pre-commit`:

Seja qual for a IA que desenhou seu código, **não corrija à mão**.
Rode `make lint` ou `pre-commit run`. A **sua máquina dita as regras** com o `tflint/checkov/shellcheck`. Pegue o erro que a máquina gerou vermelho e jogue no chat da IA:
> *"O Linter oficial da plataforma recusou seu código com este erro: [ERRO]. Conserte obedecendo a regra, não crie workarounds."*
Isso corta as "teimosias arquiteturais" de IAs diferentes num instante, pois elas devem submissão aos linters locais.
