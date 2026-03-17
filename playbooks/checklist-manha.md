# Checklist da Manhã — Rotina DevOps

> Objetivo: começar o dia com clareza, controle e prioridade definida.

---

## 1. Abertura do dia
- [ ] Abrir terminal
- [ ] Confirmar data e hora
- [ ] Confirmar que estou no ambiente de trabalho correto
- [ ] Respirar, organizar a cabeça e evitar começar no impulso

### Comandos úteis
```bash
date
pwd
whoami
````
```
#### 1.1 Prompts para copilot

Abir arquivo com prompts de abertura de sessão e rodar no copilot para contexto 

```
---
```
## 2. Saúde da máquina

* [ ] Verificar se o ambiente local está funcional
* [ ] Confirmar Docker acessível
* [ ] Confirmar ferramentas principais disponíveis
* [ ] Verificar se há erro local óbvio antes de começar

### Comandos úteis

```bash
docker ps
docker compose ls
git --version
terraform version
kubectl version --client=true
python3 --version
```

### Quando necessário

```bash
/home/diegosantos/scripts/check_devops_env.sh
```

---

## 3. Revisão dos projetos ativos

* [ ] Identificar quais projetos estão em andamento
* [ ] Revisar o estado do projeto principal do dia
* [ ] Verificar último avanço realizado
* [ ] Definir o próximo passo concreto
* [ ] Identificar bloqueios

### Perguntas que devo responder

* Qual projeto é prioridade hoje?
* O que já está funcionando?
* O que está quebrado?
* Qual é o próximo passo objetivo?
* Como vou validar que avancei?

---

## 4. Verificação operacional

* [ ] Conferir containers em execução
* [ ] Conferir logs relevantes, se necessário
* [ ] Conferir alterações locais em repositórios
* [ ] Validar projeto principal antes de editar

### Comandos úteis

```bash
docker ps
docker compose ps
git status
git branch
git log --oneline -5
```

### Terraform

```bash
terraform fmt
terraform validate
terraform plan
```

### Kubernetes

```bash
kubectl get pods -A
kubectl get nodes
```

---

## 5. Definição da entrega do dia

* [ ] Escolher uma entrega principal
* [ ] Definir uma meta clara e pequena
* [ ] Evitar abrir muitos contextos ao mesmo tempo
* [ ] Registrar o que precisa ficar pronto hoje

### Modelo rápido

* Projeto principal:
* Objetivo do dia:
* Próximo comando:
* Risco principal:
* Evidência de conclusão:

---

## 6. Regras de execução

* [ ] Não começar mudando coisa sem validar o estado atual
* [ ] Não trabalhar só pela memória
* [ ] Não misturar correção, refatoração e experimento ao mesmo tempo
* [ ] Sempre deixar registrado o próximo passo antes de parar

---

## 7. Fechamento da manhã

* [ ] Ambiente validado
* [ ] Projeto principal identificado
* [ ] Estado atual entendido
* [ ] Próximo passo definido
* [ ] Dia iniciado com controle, não com reação

---

## Lembrete diário

**Meu trabalho pela manhã é entender o estado da máquina, dos serviços e dos projetos antes de tentar avançar.**

**Se eu não sei o que está rodando, o que está quebrado e o que vou entregar hoje, eu ainda não comecei o dia de verdade.**

````



