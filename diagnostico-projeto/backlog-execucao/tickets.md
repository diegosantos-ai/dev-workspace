# Backlog executável do projeto

## Ordem de ataque

1. Estrutura oficial do repositório
2. Contrato de ambiente
3. Setup validável
4. Documentação de adoção
5. Preparação para referência externa

---

# FASE 1 — Consolidação estrutural

## TICKET 1.1 — Definir estrutura oficial do repositório

**Objetivo**
Definir a árvore oficial do projeto e classificar o que é oficial, experimental, pessoal, legado ou ambíguo.

**Entregável**
Documento curto com a estrutura oficial do repositório e papel de cada domínio principal.

**Dependências**
Nenhuma.

**Critério de pronto**

* existe uma estrutura oficial definida;
* cada área principal tem função clara;
* ficou claro o que não faz parte da estrutura oficial.

---

## TICKET 1.2 — Revisar raiz do repositório

**Objetivo**
Reduzir poluição na raiz e deixar apenas entradas de alto nível.

**Entregável**
Raiz reorganizada com arquivos e diretórios coerentes com função de entrada, documentação ou configuração global.

**Dependências**
1.1

**Critério de pronto**

* a raiz não parece depósito;
* arquivos soltos sem função clara foram realocados, consolidados ou removidos;
* a leitura da raiz comunica bem o projeto.

---

## TICKET 1.3 — Saneamento de naming

**Objetivo**
Padronizar nomes de diretórios, arquivos e domínios do projeto.

**Entregável**
Naming consistente entre pastas, arquivos e comandos.

**Dependências**
1.1, 1.2

**Critério de pronto**

* não há nomes ambíguos;
* não há diretórios com nome desalinhado da função real;
* não há temas duplicados com nomes diferentes.

---

## TICKET 1.4 — Separar oficial, pessoal e experimental

**Objetivo**
Evitar que o projeto misture padrão adotável com preferência pessoal ou laboratório.

**Entregável**
Classificação prática do que é:

* oficial
* pessoal
* experimental
* legado

**Dependências**
1.1

**Critério de pronto**

* terceiro consegue entender o que é base oficial;
* áreas pessoais ou experimentais não geram confusão de adoção.

---

# FASE 2 — Contrato de ambiente

## TICKET 2.1 — Inventariar dependências do workspace

**Objetivo**
Listar ferramentas obrigatórias, opcionais e auxiliares para o ambiente funcionar.

**Entregável**
Inventário técnico de dependências do workspace.

**Dependências**
1.1

**Critério de pronto**

* dependências essenciais estão listadas;
* está claro o que é obrigatório e o que é opcional;
* não há dependência implícita crítica.

---

## TICKET 2.2 — Definir política de versionamento

**Objetivo**
Padronizar como versões de ferramentas serão controladas.

**Entregável**
Estratégia clara para versionamento de ferramentas do ambiente.

**Dependências**
2.1

**Critério de pronto**

* ficou definido como versionar ferramentas;
* ficou claro como validar aderência da máquina;
* reduzimos risco de divergência entre máquinas.

---

## TICKET 2.3 — Declarar sistema operacional suportado

**Objetivo**
Assumir formalmente o ambiente suportado nesta fase do projeto.

**Entregável**
Política de suporte por sistema operacional.

**Dependências**
2.1

**Critério de pronto**

* o SO suportado está explícito;
* limitações conhecidas estão registradas;
* não há falsa impressão de portabilidade ampla.

---

## TICKET 2.4 — Definir padrão de variáveis de ambiente

**Objetivo**
Criar contrato mínimo para env vars necessárias ao workspace.

**Entregável**
Padrão de variáveis de ambiente e arquivo de exemplo, se aplicável.

**Dependências**
2.1

**Critério de pronto**

* variáveis obrigatórias estão identificadas;
* variáveis opcionais estão separadas;
* existe referência segura para preenchimento.

---

## TICKET 2.5 — Definir política de secrets

**Objetivo**
Padronizar o tratamento de secrets no workspace.

**Entregável**
Política mínima de secrets e não versionamento.

**Dependências**
2.4

**Critério de pronto**

* ficou claro onde secrets vivem;
* ficou claro o que nunca deve ser versionado;
* risco de improviso reduziu.

