# **PLAYBOOK — Padrão Operacional de Trabalho**

## **Objetivo**

Este documento registra o padrão operacional que será usado na execução dos projetos de portfólio DevOps.

A função deste playbook é reduzir retrabalho, manter consistência de execução e dar clareza sobre:

* onde estou  
* o que devo fazer agora  
* qual é a ordem correta  
* como validar cada etapa  
* quando algo pode ser considerado concluído

---

## **Princípios de execução**

### **1\. Primeiro definir o padrão**

Antes de executar, definir com clareza:

* estrutura  
* nomes  
* ordem  
* critério de conclusão  
* o que não deve mudar

### **2\. Depois executar em cima do padrão**

Evitar ficar renomeando, reorganizando ou refazendo o mesmo trabalho sem motivo técnico real.

### **3\. Só mudar o padrão com justificativa**

Mudanças de padrão só devem acontecer quando houver:

* risco operacional  
* inconsistência técnica  
* simplificação real  
* ganho claro de rastreabilidade

### **4\. Feito não é igual a validado**

Uma atividade só pode ser considerada concluída depois de validada.

### **5\. Não começar no impulso**

Antes de alterar qualquer coisa, validar:

* estado atual  
* contexto do projeto  
* impacto da mudança  
* forma de validação

---

## **Padrão de organização no Trello**

### **Listas fixas**

* Backlog  
* Próximo ciclo  
* Em andamento  
* Bloqueado  
* Em validação  
* Concluído

### **Regra de uso das listas**

#### **Backlog**

Tudo que existe para fazer, mas ainda não entrou na vez.

#### **Próximo ciclo**

Itens que estão prontos para serem executados em seguida.

#### **Em andamento**

O que está aberto agora.

#### **Bloqueado**

Itens travados por dúvida, erro, dependência externa ou decisão pendente.

#### **Em validação**

Itens em que a alteração já foi feita, mas ainda falta validar.

#### **Concluído**

Só entra o que foi realmente fechado e validado.

### **Padrão de nome dos cards**

Formato fixo:

`PXX - Ação objetiva`

Exemplos:

* `P01 - Criar README inicial`  
* `P01 - Preencher .gitignore`  
* `P01 - Definir requirements.txt`  
* `P01 - Validar execução local`

### **Card macro**

Formato:

`Bootstrap do projeto 01`

Usar esse card para acompanhar a fase estrutural do projeto com checklist interna.

---

## **Padrão de branches**

### **Estratégia atual**

* `main` como branch principal  
* sem `develop` por enquanto  
* uma branch por contexto de trabalho

### **Prefixos permitidos**

* `feature/`  
* `fix/`  
* `docs/`  
* `refactor/`  
* `chore/`  
* `test/`  
* `experiment/`

### **Regra prática**

Criar uma nova branch quando mudar:

* objetivo  
* tipo de trabalho  
* contexto técnico  
* escopo da mudança

### **Exemplo atual**

* `feature/bootstrap-fastapi`

---

## **Padrão de início de projeto**

### **Fase 1 — Bootstrap**

1. definir objetivo  
2. definir escopo inicial  
3. criar estrutura de pastas e arquivos  
4. iniciar Git  
5. criar branch de trabalho  
6. preencher README inicial  
7. preencher `.gitignore`  
8. definir `requirements.txt`

### **Fase 2 — Ambiente local**

9. criar `.venv`  
10. ativar `.venv`  
11. instalar dependências

### **Fase 3 — Implementação mínima**

12. criar a aplicação mínima  
13. validar execução local

### **Fase 4 — Empacotamento**

14. criar Dockerfile  
15. validar build  
16. validar execução do container

### **Fase 5 — Versionamento**

17. revisar `git status`  
18. commitar  
19. integrar de volta na `main` quando o ciclo fechar

---

## **Regra para o primeiro commit**

O primeiro commit não deve ser feito apenas porque o repositório foi criado.

O primeiro commit deve representar uma base coerente do projeto.

### **Mínimo esperado antes do primeiro commit**

* README inicial útil  
* `.gitignore` correto  
* `requirements.txt` definido  
* estrutura do projeto coerente

### **Ideal**

Além do mínimo acima, já ter a entrega mínima validada localmente.

---

## **Padrão de README inicial**

O README inicial não precisa estar completo, mas precisa ser útil.

### **Deve conter no mínimo**

* nome do projeto  
* objetivo  
* escopo inicial  
* stack  
* estrutura inicial  
* próximos passos

### **Modelo base**

\# nome-do-projeto

\#\# Objetivo  
Descrever o que o projeto prova e qual problema resolve.

\#\# Escopo inicial  
\- item 1  
\- item 2  
\- item 3

\#\# Stack  
\- tecnologia 1  
\- tecnologia 2  
\- tecnologia 3

\#\# Estrutura inicial  
\- pasta/arquivo e finalidade

\#\# Próximos passos  
1\. passo 1  
2\. passo 2  
3\. passo 3

---

## **Padrão de validação**

Antes de mover qualquer item para `Concluído`, validar:

* a mudança realmente foi feita  
* o comportamento esperado aconteceu  
* não ficou pendência escondida  
* a documentação mínima foi ajustada, se necessário

### **Regra**

Se mexeu mas ainda não validou, vai para `Em validação`, não para `Concluído`.

---

## **Padrão de rotina diária**

### **Início do dia**

Responder:

* qual card está em andamento  
* qual é o próximo passo  
* existe algo bloqueado  
* o ambiente está pronto

### **Durante o trabalho**

Responder:

* continuo no mesmo contexto  
* o card ainda está bem definido  
* preciso quebrar a atividade  
* existe algo a validar antes de seguir

### **Fechamento do ciclo**

Responder:

* o que foi concluído  
* o que foi validado  
* o que ficou bloqueado  
* qual é o próximo passo do próximo turno

---

## **Aplicação imediata no Projeto 01**

### **Projeto**

`devopsjr-api-cicd`

### **Fase atual**

Bootstrap do projeto.

### **Próximo ciclo atual**

* `P01 - Criar README inicial`  
* `P01 - Preencher .gitignore`  
* `P01 - Definir requirements.txt`

### **Só depois disso**

* implementar aplicação mínima  
* validar localmente  
* criar Dockerfile  
* validar container  
* commitar

---

## **Regra final**

Este playbook existe para manter consistência.

A regra é simples:

**definir o padrão uma vez, executar com método e só ajustar quando houver motivo técnico real.**

