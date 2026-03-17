# Personal Dev Workspace & Platform Engineering (Cloud & MLOps)

Bem-vindo ao meu centro de comando. Este repositório centraliza toda a automação, infraestrutura e fluxos de desenvolvimento da minha máquina local até a nuvem (AWS/OVH). O objetivo aqui é aplicar os conceitos de **Platform Engineering, Infraestrutura como Código (IaC)** e **Automação de SO (Ansible e Bash)** para garantir que qualquer ambiente de trabalho seja idempotente, recriável e seguro.

---

## [ ARQUITETURA ] Visão Geral

Este repositório está subdividido nas seguintes disciplinas lógicas:

- **Automação de Máquina Local** (Ansible / Shell): Provisiona ferramentas, pacotes do SO, e injeta configurações.
- **Dotfiles & Symlinks** (GNU Stow): Controle unificado dos arquivos de configuração como `.zshrc`, `.gitconfig` e configurações do VS Code (`settings.json`, extensões).
- **Módulos de Infraestrutura** (Terraform): Modelos de código base e projetos práticos sobre AWS, provisionados via estado remoto e controlados por pipelines.
- **Governança de Agentes** (Prompting & IA): Diretrizes robustas e guardrails para IAs atuarem como devs no repositório.

Na raiz do repositório, garantimos a **Segurança Shift-Left**. Nenhum arquivo que possua hardcoded secrets ou lintings quebrados passa pelo framework `pre-commit` local que trava os _pushes_ indevidos.

---

## [ ENTRYPOINT ] Primeiros Passos

### 1. Bootstraping (Máquina Virgem)
Se você estiver numa máquina recém re-formatada baseada em Debian/Ubuntu, o script `setup-machine.sh` fará a injeção inicial estrita do gerenciador:
```bash
./scripts/setup-machine.sh
```

### 2. A Mágica (Configuração de Ferramentas)
Com o Ansible em mãos, não instale pacotes isolados com `apt` ou `snap`. Invoque a configuração via `make`:
```bash
make setup-workstation
```
Isso instalará nativamente VS Code, Docker, utilitários do Kubernetes, linters, linguagens e todas as dependências em suas devidas versões homologadas no `local-setup.yml`.

### 3. Dotfiles e Configurações Pessoais
Com as ferramentas instaladas, a gestão do Zsh, Bash e Editor são propagadas (symlinks) pra raiz do seu repositório:
```bash
cd dotfiles
stow zsh
stow git
stow vscode
```

---

## [ DEV & CLOUD ] Rotinas de Deploy

A infraestrutura contida em `templates` ou implementada em `infra` sempre carrega recursos fragmentados e isolados. Sempre confie no Makefile na hora de invocar os comandos Terraform:

```bash
# Entrar no diretório desejado (Ex: infra/teste-python)
# Executar a formatação universal exigida pelo CI/CD:
make format

# Subir a infraestrutura
make apply
```

_*Nota: Você precisará definir variáveis sensíveis via `.env` explícito ou ter o `aws-cli` configurado com suas credenciais. Leia a documentação em cada template específico antes do apply._

---

## [ CHECKLISTS ] Operações Diárias
No diretório `playbooks/`, documentamos o estado mental do mantenedor. Lá você encontra passos desde um checklist de início de dia até protocolos de resiliência e validação antes da entrega. Leia os `.md` sempre que necessário se situar nas macro-tarefas.
