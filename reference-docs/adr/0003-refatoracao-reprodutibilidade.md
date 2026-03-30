# ADR 0003: Refatoração para Reprodutibilidade Universal (100% Portable)

## 1. Contexto e Problema
O repositório `dev-workspace` foi inicialmente construído com premissas de caminhos locais (hardcoded absolute paths, ex: `/home/diegosantos/docs/dev-workspace`) e dependências do ambiente do autor. Isso quebra o principal pilar do projeto: **permitir que qualquer engenheiro baixe e aplique o workspace em sua própria máquina de imediato, sem atrito.**

O usuário relatou confusão e dificuldade no uso iterativo. O processo `make setup` falha em diretórios ou usuários não previstos.

## 2. Decisão Arquitetural (Estado Alvo)
A partir desta branch (`chore/reprodutibilidade`), toda automação, shell script, Terraform ou configuração deverá ser reescrita para adotar **Caminhos Relativos (Relative Paths)** ou **Descoberta Dinâmica de Diretório** (`$(pwd)`, `dirname "$0"`).

A abordagem de refatoração será modular:
1. Nenhuma dependência de localização de pasta.
2. Entrypoints intuitivos a partir do clone.

## 3. Plano de Fases (Fases da Reprodutibilidade)

### FASE 1: O Ponto de Partida (Core & Bootstrap)
- **Alvo:** `Makefile` e `ansible/scripts/setup-machine.sh`.
- **Ação:** Mudar variável `DEV_WORKSPACE` do Makefile para utilizar localização dinâmica. Atualizar script de bootstrap para funcionar não importando de onde é chamado.

### FASE 2: Automação e Pacotes (Idempotência Pessoal)
- **Alvo:** `ansible/local-setup.yml` e `dotfiles/`.
- **Ação:** Varrer por caminhos ou usuários hardcoded (`diegosantos`). Garantir que o `$USER` e o `$HOME` target sejam universalmente inferidos pelo Ansible para criar symlinks em qualquer desktop.

### FASE 3: Scripts de Operação (Rotina e Sanidade)
- **Alvo:** `rotina-devops/` e `sanidade-ambiente/`.
- **Ação:** Remover caminhos absolutos usados em agendadores e chamadas diretas. Implementar resolução de path relativa dentro de cada script shell para garantir que rodem idependentemente de onde o repositório foi clonado.

### FASE 4: Gestão Centralizada de Agentes (O Motor)
- **Alvo:** `gestao-centralizada-agents/`.
- **Ação:** Revisar as skills MCP, caminhos do Qdrant e Docker Compose para injetar o caminho da pasta via variável de ambiente `.env` gerada dinamicamente, abandonando os binds fixos.

### FASE 5: Teste de Fogo e UX (Documentação)
- **Alvo:** `README.md` e test-drive final.
- **Ação:** Atualizar o README com a exata instrução de 2 linhas (`git clone ... && make setup`). Executar o clone numa máquina diferente (ou em outro path da sua máquina principal) e homologar o fluxo completo de auto-setup.

## 4. Status
- [x] Proposto (Em análise)
- [ ] Fase 1: Ponto de Partida Completa
- [ ] Fase 2: Automação Idempotente Completa
- [ ] Fase 3: Scripts Operacionais Completos
- [ ] Fase 4: Gestão de Agentes Completa
- [ ] Fase 5: Validação Final Completa
