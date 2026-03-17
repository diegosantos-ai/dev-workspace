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
- `~/dev-workspace/`
- Checklist: `~/dev-workspace/checklist-manha.md`
- Manual: `~/dev-workspace/rotina-devops.md`
- Links úteis: `~/dev-workspace/links-uteis.md`

### Scripts
- `~/dev-workspace/scripts/`
- Auditoria do ambiente: `~/dev-workspace/scripts/check_devops_env.sh`
- Ritual da manhã: `~/dev-workspace/scripts/morning_check.sh`

### Labs
- `~/labs/`
- Lab OVH Terraform: `~/labs/ovh-terraform`

### Projetos
- `~/projetos/`

---

## 2. Comandos principais do dia a dia

### Ritual da manhã
```bash
~/dev-workspace/scripts/morning_check.sh
````

### Auditoria completa do ambiente

```bash
~/dev-workspace/scripts/check_devops_env.sh
```

### Abrir checklist

```bash
xdg-open ~/dev-workspace/checklist-manha.md
```

### Abrir manual

```bash
xdg-open ~/dev-workspace/rotina-devops.md
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
cd ~/labs/ovh-terraform
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
~/labs/ovh-terraform
```

Validação:

```bash
cd ~/labs/ovh-terraform
terraform fmt
terraform validate
terraform plan
```

````