---

# FASE 3 — Setup reproduzível e validável

## TICKET 3.1 — Mapear fluxo real de setup

**Objetivo**
Descrever o fluxo atual como ele realmente acontece, sem idealização.

**Entregável**
Mapa do fluxo de setup atual: bootstrap, setup, pós-setup e auditoria.

**Dependências**
1.1, 2.1

**Critério de pronto**

* o fluxo real está documentado;
* ficou claro onde começa e onde termina;
* dependências implícitas ficaram visíveis.

---

## TICKET 3.2 — Separar bootstrap, setup e pós-setup

**Objetivo**
Delimitar responsabilidades e evitar fluxo confuso.

**Entregável**
Fluxo oficial dividido em:

* bootstrap
* setup
* validação final
* manutenção/auditoria

**Dependências**
3.1

**Critério de pronto**

* cada etapa tem responsabilidade clara;
* o usuário sabe qual comando usar em cada momento;
* não há sobreposição confusa entre etapas.

---

## TICKET 3.3 — Revisar o papel do Makefile como interface principal

**Objetivo**
Transformar o Makefile em ponto de entrada claro do projeto.

**Entregável**
Conjunto enxuto de comandos principais e bem definidos.

**Dependências**
3.2

**Critério de pronto**

* `make help` comunica o fluxo do projeto;
* comandos principais têm responsabilidade clara;
* não há excesso de comandos redundantes ou obscuros.

---

## TICKET 3.4 — Revisar artefatos que comprometem previsibilidade

**Objetivo**
Analisar componentes que reduzem auditabilidade e reprodutibilidade, como uso de backup empacotado ou fluxos opacos.

**Entregável**
Decisão técnica sobre permanência, substituição ou remoção desses artefatos.

**Dependências**
3.1

**Critério de pronto**

* cada artefato sensível teve sua função validada;
* o fluxo ficou mais auditável;
* o setup depende menos de estado oculto.

---

## TICKET 3.5 — Definir critério de “máquina pronta”

**Objetivo**
Transformar setup concluído em ambiente comprovadamente operacional.

**Entregável**
Checklist técnico de prontidão do ambiente.

**Dependências**
2.1, 2.4, 2.5, 3.2

**Critério de pronto**

* existe definição objetiva de ambiente pronto;
* não dependemos só de “rodou sem erro”;
* o sucesso do setup é verificável.

---

## TICKET 3.6 — Fortalecer checks de sanidade

**Objetivo**
Fazer os checks validarem operação real, não só presença de binário.

**Entregável**
Sanidade de ambiente mais útil e aderente ao critério de máquina pronta.

**Dependências**
3.5

**Critério de pronto**

* checks informam sucesso, falha e alerta com clareza;
* cobertura mínima de dependências críticas existe;
* a validação ajuda troubleshooting real.

---

## TICKET 3.7 — Revisar tratamento de erros no setup

**Objetivo**
Reduzir falsos positivos no fluxo de instalação.

**Entregável**
Revisão dos pontos onde erros críticos podem ser mascarados.

**Dependências**
3.1, 3.5

**Critério de pronto**

* erros críticos não passam silenciosamente;
* tolerância a erro ficou intencional, não acidental;
* o setup falha quando precisa falhar.

---

# FASE 4 — Documentação de adoção

## TICKET 4.1 — Reescrever README principal como entrada do projeto

**Objetivo**
Transformar o README em porta de entrada séria e útil.

**Entregável**
README com visão geral, escopo, estrutura e entrypoints.

**Dependências**
1.1, 3.2, 3.3

**Critério de pronto**

* um terceiro entende o que é o projeto;
* o README aponta o caminho certo de uso;
* o texto tem tom profissional e técnico.

---

## TICKET 4.2 — Criar documentação de Getting Started

**Objetivo**
Explicar como preparar uma máquina nova do zero.

**Entregável**
Guia de instalação inicial.

**Dependências**
2.1, 2.3, 2.4, 3.2, 3.5

**Critério de pronto**

* alguém novo consegue iniciar o setup;
* pré-requisitos estão claros;
* a validação pós-setup está descrita.

---

## TICKET 4.3 — Criar guia de estrutura do repositório

