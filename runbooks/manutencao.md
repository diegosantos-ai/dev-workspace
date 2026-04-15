# Checklist Oficial: Rotina de Manutenção Contínua

Este workspace não é imutável em suas dependências subjacentes. A integridade contínua do maquinário e de suas engrenagens provisionadas (binários, configurações e IaC cache) exige aplicação do ciclo exposto a seguir.

## 1. Janela Funcional (Ação Diária)
Executar toda manhã ou a cada inicialização de contexto:
```bash
make env-check
```
* **Objetivo:** Auditar acessibilidade dos binários (Python, Docker, Terraform) e sockets. Certificar pre-commit injetado e testar a resolução de DNS do ambiente simulado.

## 2. Janela de Manutenção Rápida (Ação Semanal)
Executada via orquestrador para atualizar toolchains:
```bash
make update-tools
```
* **Objetivo Restrito:** Atualizar as ferramentas gerenciadas pelo workspace em canais controlados: extensoes do VS Code, CLIs globais em `npm`, ambientes `pipx`, plugins e runtimes declarados em `asdf` e o binario do VS Code quando o canal instalado suportar automacao local. Nao executa upgrade amplo do sistema operacional.

Para inspecionar pendencias antes de aplicar alteracoes:
```bash
make update-report
```

Para sincronizar o repositorio e a toolchain na mesma rotina, use:
```bash
make update
```

## 3. Janela de Refatoração Estrutural (Ação Mensal/Pós-Mudança)
Executada após modificação de `.dotfiles` ou após troca/reset de máquina:
```bash
make setup
make test-sanity
```
* **Objetivo Restrito:** Reimpor o playbook do Ansible para garantir paridade. A flag `--adopt` do Stow vai esmagar atalhos divergentes no ambiente para obedecer à árvore rastreada do repositório.
* **Saída Esperada:** O setup terminar sem quebras. `test-sanity` consolidando os artefatos funcionais e logando a telemetria do socket, da SSH public key com o Github e do path do interpretador.

## 4. Limpeza Severa (Quando necessário)
Quando o cache de extensões ou state locks inviabilizar provisionamentos:
- **Terraform:** Navegue no diretório do projeto `env/` ofensor e limpe estritamente `.terraform/` (ignorar subida de arquivo local opaco para cloud).
- **VSCode:** Delete extensões zumbis `rm -rf ~/.vscode/extensions/*` e reinicie `make setup` para buscar pacotes declarados.
