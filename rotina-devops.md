# Manual de Rotina DevOps

> Objetivo: manter clareza operacional, reduzir improviso e criar uma rotina profissional de trabalho em DevOps.

---

# 1. Propósito deste manual

Este manual existe para orientar minha rotina diária como profissional em formação e atuação em DevOps.

Ele deve me ajudar a:

- começar o dia com clareza
- entender o estado da máquina e dos projetos
- priorizar o que realmente importa
- reduzir erros por impulso
- trabalhar com método
- registrar contexto para continuidade

DevOps não é apenas executar comandos ou instalar ferramentas.  
É operar ambientes, serviços e projetos com previsibilidade, validação e disciplina.

---

# 2. Princípios da rotina

Todos os dias, antes de começar a executar qualquer tarefa, devo responder:

1. O que está disponível no meu ambiente hoje?
2. O que está rodando neste momento?
3. O que está em andamento nos meus projetos?
4. O que está bloqueado ou precisa de atenção?
5. Qual é a entrega principal do dia?

Se eu não sei responder isso, eu ainda não comecei o dia de forma profissional.

---

# 3. Estrutura da rotina da manhã

Minha manhã deve seguir esta ordem:

## 3.1 Abertura
Objetivo: entrar em contexto antes de agir.

### Ações
- abrir terminal
- confirmar data, hora e usuário
- rodar o script de rotina da manhã
- abrir checklist da manhã
- lembrar que o objetivo inicial é entender o estado atual, não sair mudando coisas

### Comando principal

```bash
/home/diegosantos/scripts/morning_check.sh
````

```
## 3.2 Leitura do ambiente

Objetivo: entender se minha máquina está pronta para o trabalho do dia.

### O que observar

* ferramentas principais disponíveis
* Docker acessível
* containers ativos
* sinais de erro ou ausência de ferramenta importante
* necessidade de manutenção ou atualização futura

### Interpretação correta

O `morning_check.sh` funciona como uma foto operacional rápida do ambiente.

Ele não substitui observabilidade completa, mas mostra:

* o que está disponível
* o que está acessível
* o que parece saudável no básico
* o que merece atenção

Se algo estiver estranho, devo decidir:

* corrigir agora, se bloquear meu trabalho
* registrar como tarefa, se não bloquear
* investigar melhor, se não estiver claro

---

## 3.3 Revisão dos projetos

Objetivo: saber em que contexto estou entrando antes de começar a editar ou executar algo.

Para cada projeto ativo, devo saber:

* status atual
* último avanço
* próximo passo
* risco principal
* como validar o estado atual

### Modelo de leitura
```
```text
Projeto:
Status:
Último avanço:
Próximo passo:
Risco:
Comando de validação:
```

### Exemplo

```text
Projeto: OVH Terraform Lab
Status: estrutura pronta e validada
Último avanço: terraform plan executado com sucesso
Próximo passo: definir primeiro recurso real seguro
Risco: criar recurso sem necessidade ou expor credenciais
Comando de validação: terraform fmt && terraform validate && terraform plan
```

---

## 3.4 Definição da prioridade do dia

Objetivo: não cair no caos de múltiplos contextos.

Antes de iniciar o trabalho, devo definir:

* projeto principal do dia
* entrega principal do dia
* próximo passo concreto
* evidência de conclusão

### Modelo rápido

```text
Projeto principal:
Entrega do dia:
Próximo passo:
Risco principal:
Critério de conclusão:
```

---

# 4. Como iniciar um projeto novo

Ao iniciar um projeto novo, devo evitar improvisação.

## 4.1 Definir o tipo do projeto

Antes de criar arquivos, preciso saber o que o projeto é:

* automação
* API
* infraestrutura com Terraform
* containerização
* integração entre serviços
* laboratório de estudo
* observabilidade
* projeto de suporte operacional

## 4.2 Definir o objetivo em uma frase

Todo projeto deve responder:

> “Este projeto existe para...”

### Exemplo

> Este projeto existe para provisionar e validar infraestrutura básica na OVH com Terraform.

Se eu não consigo escrever isso, o projeto ainda está mal definido.

## 4.3 Criar estrutura mínima

Todo projeto deve começar com organização básica.

### Estrutura genérica

```text
projeto/
├── README.md
├── .gitignore
├── docs/
├── scripts/
├── src/
├── tests/
└── infra/
```

### Estrutura para Terraform

```text
terraform-lab/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
├── outputs.tf
├── README.md
└── .gitignore
```

## 4.4 Criar README desde o início

Todo projeto deve ter README.

### Estrutura mínima do README

* objetivo
* stack
* como executar
* como validar
* próximos passos

## 4.5 Definir comando de validação

Todo projeto precisa ter um ritual de sanidade.

### Exemplos

* Python: `pytest`
* Docker: `docker compose up -d && docker compose ps`
* Terraform: `terraform fmt && terraform validate && terraform plan`
* API: healthcheck com `curl` ou `http`
* SQL: queries de validação

Se um projeto não tem forma simples de validar, ele ainda não está operacional.

---

# 5. Como trabalhar em projetos em andamento

Projeto em andamento não pode depender apenas da memória.

## 5.1 Sempre reabrir contexto

Antes de alterar um projeto existente:

1. entrar na pasta
2. ler o README
3. rodar o comando de validação
4. verificar `git status`
5. entender o estado atual antes de editar

### Exemplo

```bash
cd /home/diegosantos/labs/ovh-terraform
git status
terraform fmt
terraform validate
terraform plan
```

## 5.2 Nunca editar no escuro

Antes de mudar qualquer coisa, devo responder:

* isso já funciona?
* o que exatamente quero mudar?
* como vou validar essa mudança?
* como vou saber se melhorou?

## 5.3 Uma intenção por vez

Evitar misturar no mesmo ciclo:

* correção
* refatoração
* experimento
* documentação
* melhoria de estrutura

Misturar tudo ao mesmo tempo gera confusão e dificulta validação.

## 5.4 Registrar próximo passo ao pausar

Sempre que eu interromper um projeto, devo deixar um rastro claro.

### Modelo

```text
Último ponto:
Próximo passo:
Bloqueio:
Comando inicial da próxima retomada:
```

---

# 6. Como conferir projetos e serviços rodando

Existir não significa estar saudável.
Serviço rodando não significa serviço funcional.

## 6.1 Containers

### Comandos úteis

```bash
docker ps
docker compose ps
docker compose logs --tail 50
docker logs <container> --tail 50
```

### O que observar

* container ativo
* status saudável
* logs com erro
* portas expostas
* se deveria ou não estar rodando

## 6.2 Terraform

### Comandos úteis

```bash
terraform fmt
terraform validate
terraform plan
```

### O que observar

* sintaxe válida
* configuração íntegra
* mudanças previstas
* riscos antes do apply

## 6.3 Kubernetes

### Comandos úteis

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
kubectl get events -A --sort-by=.metadata.creationTimestamp
```

