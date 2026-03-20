# Inventário do Repositório

## 1. Estrutura da raiz
O repositório apresenta a seguinte estrutura baseida em arquivos e diretórios na raiz:

- `.github/`: Define fluxos de CI/CD para GitHub Actions.
- `.pre-commit-config.yaml`: Define hooks locais de inspeção de código e segurança.
- `AGENTS.md`: Documento de manifesto e regras de governança para uso de Inteligência Artificial.
- `Makefile`: Script orquestrador central com atalhos para setup, rotinas e testes.
- `README.md`: Documentação indexadora e explicativa sobre o workspace.
- `rotina-devops.md`: Arquivo Markdown solto com orientações operacionais.
- `ansible/`: Agrupa playbooks (`local-setup.yml`) e scripts bash focados em setup de máquina.
- `docs-referencia/`: Contém links úteis e o histórico de Decisões de Arquitetura (ADRs).
- `dotfiles/`: Hospeda as configurações em formato de espelho de diretórios (zsh, vscode, git) preparadas para gerência via GNU Stow.
- `gestao-centralizada-agents/`: Concentra a implementação de permissões, papéis (personas) e integração do Model Context Protocol (MCP) para automação assistida.
- `playbooks/`: Armazena checklists de execução baseada em texto para atividades periódicas ou manuais.
- `rotina-devops/`: Contém um microssistema formado por scripts e templates Markdown para gestão de worklogs de atividades.
- `sanidade-ambiente/`: Agrupa shell scripts (`daily-check.sh`, `env-audit.sh`) e pasta de artefatos para testar dependências na máquina.
- `templates/`: Guarda a estrutura puramente lógica e de versionamento para infraestrutura Terraform (`terraform-aws-base`, `terraform-ovh-base`).
- `teste-python/`: Diretório contendo um script nomeado `check_devops_env.sh`.

## 2. Componentes de setup e ambiente
- **Bootstrap e instalação:** Ocorre através do acionamento do `Makefile` (`make setup`), que invoca o arquivo `ansible/scripts/setup-machine.sh`.
- **Configuração de máquina:** Gerenciada pelo arquivo `ansible/local-setup.yml`, que possui definições imperativas explícitas sobre repositórios do SO Ubuntu/Debian e shell `zsh`.
- **Dotfiles:** Armazenados no escopo do diretório `dotfiles/`, sua aplicação depende de simlinks via o utilitário GNU Stow.
- **Makefile:** Funciona como registro primário de scripts através de _targets_ parametrizados (setup, lint, update, env-check, morning, etc.) auto-documentados.
- **Scripts:** Existem descentralizadamente e categorizados por domínios sob os subdiretórios específicos (ex: `rotina-devops/scripts/`).
- **Sanidade de ambiente:** Restrita a varreduras de comandos presentes e reportes de terminal por meio de execução isolada na pasta `sanidade-ambiente/`.
- **Variáveis de ambiente e secrets:** Arquivos de exemplo existem de forma pontual (`terraform.tfvars.example`), mas repositórios e instâncias de arquivos comuns (como `.env`) globais não estão presentes na estrutura persistente. Ferramenta `gitleaks` atua preventivamente via `.pre-commit-config.yaml`.
- **Versionamento de ferramentas:** A automação descreve a instalação do `asdf` e pacotes baseados em gerenciadores OS-like (`apt` e `snap`), mas não possui restrição estática em um arquivo de lock na raiz do tipo `.tool-versions`.

## 3. Componentes de infraestrutura e automação
- **Terraform:** Apresenta projetos base localizados na subpasta `templates/` (AWS e OVH).
- **Módulos:** Separados sob `templates/*/modules/` em áreas lógicas (ex: `compute`, `network`, `security`).
- **Ambientes:** Separados no diretório `envs/` que contêm subpastas para divisões do tipo `dev/` e `prod/`.
- **Templates:** O repositório enxerga os blocos infra como coleções lógicas não instanciadas, servindo apenas de esqueleto.
- **Playbooks:** Existentes tanto como código Ansible quanto na forma de manuais de texto livre em `playbooks/`.
- **Validações:** Atiçadas localmente e durante os commits pelo formato linting de `tflint`, `terraform fmt`, `yamllint` e `shellcheck`. A esteira GitHub Actions (`ci-lint-sec.yml` e `terraform-plan.yml`) replica os testes de integridade.

## 4. Componentes de documentação e governança
- **README:** O index na raiz estrutura as premissas e comandos gerais.
- **Guias e rotinas:** A documentação engloba descrições das rotinas na pasta `rotina-devops/README.md` e operacionais via `playbooks/`. Manuais interativos rodam via script bash (`worklog-start.sh`).
- **Governança de agents:** Centralizada no arquivo raiz `AGENTS.md`, mas complementada fortemente por explicações contextuais organizadas através do diretório `gestao-centralizada-agents/`.
- **Ações e Papéis:** A pasta `agents-personas/` apresenta perfis de ação definidos para guiar LLMs.
- **ADRs (Architecture Decision Records):** Implementada rigorosamente dentro da matriz de `docs-referencia/adr/`, constando com um rastreio da evolução técnica base.
- **Troubleshooting e manutenção:** Ausência de documento consolidado do tipo `TROUBLESHOOTING.md`. Em vez disso, manuais indicam scripts preventivos como o `make audit`.

## 5. Lacunas observáveis
- **Estrutura duplicada:** Documentação repetida ou conflituosa para processos paralelos. O arquivo solto `rotina-devops.md` na raiz conflita visualmente com a existência do próprio banco consolidado dentro do diretório `rotina-devops/`.
- **Naming confuso:** O diretório se chama `teste-python/`, porém hospeda um script de auditoria em bash sem associação prática observável ao Python ou sub-rotinas adjacentes.
- **Limitação de portabilidade:** O playbook do setup Ansible restringe blocos operacionais explicitamente à arquitetura da família `Debian` nas _tasks_ `apt`, não suportando ambientes distintos providos na mesma infra.
- **Ausência de configuração global cross-editor:** Falta o arquivo local `.editorconfig`.
- **Ausência de convenção legal:** Falta arquivo descritor de licença (`LICENSE`).

## 6. Resumo factual
O projeto consiste em um espaço de trabalho configurado sob orquestração de scripts bash e um arquivo `Makefile`. Ele é agrupado em subdiretórios funcionais servindo para inicialização e bootstrap com Ansible+Stow, controle dinâmico com arquivos Terraform organizados em módulos, governança detalhada para execução assistida de inteligência artificial (MCP) e rotinas em texto plano para acompanhamento via linhas de comando diárias. Existe implementação visível de processos preventivos (Shift-Left), mas existem áreas descentralizadas ou redundantes passíveis de consolidação.