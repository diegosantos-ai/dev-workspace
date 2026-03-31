# Mapa Estrutural do Repositório (Platform Engineering)

## 1. Propósito do Repositório
O repositório é concebido como um Produto de Plataforma focado na automação de ambientes de desenvolvimento e produção. O sistema isola estado, aplica configuração de forma idempotente e integra práticas de Shift-Left Security. O objetivo operacional primário é fornecer infraestrutura como código (IaC), orquestração de containers globais e padronização contínua do ambiente local da máquina.

## 2. Visão dos Componentes

### 2.1. Núcleo (Core)
Elementos que estabelecem a fundação da operação do sistema e do ciclo de vida das máquinas e infraestrutura base.
- `Makefile`: Entrypoint operacional unificado. Encapsula comandos complexos da plataforma em atalhos rastreáveis e garante a abstração tática para o usuário.
- `ansible/`: Gerenciamento de estado, sistema operacional e instalação imperativa de dependências sistêmicas providas de forma idempotente.
- `dotfiles/`: Centralização das configurações em nível de usuário, espelhado localmente pelo sistema operacional via utilitários de gerenciamento de links simbólicos (ex: GNU Stow).
- `scripts/`: Automações de apoio estrutural, boot inicial e componentes utilitários validados por rotinas estritas de segurança (shellcheck).
- `runbooks/`: Guias operacionais e procedimentos táticos estabelecidos para manutenção de resiliência e resposta a incidentes no ambiente.
- `templates/`: Modelos arquiteturais base isolados (blueprints) consumidos e transformados na geração parametrizada de provisionamentos definitivos.

### 2.2. Apoio (Auxiliar)
Ativos estáticos de histórico e módulos restritos à validação do ambiente, sem executar mudanças de estado.
- `reference-docs/`: Central de documentação e contratos, mantendo o histórico de diretrizes de contribuição, padrões de código e registros de decisões arquiteturais (ADRs).
- `sanidade-ambiente/`: Serviços, scripts de validação de requisitos logísticos e varreduras operacionais para atestar a total integridade e adequação do ambiente.

### 2.3. Módulos Específicos
Componentes operando camadas exclusivas e ferramentas restritas que expandem a automação DevOps e gestão do produto.
- `cloud-setup/`: Códigos e scripts com alocação específica pra subida contínua ou temporária de provedores externos VPS e topologia de rede remota.
- `infra-core/`: A infraestrutura unificada agindo na orquestração estrita de containers paralelos centrais (APIs, RDBMS DBs, key-values e Vector DBs), compartilhando a rede `dev-workspace-net`.
- `rotina-devops/`: Camada automatizada agrupando telemetria assíncrona, observabilidade matinal e relatórios rotineiros focados no shift-left.
- `gestao-centralizada-agents/`: Núcleo de integração inteligente via MCP (Model Context Protocol). Coordena as Personas, a infraestrutura gerada por IA isolada, linters assíncronos e o uso de Skills no laboratório.

## 3. Critério de Exibição (Vitrine e Abstração)

### 3.1. Vitrine (`README.md` - Consumo Direto)
O foco central para o consumidor que avalia ou entra na plataforma envolve respostas instantâneas arquiteturais:
- O entrypoint obrigatório de acesso ao repositório via chamadas ao `Makefile`.
- Resumo visual e esquemático demonstrando os componentes que suportam a operação diária.
- Um manual rápido englobando premissas de execução idempotentes.

### 3.2. Detalhe Interno (Contexto Isolado Oculto)
Implementações profundas que limitam a poluição na vitrine global e retêm granularidade arquitetural restrita às áreas segmentadas:
- O nível de execução das roles, modules ou sub-tarefas de base em playbooks originadas do `ansible/`.
- Configurações do servidor base, dependências e configurações JSON operando nas bases de skills contidas em `gestao-centralizada-agents/`.
- Regras lógicas, restrições e detalhamentos específicos do provisionamento tático das pipelines que ocorrem por debaixo das validações do `sanidade-ambiente/`.
