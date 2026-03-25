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

## Instanciação de Operação (Makefile)

O `Makefile` orquestra e encapsula a complexidade do repositório como entrypoint primário. Para fluidez, este ecossistema injeta nativamente o alias `morning` no shell do desenvolvedor para facilitar a chamada do scanner interativo principal.

```bash
make setup         # Provisionamento declarativo via Ansible (Instala a toolchain Base: ASDF, Docker V2, UV, Ollama, Lazygit)
make morning       # Telemetria matinal (Auditoria paramétrica de tokens Cloud, detecção de caches zumbis em disco do Docker)
make lint          # Invocação autônoma da esteira de Shift-Left Security (ShellCheck, TFLint, Yamllint, Gitleaks)
make test-sanity   # Auditoria estrita da sub-camada (Verifica Daemons PID e conectividades críticas)
make help          # Enumeração catalogada de alvos operacionais e bindings isolados
```

## Diretrizes de Integridade Computacional

1. **Shift-Left Autoritário:** Operações impõem regras de `pre-commit` globais. Violação (exposição de secrets ou sintaxe Shell com falha) travará e bloqueará a subida do push e a submissão ao versionamento, salvaguardando a imagem de nuvem.
2. **Idempotência Compulsória:** É mandatório o desenvolvimento de rotinas Bash (`.sh`) e playbooks condicionais a testes de estado prévios (State Check), sendo vetado comandos reativos imperativos ou re-criações destrutivas de configurações alheias.
3. **Governança de IA Nível Root:** Qualquer ferramenta baseada em modelos de linguagem (Claude, ChatGPT, extensões de IDE) que for instanciada neste diretório está obrigada a ler e assinalar incondicionalmente o **`GEMINI.md`** primeiramente. Isso restringe o prompt natural do modelo obrigando-o a seguir a política técnica de tom de engenheiro adotando as três Personas nativas de orquestração local (Orchy, DevidLops, Revy).

---
**Nota para Aplicações Autônomas:** Para atuar na escrita de código neste repositório, leia primeiro o `GEMINI.md` para instruções de contexto global do Kernel da plataforma e em sequência o `AGENTS.md` para peculiaridades deste pacote.
