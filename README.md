# Platform Engineering Workspace

Este repositório centraliza padrões arquiteturais de ambiente local, de infraestrutura em nuvem e documentações estruturantes para uso contínuo em operações de engenharia de plataforma.

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white) ![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?style=for-the-badge&logo=docker&logoColor=white) ![Pre-commit](https://img.shields.io/badge/Pre--commit-Quality-2F363D?style=for-the-badge) ![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

## Objetivo
Fornecer um ambiente reproduzível, modular e idempotente para engenharia de operações. A estrutura integra automação de workstation (OS configuration, dotfiles) e gerenciamento de templates IaC para orquestração. 

## Componentes Funcionais
O repositório está construído e segmentado nas seguintes frentes operacionais:

- `ansible/` & `dotfiles/`: Automação estado-declarativa de estação de trabalho, provisionamento de pacotes base, e gestão de dotfiles baseada na árvore do GNU Stow.
- `templates/`: Manifestos e esqueletos de provisionamento base para Terraform com isolamento severo entre módulos lógicos dinâmicos e injeção de estado por ambiente (envs).
- `gestao-centralizada-agents/`: Governança e System Prompting que definem limites de restrições operacionais para uso de IAs com Server MCP acoplado ao Qdrant e N8N.
- `sanidade-ambiente/` & `rotina-devops/`: Políticas e scripts de validação, checklist operacionais, e coleta contínua para manutenção de integridade local.
- `docs-referencia/`: Base de conhecimento contendo a Política de Versionamento, Política de Secrets e Architecture Decision Records (ADRs).

## Controle de Operações (Makefile)

O `Makefile` atua como entrypoint primário para toda a operação.

```bash
make help          # Lista os comandos estruturais do workspace (Setup, Qualidade e Operação)
make setup         # Pipeline de provisionamento nativo (System bootstrap, Ansible e dotfiles)
make lint          # Inicia esteira local de validação (Pre-commit)
make test-sanity   # Aciona a auditoria sistêmica de binários, docker socket e permissões 
```

## Diretrizes e Validações Impostas

1. **Shift-Left Security:** O repositório emprega `pre-commit`, contendo detecção imposta de secrets e lintings automáticos para Shell, YAML e Terraform. Nenhuma chave não criptografada pode persistir no repositório local.
2. **Idempotência Garantida:** Todo script em Bash (.sh) ou playbook local (.yml) exige verificação prévia de estado em vez de forçar reconstruções destrutivas.
3. **Padrão de Qualidade:** Rejeição de arquivos binários e extrações não auditáveis como tar/zips nas automações de setup.

---
Para operar este repositório de forma automatizada com LLMs ou extensões assistivas (Copilot), valide estritamente o `AGENTS.md` e suas definições de restrição de escopo.
