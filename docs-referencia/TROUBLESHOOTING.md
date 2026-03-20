# Troubleshooting: Mapeamento de Falhas e Procedimentos de Correção

Este documento cataloga falhas sistêmicas comuns atreladas ao fluxo operacional deste workspace e seus métodos objetivos de mitigação antes de debugar os scripts individualmente.

## 1. Falhas de Ansible no Bootstap Inicial (`make setup`)

**Sintoma:** O Playbook falha ao instalar pacotes Snap (`community.general.snap`) em ambientes não aderentes como WSL2.
**Causa:** Ausência do `systemd` e `snapd` operacionais no ecossistema WSL.
**Mitigação:** O sistema está instruído a ignorar silenciosamente as falhas dos softwares instaláveis via Snap (como kubectl, code). Você deve providenciar esses executáveis pela via oficial do seu próprio OS primário (Windows/Mac) e os expor para dentro do terminal virtual.

**Sintoma:** Permissão Negada (Permission Denied) para `~/.config/Code/User`.
**Causa:** Interferência de execução `sudo` que acabou sendo herdada na camada de diretório do User sem ser chowned de volta.
**Mitigação:**
```bash
sudo chown -R $USER:$USER ~/.config/Code/User
make setup
```

## 2. Falhas no Linking de Arquivos pelo GNU Stow

**Sintoma:** Ao rodar Stow, ele avisa "Conflict: arquivo existente existe no destino".
**Causa:** O pacote dotfiles não consegue sobrescrever configurações que já existem na máquina e que não eram symlinks originários do stow.
**Mitigação:** Utilize a flag `--adopt` (tática que já operamos estruturalmente). Adoção captura o arquivo conflituoso e o joga no git local, de forma que o status git mostre a diferença de paridade da máquina para o repositório.

## 3. Falhas Operacionais: `pre-commit` e Checkers

**Sintoma:** Commit enguiçado na fase Gitleaks reclamando de secrets, mas você não considera o bloco um secret real.
**Causa:** Padrões heurísticos do Gitleaks para detectar entropia de strings interpretaram um fragmento de token inominado.
**Mitigação:** Declare falso positivo estritamente e com justificativa. Adicione a linha `.gitleaksignore` localmente (se for aplicável a projeto secundário) ou adicione `gitleaks:allow` comentada na linha. Exemplo em bash: `API_TEST="mocked-string" # gitleaks:allow`

## 4. Falhas de Ambiente Docker/Containerização

**Sintoma:** Retorno `Docker Daemon offline ou sem permissão de acesso ao socket` no `daily-check`.
**Causa:** Seu usuário logado não está contido no grupo `docker`, exigindo privilégios para executar chamadas CLI e causando a queda persistente das infraestruturas conteinerizadas do IaC e do cockpit.
**Mitigação:**
```bash
sudo usermod -aG docker $USER
newgrp docker
```

---
> Para instabilidades sistêmicas persistentes, consulte a seção do `ADR` e verifique a premissa de idempotência. Não edite scripts base para forçar o sucesso sem antes repassar pela camada de análise (Make lint).