### O que observar

* pods falhando
* reinícios
* serviços indisponíveis
* eventos recentes com erro

## 6.4 Git

### Comandos úteis

```bash
git status
git branch
git log --oneline -5
git remote -v
```

### O que observar

* alterações não commitadas
* branch errada
* histórico recente
* repositório correto

---

# 7. Ritual de fechamento do dia

Encerrar o dia bem facilita muito a manhã seguinte.

## Antes de parar, devo:

* salvar tudo
* validar estado do projeto
* revisar `git status`
* registrar o próximo passo
* parar serviços locais desnecessários
* deixar o ambiente compreensível para amanhã

### Modelo de fechamento

```text
Encerrado hoje:
Pendências:
Primeiro passo de amanhã:
Bloqueios:
```

---

# 8. Regras operacionais

## Regra 1

Nunca começar no impulso.

## Regra 2

Sempre validar o estado atual antes de alterar algo.

## Regra 3

Não confiar apenas na memória.

## Regra 4

Registrar próximo passo antes de trocar de contexto.

## Regra 5

Se algo bloqueia o trabalho, corrigir.
Se não bloqueia, registrar e priorizar com critério.

## Regra 6

Se um problema se repete, ele não é só um problema.
Ele é um candidato a melhoria de processo.

---

# 9. Como interpretar alertas e anomalias

Nem todo sinal exige ação imediata.

## Quando agir na hora

* ferramenta crítica indisponível
* Docker inacessível e preciso usar containers
* erro que bloqueia a entrega do dia
* serviço que deveria estar rodando e não está

## Quando registrar como tarefa

* atualização de versão
* melhoria de script
* manutenção preventiva
* container estranho que não bloqueia o trabalho atual
* refinamento do ambiente

## Quando investigar antes de decidir

* erro novo
* comportamento inconsistente
* divergência entre contexto esperado e observado

---

# 10. Minha rotina diária resumida

## Manhã

1. rodar `morning_check.sh`
2. abrir checklist da manhã
3. revisar projeto principal
4. validar estado atual
5. definir entrega do dia

## Durante o dia

1. trabalhar em um contexto por vez
2. validar antes de mudar
3. registrar decisões e próximos passos
4. evitar acúmulo de contextos paralelos

## Final do dia

1. revisar estado do projeto
2. registrar próximo passo
3. organizar ambiente
4. encerrar com clareza

---

# 11. Documentos e scripts de apoio

## Documentos

* `/home/diegosantos/docs/rotina-devops/checklist-manha.md`
* `/home/diegosantos/docs/rotina-devops/links-uteis.md`
* `/home/diegosantos/docs/rotina-devops/rotina-devops.md`

## Scripts

* `/home/diegosantos/scripts/morning_check.sh`
* `/home/diegosantos/scripts/check_devops_env.sh`

---

# 12. Lembrete final

Meu trabalho em DevOps não começa executando comandos.
Ele começa entendendo o ambiente, os serviços e os projetos.

Se eu sei:

* o que tenho disponível
* o que está rodando
* o que está saudável
* o que está pendente
* e o que preciso entregar hoje

então comecei o dia corretamente.

Se eu não sei isso, estou apenas reagindo ao caos.

````



