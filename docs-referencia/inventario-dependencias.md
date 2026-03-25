# Inventário de Dependências do Workspace (Ticket 2.1)

Este documento estabelece o mapeamento técnico das dependências necessárias para a operação plena do repositório `dev-workspace`. Está dividido entre dependências críticas obrigatórias e recomendadas/opcionais.

## 1. Core Operacional (Obrigatórias)
Sem estas dependências, as subrotinas não iniciam ou processos de base quebram fatalmente.

* **Bash**: Interpretador essencial para rodar scripts locais e bootstrap (`>= 4.x`).
* **Make**: Utilitário de automação central usado como Single-Entry-Point do projeto no terminal.
* **Git**: Essencial para atualizar o framework local, clonar submódulos de shell, plugins Zsh e realizar as tratativas estáticas locais.
* **Ansible**: Engine obrigatória que realiza o enforcement local e gerencia as camadas da máquina (`ansible-playbook`).

## 2. Dependências de Governança e Servidores (Recomendadas)
Essenciais caso o usuário adote o pipeline de validação *Shift-Left*, orquestração da I.A e IaC.

* **Docker (Daemon + CLI)**: Necessário para testar provisionamentos e levantar os componentes de N8n ou Vetores em `/gestao-centralizada-agents/infra`.
* **Docker Compose (Plugin v2)**: Suporte para topologias multi-containers.
* **Python 3 (`>= 3.9`) & `pipx`**: Necessário para manter scripts utilitários e encapsulamento isolado de pacotes (`pre-commit`, motores MCP).
* **Pre-commit**: Ferramenta acoplada no `.pre-commit-config.yaml` garantindo segurança passiva.
* **Terraform**: CLI binário para operar os templates IaC providos em `/templates/`.
* **Node.js & npm**: Ferramentas necessárias no servidor TypeScript do ambiente MCP de IAs mantidos nativamente na pasta `skills-mcp/`.

## 3. Qualidade Estática de Código (Secundárias/Integradas)
* **Shellcheck**: Linter ativado por hook e usado no Action remoto.
* **Gitleaks**: Varredor mandatório de impedimento contra chaves soltas e tokens em *commit time*.
* **TFlint**: Linter para sintaxe dos módulos Terraform.
* **Yamllint**: Validador de esquemas de automações GitHub e playbooks.

## 4. Estilo de Vida e Personalização de Ambiente (Cosméticas e Eficiência)
Instaladas através de dotfiles e playbooks, não travam arquitetura mas dão coerência ao workspace planejado.

* **GNU Stow**: Administra os links unificados sobre `.config`, shell e IDE.
* **Zsh & Oh-My-Zsh**: Ambientes configurados em terminal para aliases de eficiência profunda.
* **ASDF**: Gestor poliglota de versionamento de utilitários locais (mantém Ruby, Go, Terraform e NodeJS independentes caso precise escalar a configuração modular).
* Úteis como uso interativo CLI: `fzf`, `ripgrep`, `jq`, `tmux`, `bat` e `gh`.

---
*Nota: A ausência de dependências obrigatórias impede imediatamente procedimentos de "Daily Check" e execução nominal de setups primordiais da documentação base de onboarding deste workspace.*
