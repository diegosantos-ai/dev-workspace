# Evidências do Estado Atual

## 1. Pontos de entrada reais do projeto

*   **Evidência encontrada:** Arquivo `Makefile` na raiz contendo targets como `help`, `setup`, `lint`, `env-check`, `audit` e comandos da família de log diário (`day-start`, `log`, `day-close`).
*   **Onde foi encontrada:** `Makefile` e chamadas listadas em sua estrutura.
*   **O que isso permite afirmar:** O fluxo de entrada oficial estabelecido utiliza automação baseada em `make`. Há evidência formal de uso, apontando para delegação de comandos em scripts `.sh`. Depende do GNU Make e de contexto implícito na variável `DEV_WORKSPACE`.

## 2. Setup e instalação

*   **Evidência encontrada:** Uso do script `/ansible/scripts/setup-machine.sh` chamado via `make setup` para supostamente alavancar o playbook do Ansible. Existe um playbook em `/ansible/local-setup.yml` configurando hosts de modo local (`connection: local`).
*   **Onde foi encontrada:** `Makefile` (target `setup`), `/ansible/scripts/setup-machine.sh` e `/ansible/local-setup.yml`.
*   **O que isso permite afirmar:** Existe uma automação declarativa configurada (playbook Ansible) que estabelece pacotes base de sistema (ex: `curl`, `git`, `stow`, `jq`). O processo está explicitamente acoplado à família Debian/Ubuntu em validações condicionais (`when: ansible_facts['os_family'] == "Debian"`).
*   **O que ainda não permite afirmar:** O playbook lista pacotes locais via `apt` (como `qemu-kvm`, `bat`, `stow`) e há instâncias mapeadas de configuração de snap, porém não há comprovação do estado final em um cenário fora de Ubuntu local ou distribuições divergentes.

## 3. Sanidade e validação

*   **Evidência encontrada:** Scripts estruturados em `/sanidade-ambiente/scripts/`: `daily-check.sh` e `env-audit.sh`.
*   **Onde foi encontrada:** Diretório `/sanidade-ambiente/scripts/`.
*   **O que isso permite afirmar:**
    *   **Valida presença de binários:** Os scripts verificam via `command -v` a presença de comandos em `PATH` (ex: docker, pre-commit, ssh).
    *   **Valida operação real:** Há validação do socket de daemon funcional via `docker info` ao invés de atestar apenas presença do binário e checagem de permissão do worker daemon.
    *   **Valida conectividade/integração:** Teste de autenticação remota através de `ssh -T git@github.com`.
    *   **Valida configuração local:** O script examina chaves de uso central (`git config user.name/email`) e se o diretório faz parte de repositório estruturado.
*   **O que ainda não permite afirmar:** Não é possível confirmar, exclusivamente pelo repositório, o agendamento de verificações, a auditoria periódica em segundo plano ocorrendo ou a persistência das respostas de logs gerados nas "reports/".

## 4. Dependências, versões e contrato do ambiente

*   **Evidência encontrada:** Variável de dicionário de pacotes listada em `ansible/local-setup.yml` e o clone forçado de versão arbitrária via tool asdf (`version: v0.14.0`).
*   **Onde foi encontrada:** `/ansible/local-setup.yml`.
*   **O que isso permite afirmar:** Existe versionamento parcial pontual (ex: asdf), mas há ausência de um formato manifest como `Gemfile`, `Pipfile` ou similar definindo as faixas de versão precisas (ex: requisição em `python3-pip`, `shellcheck`, sem versão pinada).
*   **O que ainda não permite afirmar:** Se o setup não apresenta flutuações de versão (drift) durante novos bootstrappings ao longo do tempo. O contrato do ambiente é altamente implícito, recaindo em versões _latest/floating_ fornecidas pelo cache `apt`.

## 5. Variáveis de ambiente e secrets

*   **Evidência encontrada:** Integração contínua mapeada via plugin gitleaks ou verificação de chaves nos pre-commits apontados em conversas previas do contexto.
*   **Onde foi encontrada:** `Makefile` target `lint` referenciando hooks de pré inclusão, política de credenciais indireta mapeada via documento.
*   **O que isso permite afirmar:** Não existe um padrão central explícito via arquivo `.env.example` local em nível de root indicando o estado ou lista de secrets requeridas pelo repositório como um todo. Existem ocorrências singulares de `terraform.tfvars.example` nas templates `/templates/terraform-aws-base/envs/dev/`.
*   **O que ainda não permite afirmar:** O fluxo não esclarece de onde virá e através de qual backend secreto o preenchimento dessas variáveis se dará antes da injeção no ambiente.

## 6. Dotfiles e personalização

*   **Evidência encontrada:** Existência dos diretórios em `/dotfiles/` contendo segmentações explicitas de `/bash`, `/git`, `/vscode` e `/zsh`.
*   **Onde foi encontrada:** Diretório `/dotfiles/` e playbook chamando `stow --adopt -v -t <target>`.
*   **O que isso permite afirmar:** A gestão de ambiente da workstation é orquestrada centralmente pelo Stow mediante linkagens simbólicas. A estrutura denota padronização clara sob o escopo do usuário.
*   **O que ainda não permite afirmar:** Dado que arquivos dotfile embutem com frequência lógicas intrínsecas ao dev original, arquivos ali presentes portam risco real de conflito caso o adotante utilize convenções radicalmente diferentes não amparadas sobre Oh-My-Zsh ou atalhos similares pré carregados.

