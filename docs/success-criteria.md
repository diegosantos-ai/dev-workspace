# Critérios de Sucesso — Validação de Workstation

Este documento define o estado mínimo esperado de uma workstation provisionada pelo `dev-workspace`. Cada item deve ser verificável diretamente no terminal, sem dependência de memória operacional.

---

## 1. Bootstrap

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| `make bootstrap` executa sem falha crítica | `make bootstrap` | Saída sem `ERROR` ou `FAILED` bloqueantes |
| Ansible disponível após bootstrap | `ansible --version` | Versão impressa sem erro |
| Pre-commit instalado e configurado | `pre-commit --version` | Versão impressa; hooks presentes em `.git/hooks/` |

---

## 2. Controle de Versão e Acesso Remoto

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| Git instalado e configurado | `git --version` | Versão >= 2.x |
| Identidade Git definida | `git config --global user.name` | Nome do usuário retornado |
| SSH operacional | `ssh -T git@github.com` | Mensagem de autenticação bem-sucedida |
| Chave SSH presente | `ls ~/.ssh/id_ed25519.pub` | Arquivo existe |

---

## 3. Shell e Ambiente de Usuário

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| Zsh é o shell padrão | `echo $SHELL` | `/usr/bin/zsh` ou equivalente |
| Dotfiles provisionados via Stow | `ls -la ~/ \| grep '\->'` | Symlinks apontando para `~/labs/dev-workspace/dotfiles/` |
| Variáveis de ambiente carregadas | `env \| grep -E 'PATH\|EDITOR'` | PATH contém paths dos runtimes; EDITOR definido |

---

## 4. Docker e Compose

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| Docker instalado | `docker --version` | Versão impressa sem erro |
| Daemon Docker ativo | `docker info` | Saída sem erro de conexão |
| Usuário no grupo docker | `groups $USER` | `docker` listado |
| Docker Compose disponível | `docker compose version` | Versão >= 2.x |

---

## 5. Infra Core

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| Containers core sobem sem conflito | `make infra-up` | Todos os serviços com status `running` |
| Rede `dev-workspace-net` criada | `docker network ls \| grep dev-workspace-net` | Rede listada |
| Postgres responde | `docker exec postgres pg_isready` | `accepting connections` |
| Redis responde | `docker exec redis redis-cli ping` | `PONG` |

---

## 6. Runtimes

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| Python disponível | `python3 --version` | Versão definida em `.tool-versions` |
| Node disponível | `node --version` | Versão definida em `.tool-versions` |
| uv disponível | `uv --version` | Versão impressa sem erro |
| ASDF ativo | `asdf --version` | Versão impressa sem erro |

---

## 7. Linting e Segurança

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| `make lint` executa sem bloqueio | `make lint` | Saída sem violações de segurança ou estilo |
| gitleaks configurado | `pre-commit run gitleaks --all-files` | Nenhum secret detectado |
| shellcheck disponível | `shellcheck --version` | Versão impressa sem erro |

---

## 8. Rotina Operacional

| Critério | Comando de verificação | Resultado esperado |
|---|---|---|
| `make doctor` identifica dependências | `make doctor` | Nenhum item marcado como `[FAIL]` |
| `make morning` executa | `make morning` | Rotina matinal iniciada; worklog do dia aberto |
| Diretório de worklogs existe | `ls rotina-devops/worklog/daily/` | Diretório acessível |
| VS Code disponível no PATH | `which code` | Caminho retornado |

---

## Validação Consolidada

Rodar o conjunto abaixo após `make bootstrap` deve ser suficiente para confirmar o estado completo da máquina:

```bash
make doctor
make lint
make infra-up
make morning
```

Se todos os quatro comandos concluem sem erros bloqueantes, a workstation está operacional e em conformidade com o padrão do `dev-workspace`.
