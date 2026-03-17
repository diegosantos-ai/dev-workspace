# ADR 0001: Uso de Ansible e GNU Stow para Setup de Máquinas

## Status
Aceito

## Contexto
O setup do ambiente de trabalho local era executado por meio de um script Bash imperativo e grande (`setup-machine.sh`), o que dificultava testes parciais (idempotência) e o gerenciamento organizado dos `dotfiles`. Sempre que a máquina era resetada ou de um novo setup, o risco de sobrescrever pastas importantes com `cp` era alto, além de tornar a base de código complexa de manter.

## Decisão
Decidimos utilizar **Ansible** para provisionamento (gerenciamento de pacotes, PPAs e permissões) e o utilitário **GNU Stow** para versionamento e ligação via *symlinks* (link simbólico) da configuração de `dotfiles` (Ex: VS Code, repositórios nativos).

## Consequências
- **Positivas:** O setup torna-se completamente idempotente (pode rodar centenas de vezes de fomar segura). Alterar algo no dotfile local automaticamente reflete no repositório mantendo o controle de versão com 0 esforço.
- **Negativas:** Exige o conhecimento de sintaxe YAML (Ansible) e introduz Ansible e Stow como dependência dura de inicio.
