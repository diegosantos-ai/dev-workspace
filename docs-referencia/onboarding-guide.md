# Guia de Onboarding — Workspace DevOps

Este documento define o estado inicial necessário e o fluxo de recuperação para instanciar o ambiente em um notebook novo/limpo seguindo a Baseline de Março/2026.

## 1. Pré-requisitos Mínimos

| Requisito | Detalhe |
|---|---|
| **SO** | Ubuntu 22.04+ ou Debian 12 (Bookworm) |
| **Acesso** | Usuário com permissão de `sudo` sem senha (recomendado) ou senha em mãos |
| **Rede** | Acesso irrestrito a `github.com`, `docker.com`, `astral.sh`, `ollama.com` e `apt.releases.hashicorp.com` |
| **SSH** | Chave `~/.ssh/id_ed25519` configurada e autorizada no GitHub |

## 2. Fluxo Canônico

1. `git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace`
2. `cd ~/labs/dev-workspace`
3. `make help`
4. `make bootstrap`
5. `make doctor`
6. `make lint`
7. `make morning`

Notas operacionais:
- `make bootstrap` é o entrypoint canônico do onboarding.
- `make setup-workstation` reprovisiona apenas a workstation.
- `make setup` existe somente como alias compatível de `make setup-workstation`.

## 3. Regra Operacional do `make`

Regra curta:

- Dentro de `~/labs/dev-workspace`, use o `make` do workspace.
- Dentro de um projeto, use o `make` do projeto.
- Fora disso, não use `make <target>` puro.

Leitura rápida por pasta:

| Pasta atual | `make` permitido | Finalidade |
|---|---|---|
| `~/labs/dev-workspace` | `make bootstrap`, `make doctor`, `make morning`, `make adopt ...` | Preparar a máquina e operar a plataforma |
| `~/labs/projetos/meu-projeto` | `make lint`, `make test`, `make dev` | Operar o projeto em si |
| `~/home/diego` ou pasta sem `Makefile` do alvo | Não usar `make <target>` puro | Entre no repositório correto primeiro |

Sequência mental esperada:

1. Quer preparar a máquina ou usar a plataforma: `cd ~/labs/dev-workspace`
2. Quer trabalhar em um projeto: `cd ~/labs/projetos/meu-projeto`
3. Quer usar `make`: use o `make` da pasta onde você acabou de entrar

Se precisar disparar o `Makefile` do workspace fora dele, use explicitamente:

```bash
make -C ~/labs/dev-workspace doctor
make -C ~/labs/dev-workspace morning
```

## 4. Diagnóstico de Falhas Prováveis

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

### [E-04] Comando executado fora do clone
- **Sintoma:** `make help`, `make doctor` ou `make lint` respondem algo inesperado, ou `make` não encontra target.
- **Causa:** O comando foi disparado fora da raiz do clone correto, ou existe vestígio operacional antigo no `$HOME`.
- **Correção:** Entre no diretório do clone real (`cd ~/labs/dev-workspace`) e valide se não há `~/Makefile`, alias de shell antigo ou symlink legado apontando para outro checkout.

## 5. Topologia de Fork e Customização

Caso clone este repositório para uso em equipe ou personalização profunda:
- **Isolamento:** Se deseja gerenciar seus próprios estados de Terraform (S3/GCS), efetue um fork e desvincule o upstream para evitar conflitos de backend.
- **Dotfiles Próprios:** Você pode limpar `dotfiles/` e substituir pelos seus. O Ansible usará o `stow` para mapeá-los se seguirem a estrutura de pastas do sistema.
- **Plugins Zsh:** O setup garante o básico. Adições extras devem ser feitas via `~/.zshrc` local para manter a baseline limpa.

## 6. Comandos de Recuperação

```bash
# Reinstalar runtimes (Node/Python)
make asdf-install

# Forçar ativação de hooks de segurança
pre-commit install

# Validar estado das ferramentas
make doctor
```
