# ADR 0004: Padronização e Limitação de Artefatos Opacos (Ticket 3.4)

## 1. Contexto
Durante a auditoria de processos primários do workspace de engenharia na arquitetura do setup, identificou-se que o repositório possuía e se baseava em artefatos de "caixa-preta" (artefatos opacos) ao rodar o comando principal de provisionamento da máquina (ex: `backup-setup.tar.gz`).

Esses artefatos estavam sendo descompactados indiscriminadamente na `/home/` via *Ansible*, burlando as diretivas de transparecia de "Infraestrutura como Código" ou até mesmo os espelhamentos controlados de dotfiles nativos através do uso formal com GNU Stow.

## 2. Decisão Técnica
Para garantir estrita reprodutibilidade, segurança e adoção por terceiros de forma confiável (sem injetar estado de terceiros de forma desconhecida), determina-se formalmente as seguintes premissas:

1. **Expurgo Pessoal do Setup-Base:** O provisionamento base do Ansible não admitirá na `roles/tasks` de configuração universal manipulações de compactados (`.tar`, `.zip`, `.gz`) que injetem dezenas de instâncias no disco local sem que essas cópias também não obedeçam diretamente as especificações em `state:` explícitos do instalador.
2. **Priorização de `dotfiles/` Tracking Git:** Toda necessidade customizada (atalhos, aliases, configurações de editores) DEVE repousar abertamente dentro do diretório `/dotfiles/` em texto limpo.
3. **Imutabilidade Visual:** Caso seja estritamente necessário usar referências engessadas (ex: binários customizados de repositórios particulares), ou a sua descompressão deve ocorrer usando módulos Ansible oficiais de forma versionada (como `unarchive` referenciando `remote_src: yes` através de URL de releases oficiais do GitHub), ou estes resquícios devem ser eliminados de repasses públicos.

## 3. Consequências e Mudanças Operacionais
1. O setup final não empurrará o arquivo `ansible/files/backup-setup.tar.gz` e qualquer tentativa posterior semelhante será bloqueada. Toda base e configurações de VS Code (`settings.json`) ou bash passarão e serão referenciadas unicamente através do espelhamento explícito contido e aberto pelo GNU Stow na pasta `/dotfiles`.
2. Essa arquitetura obriga o versionamento linha por linha de perfis Zsh, permitindo aos mantenedores fazerem audit e *reverts* se algo quebrar uma nova VM provida.
3. Evita que senhas armazenadas por descuidos em caches `.tar` passem ocultamente sob o nariz do `.pre-commit`.
