# Assessment de Setup e Ambiente

## 1. Fluxo atual de instalação
O fluxo real de setup identificado baseia-se em uma execução orquestrada nativamente pelo host, mesclando bash e Ansible de maneira sequencial:
1. O setup é iniciado por um comando de entrada no terminal.
2. Um *shell script* de bootstrap é acionado e verifica privilégios administrativos, escalando via `sudo` se necessário, armazenando o usuário original.
3. Este mesmo script inspeciona a distribuição do sistema operacional e, caso detecte famílias compatíveis (arquivos base `/etc/debian_version`), injeta um PPA e instala o pacote secundário `ansible` via gerenciamento de pacotes (`apt-get`). Caso o SO não passe nesse check estrito da família, a execução aborta ativamente.
4. Tendo o motor subjacente presente, o próprio bash repassa as tarefas seguintes para o *playbook* de provisionamento principal do Ansible (`ansible/local-setup.yml`). 
5. O Ansible se conectará localmente (`localhost`) escalando privilégios, onde varrerá e instalará dezenas de `apt` libs base (Git, tmux, curl etc.), configurará diretórios e linkará dotfiles nativos através do programa utilitário GNU Stow. 
6. Uma etapa fará a extração literal de um arquivo compactado local (`backup-setup.tar.gz`) dentro do diretório `/home` do usuário, finalizando com pulls e clonagens não checadas estritamente de plúgins do Zsh e `asdf`.
7. O script emite mensagem simples de conclusão e volta a sessão ao usuário.

## 2. Pontos de entrada
Os principais gatilhos iniciais previstos hoje são:
- Comando de orquestração via raiz: `make setup` (direciona para execução em script bash adjacente).
- Execução nominal direta pelo arquivo: `bash ansible/scripts/setup-machine.sh`.
- Alternativa manual secundária inferida: Início não assistido disparando puramente via sintaxe de host local `ansible-playbook ansible/local-setup.yml` direto na CLI.

## 3. Dependências e pré-requisitos
O que está claramente definido/forçado em código:
- **Interpretador Shell e Make:** Sistema deve possuir `bash` nativo, assim como a ferramenta `make` engatilhando as receitas pelo terminal atual.
- **Ecossistema OS Restrito:** Somente será viabilizado integralmente em Sistemas Operacionais com distribuição GNU/Linux pertencente ou derivada de ecossistema `Debian/Ubuntu`. Há verificação nativa (arquivos locais e facts do play `ansible_facts['os_family'] == "Debian"`).
- **Acesso à Internet:** Tráfego irrestrito liberado para clonar repositórios GitHub, repasses APT, chaves GPG e utilitários Snap.
- **Credenciais Locais:** Execução exige o consentimento explícito e senha via `sudo`. 

O que não está definido e aparenta assunção de existências:
- **Compatibilidade cruzada:** Não existe definição de versões impeditivas ou mínimas de um SO Debian compatível (ex. Ubuntu 22 vs Ubuntu 24).
- **Conflito de arquivos:** Não estabelece ou limpa diretórios pessoais, pressupondo uma pasta `$HOME` estéril para o desatamento de `stow` e dos clones `oh-my-zsh`. 

## 4. Pós-instalação e validação
**Não existe fluxo acoplado automatizado de validação no pós-instalação.**
Uma vez percorrida a sequência do playbook no terminal via setup, a automação encerra o eco com "Setup completed successfully", independentemente do quão operacionais terminaram os submódulos que possuem a diretiva "ignore_errors: yes" ativada nas dependências GIT (como a instalação do ASDF ou Plúgins). 
O fluxo de cobertura pós real e a validação precisam ser deliberadamente evocados num segundo momento com `make env-check` ou via `make audit` sob a árvore da pasta `sanidade-ambiente`. Portanto, o resultado do setup não atesta, ativamente, usabilidade orgânica em seu final.

## 5. Sanidade de ambiente
Os *checks* documentados para validar o dia a dia existem (ex: `daily-check.sh` e `env-audit.sh`), eles validam hoje que:
- **A CLI atende globalmente:** Realiza aferições via `command -v` que confere somente se o binário executável está injetado na trilha de variável do PATH local (ex, validando `docker`, `python3`, `git`, `make`, `bash`).
- **Respostas de permissão no Docker Daemon:** Avança um pouco ao inquirir sobre a comunicação ativa através de `docker info`, confirmando se o daemon está respondendo requisições reais fora da bolha de apenas checar se a CLI existe.
- **Contexto de Work-Tree:** Valida se a sessão atual em que a sanidade foi evocada é um diretório pertencente ao escopo de arvíore Git base, emitindo falhas (`git rev-parse`).
- **Omissão em Falhas Secundárias:** Possui discernimento categorizado, pontuando falhas toleráveis na integridade como advertências (Warnings) para ferramentas como `pipx` e o plugin obsoleto do docker-compose ao envés de erros de bloqueio total (`FAIL`).
- **Geração de Registro:** Dispara artefatos logáveis guardando datas para pasta de referências em `reports/`. 

## 6. Lacunas operacionais
Alguns impeditivos concretos bloqueiam a previsibilidade desse setup para equipes ou máquinas neutras não manipuladas por seu criador:
- **Dependência de Estado Passado Obscuro:** O *playbook* principal faz referência pontual ao tráfego do arquivo comprimido `backup-setup.tar.gz`. Como o conteúdo que sofre `unarchive` injeta sub-arquivos na localidade `.config`, este repasse gera dependência oculta de conteúdo estritamente pessoal, inseguro, ou desconhecido com potencial de atritar sessões base em máquinas de colegas de equipe. E não documentado.
- **Falta de Lock Versions:** Quase todos os pacotes nativos operam `state: present` sob gerenciadores base (`apt`), o que fatalmente levará a atualizações surpresas divergentes dependendo do mês no qual ocorra a execução do setup num host final - comprometendo a reprodutibilidade. Vários scripts `git clone` em `head` também absorvem ramificações vulneráveis a mudanças imprevisíveis no repositório de origem das ferramentas como `zsh-autosuggestions`.
- **Rigor Mono-OS:** Abandona sumariamente quem não usa variantes de OS providas do *kernel Debian*.

## 7. Resumo
O projeto hoje parece: **parcialmente instalável e dependente de conhecimentos implícitos**. O repositório centraliza comandos e atende às prioridades em instâncias que espelham de forma idêntica as decisões de distribuição raiz (Debian base), porém a amarração de OS engessada, as injeções de arquivos compactados e falta de auditoria atrelada limitam a reprodução previsível da receita com exatidão em zero atrito para uma máquina nova de terceiros sem antes passar por longas refatorações de adaptação.