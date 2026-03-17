# 📖 PPO: Padrão Operacional de Trabalho e Arquitetura

Este **Golden Path** define exatamente como nascem, operam e são migrados e recuperados todos os projetos sob o padrão Premium DevOps.

---

## 🚀 0. Primeiro Uso (Setup em Novos Ambientes)
Sempre que formatar sua máquina ou assumir um novo equipamento, o projeto DevOps rege seu setup inicial através de automação idempotente. 

**Passo a passo inquebrável:**
1. Clone este repositório `dev-workspace` no seu novo destino de projetos limitando atuar dentro dele:
   ```bash
   git clone https://github.com/diegosantos-ai/dev-workspace.git ~/docs/dev-workspace
   cd ~/docs/dev-workspace
   ```
2. Inicialize o Bootstrap do sistema que rodará o Ansible nos bastidores e linkará seus dotfiles (VS Code, terminal, regras globais de IA):
   ```bash
   make setup
   ```
3. Feche o terminal e abra o VS Code em sua nova home. As regras (God Prompts) do Github Copilot já estarão ativadas.
4. Para validar que tudo está vivo, rode a verificação e inicie o dia:
   ```bash
   make morning
   ```

---

## 🏗️ 1. O Padrão Universal (Nascimento de Projetos)
Todo novo repositório isolado de cliente/serviço que nascer a partir de hoje deve OBRIGATORIAMENTE possuir a seguinte fundação:
1. **Entrypoint Único (`Makefile`):** Ninguém adivinha comandos imperativos extênsos. A automação local de todo projeto reside num `make test`, `make build`, etc.
2. **Shift-Left Security (`.pre-commit-config.yaml`):** Protegendo de ponta a ponta commits contra senhas vazadas (Gitleaks) e IaC frágil (TFLint).
3. **Identidade Declarativa:** `README.md` limpo possuindo badges da qualidade CI e diagrama Mermaid explicando o design.
4. **CI/CD Mínimo:** Processos automatizados no `.github/workflows/` (ou análogo) que amarrem o repasse de verificação de qualidade à branch principal.

---

## 🛟 2. Adequação de Projetos Legados (Spaghetti Recovery)
Ao assumir um projeto caótico fora do padrão, siga essa engrenagem infalível:
1. **Congelar e Auditar:** Não implemente features de cara. Faça varreduras manuais. Execute Gitleaks e Checkov no ambiente estático.
2. **Implementar Grades (Fase "Zero Trust"):** Insira o `.pre-commit` e conserte a formatação (Lint) geral antes de mexer na lógica de negócio.
3. **Mover e Refatorar para o Padrão:** Separe configurações "hardcoded", isole senhas, crie o Makefile e divida a responsabilidade do código usando os pilares da seção 1.

---

## 🐳 3. Governança Docker (Anticolisão de Portas)
A regra fundamental ao gerenciar múltiplos projetos locais é **NUNCA fazer variação dura (hardcode) de portas expostas em arquivos `docker-compose.yml`**.

**O Padrão Golden Path (CORRETO):**
Use injeção via `.env` com Fallbacks que facilitam tanto execução por IAs quanto setups manuais em outros PCs.

```yaml
services:
  db:
    image: postgres
    ports:
      - "${PROJECT_DB_PORT:-5432}:5432" # Injeção externa via .env
```
> **Matriz de Portas por Projeto:**  
> Ao construir os arquivos via Copilot/IAs, force-os a utilizar de IDs base pra portas. Ex: Projeto de n8n empresa X = faixa `10xxx` (App=10080, DB=10543), enquanto Projeto Hub empresa Y = `11xxx` (App=11080). Garantia de zero "Address already in use".

---

## ☁️ 4. Refatoração e Manutenção do Terraform (Safe Migration)
Você NUNCA deve alterar o local (pathing) ou reestruturar arquivos de IaC pesados (ex: mudar um `main.tf` base para dentro de uma pasta `modules/compute`) sem explicitar isso para o Provedor. Se não ele "destruirá" a sua máquina AWS pra criar ela denovo no "novo endereço".

Ao passar arquiteturas pra **"Clean Workspaces"** (`envs/` > `modules/`), cumpra a "Migração Cirúrgica":
1. Mova esteticamente os blocos ao local de destino.
2. Crie e assine o bloco `moved {}` referenciando que a infra só trocou de pasta de configuração (do raiz para o módulo).
   ```terraform
   moved {
     from = aws_instance.web
     to   = module.compute.aws_instance.web
   }
   ```
3. O comando final e avaliador deve ser `terraform plan`. Seu log de retorno **deve ser obrigatoriamente** "No changes. Infrastructure base up-to-date". Se pedir para Destruir (Destroy: 1), a refatoração falhou e a estrutura deve ser revista antes do *apply*.

---
**Revisão Final:**  
Você não clona nem codifica softwares diretamente dentro dessa Pasta Raiz DevOps. Isto aqui é o seu **Painel de Controle e Formulário (Cockpit)** de onde você rege e avalia todos os outros ambientes.
