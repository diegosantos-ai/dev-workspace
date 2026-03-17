# 🚀 Workspace DevOps & Platform Engineering

[![CI - Lint & Security](https://github.com/diegosantos-ai/dev-workspace/actions/workflows/ci-lint-sec.yml/badge.svg)](https://github.com/diegosantos-ai/dev-workspace/actions/workflows/ci-lint-sec.yml)
[![CI - Terraform Plan](https://github.com/diegosantos-ai/dev-workspace/actions/workflows/terraform-plan.yml/badge.svg)](https://github.com/diegosantos-ai/dev-workspace/actions/workflows/terraform-plan.yml)

Bem-vindo ao centro nervoso de infraestrutura, automação e configurações (dotfiles) orientadas ao mais alto padrão de mercado. Este repositório atua como um produto contínuo de Engenharia de Plataforma.

## 🏗️ Arquitetura do Workspace

```mermaid
graph TD;
    A[Workspace DevOps] --> B(📁 Automação de Máquina);
    A --> C(📁 Infraestrutura as Code - IaC);
    A --> D(📁 Documentação & Playbooks);

    B --> B1(Ansible Playbooks)
    B --> B2(GNU Stow Dotfiles)
    
    C --> C1(AWS Premium Templates)
    C --> C2(OVH Cloud)
    C1 --> C1a(envs/dev - envs/prod)
    C1 --> C1b(modules/compute, network...)

    D --> D1(ADRs - Decisões Arquiteturais)
    D --> D2(Playbooks de Operação)
```

## 🛠️ Capacidades Principais

- **🛡️ Shift-Left Security:** Nenhum segredo ou configuração ruim passa localmente graças a stack estrita de Hooks (`pre-commit`, `gitleaks`, `tflint`, `tfsec`, `shellcheck`).
- **♻️ Automação Idempotente:** O Setup de suas novas máquinas está garantido por **Ansible** via `make setup`.
- **☁️ IaC Desacoplada:** Código de Nuvem padronizado em Workspaces Isolados (`multi-ambiente`) garantindo 0 risco de explosão e reutilização máxima.

## 🚀 Como Iniciar (Nova Máquina)

Clone o repositório e rode o comando principal da nossa Plataforma:

```bash
make setup
```

## 📐 Padrões & Regras de Design

Antes de alterar o comportamento arquitetural do repositório, consulte nossos Registros de Decisão (ADRs) documentados em [`docs-referencia/adr`](docs-referencia/adr/).

---
**Gerenciado via GNU Make | Blindado por Pre-Commit | Versionado por GitHub Actions**
