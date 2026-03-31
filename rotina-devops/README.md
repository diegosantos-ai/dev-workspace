# rotina-devops

## Propósito

Módulo de rastreamento de atividades diárias e consolidação semanal de entregas. Opera exclusivamente via terminal com arquivos Markdown em texto plano. Resolve o problema de perda de contexto operacional ao longo do dia: trocas de tarefa frequentes que não ficam registradas em lugar nenhum.

## Quando Usar

- No início do dia, para registrar o foco e abrir o worklog.
- Ao longo do dia, para registrar eventos, conclusões e bloqueios.
- No fim do expediente, para consolidar o fechamento diário.
- Às sextas-feiras, para gerar o relatório semanal.

## Dependências

- Zsh ou Bash (scripts são POSIX-compatíveis).
- VS Code com `code` no PATH (para abertura do worklog no editor).
- Diretório `rotina-devops/worklog/daily/` existente.

## Estrutura

```text
rotina-devops/
├── scripts/
│   ├── worklog-start.sh    # Abre o dia e define o plano
│   ├── worklog-add.sh      # Registra evento com timestamp
│   ├── worklog-close.sh    # Fechamento interativo do dia
│   └── worklog-weekly.sh   # Consolida relatório semanal
└── worklog/
    ├── daily/              # Arquivos YYYY-MM-DD.md
    ├── weekly/             # Arquivos de ciclo semanal
    ├── projects.yaml       # Dicionário de projetos e tags
    └── templates/          # Modelos imutáveis de Markdown
```

## Relação com o Core

Módulo independente. Não depende do `infra-core/` nem de containers. Os scripts são acionados via targets do `Makefile` raiz. Armazenamento em texto plano — sem banco de dados, sem dependências externas.

## Entrypoint Local

```bash
make day-start    # Inicia o dia (cria worklog e abre no editor)
make log          # Registra um evento no worklog corrente
make day-close    # Encerra o dia com resumo interativo
make week-close   # Gera relatório da semana
```

Modo avançado (evento em linha única):
```bash
make log ARGS="lab-docker execucao 'Criação do docker-compose' 'Containers no ar' alto"
```