**Objetivo**
Explicar a organização oficial do workspace.

**Entregável**
Documento curto explicando diretórios e responsabilidades.

**Dependências**
1.1, 1.4

**Critério de pronto**

* a estrutura do repositório é compreensível;
* domínios do projeto não parecem soltos;
* reduzimos dependência de contexto implícito.

---

## TICKET 4.4 — Criar troubleshooting mínimo

**Objetivo**
Documentar erros comuns, sinais de falha e caminhos básicos de validação.

**Entregável**
Guia de troubleshooting inicial.

**Dependências**
3.5, 3.6, 3.7

**Critério de pronto**

* problemas recorrentes têm orientação mínima;
* troubleshooting não depende só do autor;
* existe caminho básico de diagnóstico.

---

## TICKET 4.5 — Criar rotina de manutenção e revalidação

**Objetivo**
Documentar como manter o workspace ao longo do tempo.

**Entregável**
Guia de manutenção contínua.

**Dependências**
3.3, 3.6

**Critério de pronto**

* update, audit, repair e recheck estão claros;
* a operação contínua ficou previsível;
* existe rotina mínima de manutenção.

---

# FASE 5 — Preparação para referência externa

## TICKET 5.1 — Definir posicionamento oficial do projeto

**Objetivo**
Deixar claro se o projeto é:

* workspace pessoal estruturado,
* referência aberta,
* base adotável por times.

**Entregável**
Posicionamento explícito do projeto.

**Dependências**
4.1, 4.2, 4.3

**Critério de pronto**

* o projeto não promete mais do que entrega;
* o escopo de adoção ficou honesto;
* a comunicação está alinhada à maturidade real.

---

## TICKET 5.2 — Declarar limitações e fronteiras

**Objetivo**
Evitar falsa expectativa de cobertura.

**Entregável**
Seção de limitações, premissas e suporte.

**Dependências**
2.3, 5.1

**Critério de pronto**

* limitações estão claras;
* terceiros entendem o que o projeto cobre e o que não cobre;
* reduzimos risco de adoção equivocada.

---

## TICKET 5.3 — Definir critérios mínimos de adoção por terceiros

**Objetivo**
Criar base para apresentar o projeto como solução reutilizável.

**Entregável**
Critérios objetivos para dizer que o projeto já pode ser usado como referência externa.

**Dependências**
3.5, 4.2, 4.4, 4.5, 5.2

**Critério de pronto**

* existe régua objetiva de maturidade;
* ficou claro o que falta para adoção externa;
* o projeto tem critério de referência, não só intenção.

---

# Backlog resumido por prioridade

## Prioridade alta

* 1.1 Definir estrutura oficial do repositório
* 1.2 Revisar raiz do repositório
* 1.3 Saneamento de naming
* 2.1 Inventariar dependências do workspace
* 2.2 Definir política de versionamento
* 2.3 Declarar sistema operacional suportado
* 2.4 Definir padrão de variáveis de ambiente
* 2.5 Definir política de secrets
* 3.1 Mapear fluxo real de setup
* 3.2 Separar bootstrap, setup e pós-setup
* 3.5 Definir critério de “máquina pronta”
* 3.6 Fortalecer checks de sanidade

## Prioridade média

* 3.3 Revisar o papel do Makefile
* 3.4 Revisar artefatos que comprometem previsibilidade
* 3.7 Revisar tratamento de erros no setup
* 4.1 Reescrever README principal
* 4.2 Criar documentação de Getting Started
* 4.3 Criar guia de estrutura do repositório
* 4.4 Criar troubleshooting mínimo
* 4.5 Criar rotina de manutenção e revalidação

## Prioridade baixa

* 5.1 Definir posicionamento oficial do projeto
* 5.2 Declarar limitações e fronteiras
* 5.3 Definir critérios mínimos de adoção por terceiros

# Sprint inicial recomendada


1. 1.1 Definir estrutura oficial do repositório
2. 1.3 Saneamento de naming
3. 2.1 Inventariar dependências do workspace
4. 2.3 Declarar sistema operacional suportado
5. 3.1 Mapear fluxo real de setup
6. 3.5 Definir critério de “máquina pronta”

Esses 6 dão base para todo o resto.

