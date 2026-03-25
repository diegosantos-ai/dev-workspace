# Guia de Onboarding — Workspace DevOps

Este documento define o estado inicial necessário e o fluxo de recuperação para instanciar o ambiente em um notebook novo/limpo seguindo a Baseline de Março/2026.

## 1. Pré-requisitos Mínimos

| Requisito | Detalhe |
|---|---|
| **SO** | Ubuntu 22.04+ ou Debian 12 (Bookworm) |
| **Acesso** | Usuário com permissão de `sudo` sem senha (recomendado) ou senha em mãos |
| **Rede** | Acesso irrestrito a `github.com`, `docker.com`, `astral.sh`, `ollama.com` e `apt.releases.hashicorp.com` |
| **SSH** | Chave `~/.ssh/id_ed25519` configurada e autorizada no GitHub |

## 2. Fluxo Canônico (7 Passos)

1. `git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace`
2. `cd ~/labs/dev-workspace`
3. `make help`
4. `make setup-workstation`
5. `make doctor`
6. `make lint`
7. `make morning`

## 3. Diagnóstico de Falhas Prováveis

### [E-01] Timeout no Download do Docker Desktop
- **Sintoma:** Ansible trava por mais de 5 minutos na task "Baixar Docker Desktop".
- **Causa:** Instabilidade na rede ou servidor da Docker.
- **Correção:** Tente `curl -L` manual. Se persistir, o setup pode ser concluído sem Docker e instalado posteriormente via `make setup-workstation`.

### [E-02] SSH "Permission Denied" no Clone
- **Sintoma:** Falha imediata ao tentar clonar.
- **Causa:** Chave SSH não carregada ou não autorizada no GitHub.
- **Correção:** Garanta que `ssh-add -l` lista sua chave. Teste com `ssh -T git@github.com`.

### [E-03] Conflito de Versão ASDF
- **Sintoma:** `make doctor` aponta falha em `node` ou `python3`.
- **Causa:** Plugins adicionados mas versões não baixadas/setadas.
- **Correção:** Execute `make asdf-install` manualmente dentro da raiz do repositório.

### [E-04] Aliases não Funcionam
- **Sintoma:** Comando `morning` não encontrado.
- **Causa:** Shell não recarregado após o setup ou conflito com dotfiles manuais.
- **Correção:** Execute `source ~/.zshrc`. Se persistir, verifique se o arquivo é um link para o dotfile do repositório.

## 4. Comandos de Recuperação

```bash
# Reinstalar runtimes (Node/Python)
make asdf-install

# Forçar ativação de hooks de segurança
pre-commit install

# Validar estado das ferramentas
make doctor
```
