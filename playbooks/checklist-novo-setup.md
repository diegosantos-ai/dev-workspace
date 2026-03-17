# Checklist: Setup Nova Máquina (DevOps)

## Fase 1: Base do Sistema e Segurança
- [ ] Atualização de pacotes do sistema (apt/dnf)
- [ ] Ferramentas utilitárias essenciais (`curl`, `wget`, `jq`, `unzip`, `htop`, `tmux`/`screen`)
- [ ] Configuração do Git (nome, email, alias, core.editor)
- [ ] Geração e configuração de chaves SSH (GitHub, GitLab, servidores externos)
- [ ] Exportação de Variáveis de Ambiente e credenciais sensíveis (TFE_TOKEN, PATs de acesso) no arquivo de profile (ex: `~/.bashrc` ou `~/.zshrc`)

## Fase 2: Terminal e Produtividade
- [ ] Instalar Zsh
- [ ] Framework de Shell (Oh My Zsh ou Starship)
- [ ] Plugins de produtividade (`zsh-autosuggestions`, `zsh-syntax-highlighting`)
- [ ] Copiar `.bashrc` ou `.zshrc` atual (alias, exports)

## Fase 3: Aplicativos GUI Essenciais
- [ ] **Docker Desktop** (para gerenciamento visual dos containers)
- [ ] **DBeaver** (para gerenciamento de banco de dados)
- [ ] **Termius** (antigo terminus - cliente SSH/SFTP)

## Fase 4: Core DevOps & Infra como Código
- [ ] Terraform (ou gerenciador de versão como `tfenv`)
- [ ] Provedores/CLI de Nuvem (OVH CLI, AWS CLI, etc.)
- [ ] kubectl
- [ ] K9s (interface terminal para Kubernetes)

## Fase 5: Linguagens e Desenvolvimento
- [ ] ASDF ou gerenciadores de versão dedicados (pyenv, nvm)
- [ ] Python, pip, docker-compose
- [ ] Node.js (caso necessário para scripts)

## Fase 6: IDE e Editores (VS Code)
- [ ] Instalar VS Code
- [ ] Restaurar arquivo `settings.json`
- [ ] Restaurar configurações do `mcp.json`
- [ ] Instalar extensões:
  - GitHub Copilot
  - HashiCorp Terraform
  - Docker
  - Python
  - Kubernetes

---

## 📦 Como Restaurar o Backup na Nova Máquina

1. Transfira o arquivo `backup-setup.tar.gz` (gerado na máquina antiga) para a pasta "Home" (`~/`) da sua nova máquina.
2. Abra o terminal na nova máquina e vá para a sua pasta Home:
   ```bash
   cd ~/
   ```
3. Extraia os arquivos do backup. Eles já vão cair exatamente nas pastas corretas (`~/.config/Code/User/...` e `~/docs/rotina-devops/...`):
   ```bash
   tar -xzvf backup-setup.tar.gz
   ```
4. Após isso, basta abrir o VS Code, e suas configurações e atalhos estarão restaurados, incluindo os prompts do `mcp.json`.
