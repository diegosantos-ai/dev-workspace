# Política de Versionamento de Ferramentas (Ticket 2.2)

Este documento define a estratégia primária para gerenciar as versões das ferramentas que mantêm este workspace. O objetivo é proibir "instalações surpresas", evitar divergência entre as versões usadas por diferentes máquinas ou em diferentes períodos do tempo, e estipular o comportamento de tolerância no setup.

## 1. Ferramentas Essenciais do Gerenciador de Pacotes do Sistema (Local)

Ferramentas instaladas nativamente (via `apt` ou `snap`) representam um risco para provisionamentos perfeitos já que dependem dos repositórios *upstream*.
Como base, o Ansible assumirá o estado `state: present` somente para bibliotecas utilitárias puras e sem grande risco de quebra de contrato (`curl`, `git`, `htop`, `bat`, `jq`).

Para **Runtimes e Compiladores** subjacentes providos por sistema (como `python3`), consideraremos a versão mantida na distribuição LTS suportada como **padrão satisfatório** (ex: `Python 3.10+` nativo do Ubuntu 22.04). Suas versões exatas não comporão arquivos severos de lock, permitindo que a resolução nativa da distribuição mantenha a sanidade das chaves e pacotes.

## 2. Abstração Universal via ASDF

Ferramentas agnósticas de Infraestrutura, Nuvem e SDKs que podem impactar diretamente a confiabilidade do código entregue pelos componentes devem ser rigorosamente abstraídas do instalador global do Sistema Operacional.

**Diretriz Base:**
Ferramentas polimórficas ou versionadas do time adotarão estritamente o `asdf` (`.tool-versions`) como gerenciador central:
* Terraform
* CLI da AWS (se não delegadas ao apt local)
* Node.js / npm
* Go / Ruby e outras linguagens

**Arquivo Central:** O mapeamento exato destas versões DEVE constar num arquivo `.tool-versions` posicionado na **Raiz do Repositório**. Isso garantirá que quem acessar qualquer subdiretório do projeto esteja usando a mesma CLI exata ditada pela arquitetura.

## 3. Gestão e Versionamento de Python (Agentes e Linting)

Devido às restrições do sistema operacional moderno (`PEP 668` e limitação de pacotes instalados globais no `pip`), ferramentas dependentes ou bibliotecas Python de uso como CLI (ex: `pre-commit`, IAs, N8n Nodes locais) serão versionadas usando:

* Gestor **`pipx`**: Cria e invoca ambientes vituais puramente isolados (isolating packages).
* Atualização destas ferramentas ocorrerá sob gerência de um playbook dedicado da máquina sem misturar as bibliotecas com o `/usr/bin/python`.

## 4. Estratégia de Upgrade
Nunca assumiremos atualizações "flutuantes sem consentimento". O repositório prescreverá janelas táticas de mudança via *Pull Requests* / Modificações manuais para atualizar instâncias:
- Atualizar `.tool-versions`
- Modificar o `local-setup.yml` ou scripts de *Ansible*.
- Somente com a bateria de execução *env-audit* limpa, este repasse entrará para adoção universal.
