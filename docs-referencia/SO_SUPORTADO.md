# Política de Sistema Operacional Suportado (Ticket 2.3)

Este documento dita explicitamente a premissa de homologação do workspace. Ele declara qual sistema subjacente tem suporte pleno deste repositório e previne atritos de usuários em plataformas desconhecidas que busquem adoção através do provisionamento base (Ansible).

## 1. Nível 1: Plataforma Oficial Suportada ("Tier 1")
O suporte nativo e primário baseia-se unicamente em distribuições do ramo **Debian / GNU Linux**.
O bootstrap principal de automatização depende da variável `ansible_facts['os_family'] == "Debian"`. Além de gerenciar pacotes ativamente através do utilitário `apt` ou `apt-get` globalmente hardcoded no shell-script.

**Distribuições Homologadas (Ideais):**
- **Ubuntu:** (>= 22.04 LTS)
- **Debian Core:** (>= 11 Bullseye)
- **Pop!_OS / Linux Mint:** (Derivadas parcialmente suportadas. Testadas até a interface do interpretador apt).

> **Garantia:** Usuários neste ecossistema rodam os scripts e atingem a convergência local com previsibilidade plena, validando com a saída explícita do `env-audit.sh`.

## 2. Nível 2: Limitações Conhecidas & Plataformas Restritas ("Tier 2")
### Mac OSX / Homebrew (Darwin)
- **Estado atual:** **Não Suportado Automatiamente**.
- A automação em `Make setup` irá **falhar**. O repasse de apt no Makefile e o playbook não têm abstrações polimórficas (ainda) para acionar `brew`. 
- **Workaround manual:** Clonar repo, gerenciar os dotfiles localmente com stow e consumir a seção limpa dos módulos `/templates` ignorando toda a raiz do Ansible.

### Windows (WSL 2)
- **Estado atual:** **Parcialmente Suportado**.
- O projeto de automação roda livremente no WSL caso a distribuição provisionada lá pelo usuário Windows seja um Ubuntu moderno.
- Limitações envolvem integrações com plugins do Docker Daemon local interligados de forma heterogênea no host (ex: WSL demandando integrações fora da via SSH clássica ou permissões `systemd`).

### Red Hat / CentOS / Fedora / Arch Linux
- **Estado atual:** **Não Suportado Automatiamente**.
- Da mesma forma que usuários Apple, gerenciadores pacman ou dnf e pacotes ausentes causarão o colapso nas *tasks* primordiais do Ansible, barrando o repositório como inatingível e não reprodutível.

## 3. Considerações de Ambiente
A arquitetura do workspace hoje não tem a pretensão de ampla portabilidade agnóstica na instalação das bibliotecas adjacentes ("setup-machine"). Assegura a reprodutibilidade desde que restrito a uma máquina provisionada puramente usando contornos Debian.