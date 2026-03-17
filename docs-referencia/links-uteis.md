### Mapa rápido de operação:

* onde estão suas pastas importantes
* quais comandos você mais usa
* quais projetos existem
* como validar cada tipo de projeto
* onde agir quando o `morning_check.sh` mostrar alguma coisa

A lógica fica linda e útil assim:

* `morning_check.sh` = mostra a foto do ambiente
* `checklist-manha.md` = organiza sua leitura e decisão
* `links-uteis.md` = te dá caminho rápido para agir
* `rotina-devops.md` = manual completo

## Estrutura que eu recomendo para o `links-uteis.md`

Ele precisa ser curto, consultável e operacional. Nada de virar enciclopédia triste.

````md
# Links Úteis — Rotina DevOps

## 1. Pastas principais

### Documentação de rotina
- `/home/diegosantos/docs/rotina-devops/`
- Checklist: `/home/diegosantos/docs/rotina-devops/checklist-manha.md`
- Manual: `/home/diegosantos/docs/rotina-devops/rotina-devops.md`
- Links úteis: `/home/diegosantos/docs/rotina-devops/links-uteis.md`

### Scripts
- `/home/diegosantos/scripts/`
- Auditoria do ambiente: `/home/diegosantos/scripts/check_devops_env.sh`
- Ritual da manhã: `/home/diegosantos/scripts/morning_check.sh`

### Labs
- `/home/diegosantos/labs/`
- Lab OVH Terraform: `/home/diegosantos/labs/ovh-terraform`

### Projetos
- `/home/diegosantos/projetos/`

---

## 2. Comandos principais do dia a dia

### Ritual da manhã
```bash
/home/diegosantos/scripts/morning_check.sh
````

### Auditoria completa do ambiente

```bash
/home/diegosantos/scripts/check_devops_env.sh
```

### Abrir checklist

```bash
xdg-open /home/diegosantos/docs/rotina-devops/checklist-manha.md
```

### Abrir manual

```bash
xdg-open /home/diegosantos/docs/rotina-devops/rotina-devops.md
```

---

## 3. Comandos úteis por categoria

### Git

```bash
git status
git branch
git log --oneline -5
```

### Docker

```bash
docker ps
docker compose ps
docker compose ls
docker logs <container> --tail 50
```

### Terraform

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

### Kubernetes

```bash
kubectl version --client=true
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
```

### Python

```bash
python3 --version
pip3 --version
python3 -m venv .venv
source .venv/bin/activate
deactivate
```

---

## 4. Caminhos importantes de trabalho

### Entrar no lab OVH Terraform

```bash
cd /home/diegosantos/labs/ovh-terraform
```

### Validar o lab OVH Terraform

```bash
terraform fmt
terraform validate
terraform plan
```

---

## 5. Sinais de atenção

### Se Docker falhar

Verificar:

```bash
docker info
groups
systemctl status docker --no-pager
```

### Se Terraform falhar

Verificar:

```bash
terraform version
terraform init
terraform validate
```

### Se kubectl falhar

Verificar:

```bash
kubectl version --client=true
kubectl config view
```

### Se Git estiver estranho

Verificar:

```bash
git status
git branch
git remote -v
```

---

## 6. Regra rápida de decisão

* Se bloqueia meu trabalho hoje: corrigir agora
* Se não bloqueia: registrar como tarefa
* Se é recorrente: transformar em melhoria de processo
* Se não entendi o problema: investigar antes de agir

---

## 7. Projeto principal atual

### OVH Terraform Lab

Pasta:

```bash
/home/diegosantos/labs/ovh-terraform
```

Validação:

```bash
cd /home/diegosantos/labs/ovh-terraform
terraform fmt
terraform validate
terraform plan
```

````



