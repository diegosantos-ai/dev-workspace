# Fluxo Oficial de Automação: Separação de Responsabilidades (Ticket 3.2)

O fluxo de inserção neste repositório será fatiado de forma arquitetada para prevenir ambiguidade ou falhas falsamente validadas. A estrutura linear engaja 4 tempos obrigatórios para quem quer obter controle sobre a máquina local.

## Fase 1: BOOTSTRAP (Ponto Inicial Mínimo)
**Propósito:** Injetar as premissas mínimas no OS nativo da máquina *bare-metal* crua para que compreenda as abstrações de segundo estágio.
* **Autoridade:** Imperativo Shell (`bash`).
* **Responsabilidade:** Checar a existência nativa do gerenciador secundário adotado (Ansible), adicionar o instalador do Ansible viabilizando suas instâncias em distribuições de Debian se exigido, demandando credenciais administrativas.
* **Duração:** Segundos a um par de Minutos.
* **Gatilho Único:** Acionar script em chamadas curtas da interface de make base.

## Fase 2: SETUP (Motor da Infraestrutura)
**Propósito:** Provisionar estado e bibliotecas utilitárias via IaC Idempotente para o Host que agora detém a motorização capaz. 
* **Autoridade:** Orquestração declarativa YAML (`Ansible-playbook`).
* **Responsabilidade:** Varrer a base garantindo espelhamento em links simbólicos sem interrupção humana das ferramentas puras da raiz e ideologias contidas (`stow`). Pede e faz os updates de pacotes exigidos do OS ou asdf sem estragos.
* **Duração:** Mediana. 

## Fase 3: PÓS-SETUP & ADOÇÃO MÍNIMA (Ação Direcionada)
**Propósito:** Interações de governança humana inevitáveis requeridas na segurança das sessões. Assentar o arcabouço final dinâmico que o setup cego omitiu.
* **Autoridade:** O colaborador.
* **Responsabilidade:** Ingerir as variáveis sensíveis aos espelhos do `.env.example`, levantar sessões estáticas do Docker para orquestração da I.A base, realizar login nos conectores de nuvem (como `aws sso login` ou pass) e injetar explicitamente o `.pre-commit install` na sub-hierarquia inicial do seu Git local para fortificação.

## Fase 4: AUDITORIA E VALIDAÇÃO (Provisão e Retorno Limpo)
**Propósito:** Encerrar o bypass formal do ambiente atestando sucesso não de execução do script 1, nem do 2, mas da operação vital real perante a sanidade.
* **Autoridade:** Verificadores (`make env-check` e bash).
* **Responsabilidade:** Submeter ativamente a máquina e seus daemons aos scripts rigorosos confirmando de antemão: Path, Runtimes de motor virtual (Python, Go, Terraforma) e respostas dos canais Docker em "verde". Fazer fail do ambiente caso componentes da etapa 2 e da etapa 3 não se integrem à contento com sucesso operando na malha de rede e socket local.