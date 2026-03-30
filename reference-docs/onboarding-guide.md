# Guia de Onboarding — Workspace DevOps

Preparação e validação do `dev-workspace` em uma máquina nova ou limpa, até o estado **pronto para operação**.

---

## 1. Pré-requisitos Mínimos

| Requisito | Detalhe |
|---|---|
| **Sistema operacional** | Ubuntu 22.04+ ou Debian 12 |
| **Acesso administrativo** | Usuário com permissão de `sudo` ou senha em mãos |
| **Rede** | Acesso a `github.com`, `docker.com`, `astral.sh`, `ollama.com` e `apt.releases.hashicorp.com` |
| **SSH** | Chave `~/.ssh/id_ed25519` configurada e autorizada no GitHub |

---

## 2. Fluxo de Onboarding

```bash
git clone git@github.com:<usuario>/dev-workspace.git ~/labs/dev-workspace
cd ~/labs/dev-workspace
make help
make bootstrap
make doctor
make lint
make morning
````

---

## 3. Resultado Esperado

Ao final do fluxo:

* workspace clonado no caminho correto;
* workstation provisionada;
* toolchain essencial acessível;
* hooks locais ativos;
* validação do ambiente concluída;
* rotina operacional iniciada sem erro de contexto.

---

## 4. Regra de Uso do `make`

* Em `~/labs/dev-workspace`, use o `make` do workspace.
* Em um projeto, use o `make` do projeto.
* Fora disso, não execute `make <target>` sem contexto.

| Diretório                        | Uso esperado                                                      |
| -------------------------------- | ----------------------------------------------------------------- |
| `~/labs/dev-workspace`           | `make bootstrap`, `make doctor`, `make morning`, `make adopt ...` |
| `~/labs/projetos/meu-projeto`    | `make lint`, `make test`, `make dev`                              |
| Diretório sem `Makefile` do alvo | Entrar no repositório correto antes de executar `make`            |

---

## 5. Critérios de Aceite

A máquina pode ser considerada **pronta para operação** quando:

* `make bootstrap` conclui sem quebra estrutural;
* `make doctor` não reporta falha em dependências essenciais;
* `make lint` executa a partir da raiz correta;
* `make morning` roda sem erro de contexto;
* o fluxo pode ser repetido sem ajuste manual fora do padrão.

---

## 6. Falhas Comuns

### SSH falha no clone

```bash
ssh-add -l
ssh -T git@github.com
```

### Runtime ausente no ASDF

```bash
make asdf-install
make doctor
```

### Comando executado fora do clone

```bash
cd ~/labs/dev-workspace
make help
```

---

## 7. Estado Alvo

O onboarding está concluído quando o ambiente está validado, a rotina diária funciona e o operador consegue usar o workspace sem depender de conhecimento implícito.

```
