# Mapa do Fluxo de Setup Atual (Ticket 3.1)

Este documento registra a realidade exata de como a automação da máquina opera do começo ao fim atualmente. Ele não reflete intenções ideais, mas relata a trilha observável acionada durante a etapa de configuração de um ambiente novo provido neste repositório.

## 1. Etapa de Bootstrap (Abertura Básica)
O indivíduo precisa, no mínimo absoluto, deter em sua máquina os recursos de clonagem padrão (Git, Github permissões), privilégio e a interface de orquestração:
1. Clonagem manual do código e transição explícita pelo terminal (`cd dev-workspace`).
2. Requisição do construtor: o usuário digita na raiz o atalho `make setup`.
3. O `make` desvia a instrução inicial chamando interativamente o arquivo `ansible/scripts/setup-machine.sh`.
4. Este *script bash* assume o papel protetor exigindo credenciais: confere se é usuário não-root e demanda elevação explícita via `sudo` para iniciar. 
5. Constatada a distribuição (*if Debian*), ele varre o banco local atualizando os índices do pacote apt (`apt-get update`) e força a existência da linguagem Ansible (usando subproduto PPA e common-properties).

## 2. Etapa de Setup (Motor Principal)
Tendo as dependências providas dinamicamente pelo shell inicial, o motor de enforcement atua.
6. O bash entra na macro-instrução e evoca a execução local de `ansible-playbook ansible/local-setup.yml`.
7. **Baixa de Cargas APT:** Ele realiza um `present` sem versão travada em cerca de 25 ferramentas utilitárias (`curl`, `bat`, `stow`, `git`, libs python etc).
8. **Configurações Pessoais Assintomáticas:** Uma *task* paralela do GNU Stow espelha sob formatação silenciosa (`--adopt -v -d`) seus diretórios zsh e vscode pra debaixo da base `.config` e da `$HOME`.
9. **Operação Oculta:** Traciona a extração ativa do artefato manual local `backup-setup.tar.gz` substituindo arquivos sem indexação ou controle sob o host alvo não rastreado no git.
10. **Ajuste de Shell:** Realiza o vínculo contínuo reescrevendo o shell default global para invocar a variante compilada interativa (`/bin/zsh`) finalizando clonagens tolerando erros dos repositórios "Zsh Autosuggestions e Highlighting".
11. **Retorno do Log:** O terminal finaliza com notificação limpa visual (sem indicação interativa ou log persistente formal da execução total nativa da aplicação ansible).

## 3. Pós-Setup (Etapas Silenciosas e Manuais)
A etapa pós-setup consiste estritamente em dependências órfãs ou tarefas de responsabilidade passiva assumidas pelo condutor da automação atual.
12. A máquina não levanta processos cruciais imediatamente (ex: a liberação de usuários em grupos complexos de docker, apesar de baixar o daemon de sua carga). 
13. Extensões locais e variáveis de Nuvem não são solicitadas por nenhum prompt terminal, confiando puramente que o usuário entende que deverá fazer preenchimento manual dos fluxos locais ou seguir a reexecução na documentação baseada.
14. A ativação dos *hooks Git* (`pre-commit install`) não figura em repasse pelo setup, ficando subentendido que o usuário roda isoladamente pelo make na hora que realizar suas atuações nos blocos IaC.

## 4. Auditoria (Validação Dissociada)
Este momento atua **desacoplado** do motor nativo de infraestrutura de bootstrap Ansible não confirmando ativamente em modo "Continuous Assessment".
15. Quando inseguro ou demandado pela gestão da "checklist matinal", a máquina chama explícito o alvo `make env-check` (ou seu semelhante mais verboso via pasta, o report em `sanidade-ambiente`). 
16. Este comando invoca bashers que escrutinam a árvore nativamente reportando à interface de tela (e em logs isolados de rotina `reports/`), pontuando presenças OK ou FAIL na CLI de programas essenciais. O setup foi bem-sucedido quando cruzado independentemente com este verificador.