## 7. Makefile, scripts e automação operacional

*   **Evidência encontrada:** A interface oficial exposta reside no arquivo `Makefile`.
*   **Onde foi encontrada:** `Makefile` no diretório-raiz.
*   **O que isso permite afirmar:** Todos os targets operam como _wrappers_ de chamadas a scripts Bash internos nos diretórios do sub-sistema (ex: `/sanidade-ambiente/scripts/` e `/rotina-devops/scripts/`).
*   **O que ainda não permite afirmar:** A ausência de falhas caso a variável `$(DEV_WORKSPACE)` falhe em resolver caminhos absolutos coerentes em shells não padronizados.

## 8. Terraform e templates

*   **Evidência encontrada:** Árvore de uso de Terraform segmentada em `modules` isolados de estado, e diretório `envs` listando instaciamento (`dev` etc).
*   **Onde foi encontrada:** `/templates/terraform-aws-base/` e `/templates/terraform-ovh-base/`.
*   **O que isso permite afirmar:** Existe prova visível de modelo que distingue as noções de provedor/ambiente versus recurso lógico (`compute`, `network`, `security`).
*   **O que ainda não permite afirmar:** Nenhuma evidência de execução técnica real existe nesses provedores, uma vez que eles permanecem ancorados em formato de template vazio base e apenas espelham sintaxe declarativa. Nenhuma prova de plano de implantação foi retida no repositório.

## 9. Documentação existente

*   **Evidência encontrada:** Documentações como `README.md`, diretórios em `docs-referencia/`, manuais e "playbooooks".
*   **Onde foi encontrada:** Raiz, `/docs-referencia/adr/`, `/playbooks/`.
*   **O que isso permite afirmar:** Há registro formal histórico usando o formato fixo de ADR (Architecture Decision Records, ex: `0001` e `0002`). A documentação pontual mapeia a fronteira entre scripts isolados e o playbook central.
*   **O que ainda não permite afirmar:** Se os referidos tutoriais práticos cobrem o troubleshooting integral das dependências do OS quando a máquina falha ao bootar o container do Docker, sendo parte majoritária baseada em diretrizes de intenção de comportamento invés do log bruto do erro.

## 10. Governança de agents

*   **Evidência encontrada:** Arquivos `AGENTS.md`, diretório `gestao-centralizada-agents/agents-personas/`, e configuração para um MCP Server local.
*   **Onde foi encontrada:** Raiz (`AGENTS.md`) e `gestao-centralizada-agents/`.
*   **O que isso permite afirmar:** Há estabelecimento documental explícito (contrato) detalhando perfis, proibições e restrições. Há provável _enforcement_ técnico por um MCP TypeScript contido em `/skills-mcp/` sob o Make target `test-skills`.
*   **O que ainda não permite afirmar:** Como não podemos rodar e depurar a chamada em real-time a partir deste snapshot avaliativo, a constatação de imposição inquebrável (enforcement de uso local do servidor da porta em lugar da automação llm vanilla) baseia-se unicamente na presença de código, devendo depender do compliance do LLM submetido ao prompt do arquivo.

## 11. Inconsistências observáveis

*   **Acoplamento em templates vs uso real:** A configuração dos diretórios no caminho `/gestao-centralizada-agents/infra/agents-cockpit/docker-compose.yml` convive no mesmo repositório que a pasta de templates `terraform-aws-base`, apontando para a duplicidade de usar IaC genérico para deploy enquanto os perfis de agente sobem localmente via docker-compose solto.
*   **Configuração de infra indireta:** Como a documentação de repositório alega uso como plataforma corporativa ou estendida a terceiros, depender largamente de shell-scripts acoplados com `ansible_facts['os_family'] == "Debian"` expõe uma fronteira inconsistente em compatibilidade com fluxos baseados em Darwin (macOS) e RPM/RHEL.
*   **Opacidade na sanidade:** A pasta de sanidade cita `reports/` vazia sem um processo automatizado e cíclico (.gitkeep) confirmando se são _cronjobs_ em segundo plano ou execuções locais apenas ativadas via interface estrita `make`.

## 12. Síntese factual

*   **O que existe com evidência clara:** Estruturas modulares de setup para OS Ubuntu locais usando Ansible declarativo, verificação funcional em nível de socket de sistemas (Docker, SSH), separação em branches para Terraform entre módulos virtuais não-instanciados e ambientes isolados, dotfiles unificáveis via GNU Stow, Make interface isolando scripts brutos.
*   **O que existe parcialmente:** Definições de versionamento de ferramentas (flutuantes e não fixados rigorosamente dependentes do repositório Linux), documentação técnica mesclada a processos imperativos do time e infraestrutura MCP de agentes de IA parcialmente configurada sob testes de typescript local.
*   **O que não está comprovado:** Integrações ativas ou estado comutado de deploy na nuvem. Agendamento remoto ou contínuo CI atuando sob pipeline real que deponha sob o _Shift-left_ imposto, para os logs em pre-commit.
*   **O que impediria a adoção imediata por terceiros:** Restrição do playbook aos facts Debian/Ubuntu com dependência em configurações explícitas do Oh-My-Zsh ou preferências do dotfiles, e a dependência subjetiva atrelada à automação de variáveis do MCP server não totalmente documentado em caso de falha de conexão na stack node/NPM.
