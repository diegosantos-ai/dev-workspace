# Checklist Oficial: Adoção do Workspace para Terceiros

Se você planeja submeter a sua equipe (ou clone para uso pessoal) sob a arquitetura padronizada neste repositório, garanta que os seguintes critérios restritivos sejam adotados antes do Deployment inicial.

## 1. Topologia de Fork
Se deseja isolamento total de ciclo de vida e estado (ex: senhas guardadas e `.terraform` states do seu próprio ambiente AWS), efetue um Fork **Hard Disconnected**. 
A gestão de pacotes `Ansible` não fará merge automático entre as necessidades da nossa base com seu Fork caso ele fique atrasado, então preveja manutenções de `bash` e `yaml` regulares do seu lado.

## 2. Requerimentos Mandatórios (Hardware/Software)
- **Linux/Debian-Ubuntu Kernel:** Testado primariamente no Ubuntu (Jammy/Noble).
- **Bash & ZSH:** A raiz dos scripts invoca `#!/usr/bin/env bash` restritamente. A instalação forçará o ecossistema `Zsh` e `GNU Stow` como default user level.
- **Git Global User:** Tenha seu nome e e-mail provisionados; o `make env-check` abortará operações até a conta local ser configurada.
- **Node & Python Local:** Versões controladas via `asdf` e agentes CLI Python injetados por `pipx` obrigatoriamente. Permissões globais de `pip install` são vetadas em host.

## 3. O Fluxo Oficial de Onboarding 
Um ambiente "zerado" deve alcançar conectividade através dos três estágios:

1. **Pre-flight:** Clone este repositório no subnível home que preferir (`~/Workspace/` e não root de sistema `/:`).
2. **Bootstrap:** 
   ```bash
   make setup
   ```
   *Aguarde a finalização. Senhas sudo serão pedidas para alocar pacotes na raiz do host.*
3. **Validação:** 
   ```bash
   make test-sanity
   ```
   *Se o console retornar "TUDO VERDE", a máquina está considerada pronta para clonar sub-projetos e atuar com Terraform & Agentes.*

## 4. Substituição de Credentials & Dotfiles
Caso não queira adotar os `.dotfiles` originais do mantenedor original:
- Limpe o conteúdo das pastas `dotfiles/bash/`, `dotfiles/zsh/` ou altere a arvore mapeada no Ansible.
- Substitua a configuração de extensão do VS Code na entrada local para refletir apenas os linters essenciais (`GitHub.copilot`, `HashiCorp.terraform`).
