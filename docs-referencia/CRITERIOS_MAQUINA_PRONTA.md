# Critérios de "Máquina Pronta" (Ticket 3.5)

Para superar o status ingênuo de "setup finalizado com sucesso" ou "binário existe", o repositório estabelece definições rigorosas, práticas e operacionais que atestam a plena condição de infraestrutura sob a qual a máquina alvo possui conformidade ativa em seu cenário de mercado ("Production-Ready Workspace").

Não dependemos de retornos nulos sem acoplamentos da esteira; uma máquina é dada como **pronta** apenas se obedecer compulsoriamente os critérios abaixos verificáveis (passando a ser um estado não falso-positivo de sucesso).

## 1. Integridade Fundamental e CLI
O ambiente provê os utilitários bases e garante resolução nativa no PATH sem quebra de *symlinks*:
- [ ] O `bash` e o utilitário orquestrador `make` resolvem comandos universais do OS a partir de qualquer subdiretório raiz do usuário alvo na máquina.
- [ ] O utilitário Git invoca nativamente perfis SSH associados a `user.name` e `user.email` da organização previstos.
- [ ] A pasta base da aplicação submetida ao Stow contém representações coerentes visadas (`~/.config/Code`, `~/.zshrc`); não devendo existir quebras de redirecionamento ou permissões nas hierarquias raiz.

## 2. Aderência Operacional Contínua (Docker)
Ferramental primário que rege a esteira e os agentes operantes locais, precisando possuir validação funcional não apenas "visível":
- [ ] Daemon do Docker possui resolução ativa em *socket* e atende processos e pingos do estado operacional.
- [ ] Execuções que invocam o grupo não retornam "Permission Denied". O usuário regular escalado consegue prover e dar `pull` de pacotes da nuvem ou subir contêineres e imagens (ex, subindo as instâncias N8n subjacentes do `/gestao-centralizada-agents`).

## 3. Integridade Shift-Left (CI/CD Local Preditivo)
O pilar forte deste repositório impede propagação de vulnerabilidade. A máquina não está "pronta" até garantir restrição de falha humana nativa.
- [ ] Motor executivo pipx ou global aponta para sucesso de dependências python (`python3`, `pre-commit`, yaml rules).
- [ ] O comando de auto-verificação (`pre-commit install`) foi executado ativamente como rotina na pasta principal, interceptando _commits_ nativos e disparando varreduras de `tflint`, `gitleaks` e checagens sobre chaves omitidas, confirmando uma tentativa funcional.

## 4. Nuvem e Provisionamento Seguro (Variáveis Sensíveis)
Este requisito ditará a operação autônoma provendo os recursos da esteira Ansible/Terraform com integridade das variáveis essenciais.
- [ ] Possui definição ativa (no Bash, ou gerenciador de secrets via Zsh Plugins/Profiles) de credenciais exigidas de nuvem na AWS (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` ou tokens MCP associados).
- [ ] Exibição contínua sem quebras logísticas de diretórios base `/envs/dev` do Terraform e seus respectivos binários na versão predeterminada exigida (ex: por via local ou injetadas via ASDF rodando com permissões).

---
**Validação Operacional Definitiva:**
A verdadeira prontidão de "Machine Ready" só se prova cruzando a conclusão manual das variáveis da **Etapa 4** contra um resultado impecavelmente verde sem *Warnings* impeditivos provido pelo comando ativador `make env-check` ou repassando sobre aprovação limpa total sob `make audit` validada nas premissas exigentes do sistema Debian.