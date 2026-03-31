# sanidade-ambiente

## Propósito

Módulo de validação do estado operacional do workspace. Verifica de forma sistemática se as ferramentas críticas, containers e configurações do ambiente estão funcionais antes do início do trabalho. Atua de forma passiva — reporta problemas, não os corrige.

## Quando Usar

- Toda manhã, via `make morning`, como parte da rotina de início do dia.
- Ao suspeitar de inconsistência no ambiente (ferramenta ausente, Docker parado, PATH corrompido).
- Em pipelines de CI local para garantir pré-condições antes de executar tasks.

## Dependências

- Bash (scripts POSIX-compatíveis).
- Docker daemon ativo para os checks de containers.
- Ferramentas base instaladas: `git`, `make`, `docker`, `python3`, `pipx`.

## Estrutura

```text
sanidade-ambiente/
├── scripts/
│   ├── daily-check.sh   # Verificação rápida diária (make morning)
│   └── env-audit.sh     # Varredura profunda de compliance
├── reports/             # Saída gerada pelos scripts de auditoria
└── templates/           # Formatos padronizados de relatório (MD, JSON)
```

## Níveis de Alerta

| Status | Significado |
|---|---|
| `[ OK ]` | Componente saudável e ativo |
| `[ WARN ]` | Item opcional ausente ou mal configurado — não bloqueia operação |
| `[ FAIL ]` | Falha bloqueante — requer correção antes de continuar |

## Relação com o Core

Módulo de apoio. Consome o estado do sistema sem alterar configurações. Acionado pelo `Makefile` raiz via `make morning` e `make doctor`. Não depende de containers do `infra-core/`, mas verifica se eles estão ativos.

## Entrypoint Local

```bash
make doctor       # Diagnóstico completo (equivale a daily-check.sh)
make morning      # Roda daily-check.sh embutido na rotina matinal

# Execução direta (para CI ou debug):
./sanidade-ambiente/scripts/daily-check.sh
```
