# Manifest: Limites, Fronteiras e Posicionamento

A clareza sobre o que este repositório **NÃO DEVE FAZER** é tão crucial quanto seu escopo de atuação. Este documento afasta expectativas infundadas e limita a entropia gerada por abstrações em IAs.

## 1. O que este projeto é (Posicionamento Oficial)
1. É um **Platform Engineering Workspace**: Um invólucro para padronizar o ferramental de máquina (Dotfiles, Ansible), gestão segura de segredos (Shift-left via pre-commit) e a via técnica oficial de comunicação e restrição de Agentes Autônomos (MCPs e System Prompting).
2. É um agregador e orquestrador via CLI (Makefile) que previne a síndrome da "planilha de comandos textuais perdidos".
3. É um provador local de "Idempotência". Todas as execuções de IaC e shell devem convergir no mesmo estado seguro não importa quantas vezes executadas.

## 2. O que este projeto NÃO É (Limitações Intencionais)
1. **Não é um Cluster Operacional Remoto:** Este repositório não hospeda carga de trabalho de aplicação de usuários em si. A arquitetura instanciará as ferramentas locais e gerenciará repositórios paralelos ou instanciará *IaC/Terraform* para datacenters remotos, mas não age como um *Runtime App Server* para sistemas alheios.
2. **Não tem Autonomia Destrutiva Silenciada:** Playbooks ou pipelines que contêm falhas cruciais não devem possuir supressão sistêmica (via `ignore_errors` sem justificativa).
3. **Não acomoda Sistemas Operacionais Tier 3:** Não provemos suporte explícito nativo para automatizar pacotes do zero no MacOS ou em distros Arch/Alpine de forma transparente no nível central (Tier 1 segue contido ao ecosistema Debian-family Linux). O uso no Tier 2 e Tier 3 é viável apenas via "Tradução Manual" ou bypass do OS-check, assumindo custo operacional por parte do usuário.

## 3. Fronteiras de Segurança
1. A ferramenta `gitleaks` atua em Hard Block. Se as heurísticas bloquearem, o commit para; não contorne as checagens com flags `.git/hooks` nulas.
2. Nenhuma API Key ou `.env` de production pode repousar fora de um gerenciador de pass/vault aprovado.
3. Repositórios clonados paralelamente por via deste repositório não herdarão o "state" do Terraform principal. O ambiente IaC providenciado mantém isolamento state-lock absoluto por `env`.
