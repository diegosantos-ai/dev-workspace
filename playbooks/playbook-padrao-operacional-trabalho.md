# 📖 PPO: Padrão Operacional de Trabalho e Arquitetura

Este **Golden Path** define exatamente como nascem, operam e são migrados e recuperados todos os projetos sob o padrão Premium DevOps.

---

## 🚀 0. Primeiro Uso (Setup em Novos Ambientes)
Sempre que formatar sua máquina ou assumir um novo equipamento, o projeto DevOps rege seu setup inicial através de automação idempotente.

**Passo a passo inquebrável:**
1. Clone este repositório `dev-workspace` no seu novo destino de projetos limitando atuar dentro dele:
   ```bash
   git clone https://github.com/diegosantos-ai/dev-workspace.git ~/dev-workspace
   cd ~/dev-workspace
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
Ao assumir um projeto caótico ou em andamento (criado fora do novo padrão de Plataforma), siga este guia passo a passo infalível para injetar a Governança local.

### 🛠️ Guia Prático de Adoção

**1. Acesse a raiz direcional do projeto a ser adequado:**
```bash
cd ~/caminho/para/seu/projeto-em-andamento
```
*O que faz:* Navega até o repositório que precisa receber as travas e o manifesto de segurança.

**2. Execute o Scaffolder de Governança do Dev-Workspace:**
```bash
~/dev-workspace/scripts/adopt_governance.sh .
```
*O que faz:* Roda o script da plataforma apontando para o diretório atual (`.`). Ele proativamente confere se há repositório Git, instala silenciosamente o núcleo do pre-commit via Python, injeta as regras de verificação `.pre-commit-config.yaml`, traz o Entrypoint (`Makefile`) e copia o manifesto `AGENTS.md`.

**3. Valide o "Shift-Left Security" (Linting Inicial):**
```bash
make lint
```
*O que faz:* Executa as baterias de verificação em todos os arquivos históricos do projeto. Corrige massivamente espaços vazios indesejados, padroniza as quebras de linha (`EOF`) e avalia chaves/credenciais expostas no código de forma retroativa.

**4. Comite o novo escudo da Plataforma:**
```bash
git add .
git commit -m "chore: adocao dos padroes dev-workspace de governanca"
```
*O que faz:* Salva todo o maquinário de prevenção e formatação e estabelece um ponto de corte (baseline) de qualidade pro futuro.

### 🌟 O que muda e o que melhora no projeto adequando-o?

- **Prevenção de Desastres na Origem:** Com a injeção do pre-commit local, a partir de agora chaves AWS, tokens de API ou falhas de IaC (via TFLint/Shellcheck) impedirão você (ou a sua automação) de realizar um `git commit` ruim.
- **Auto-Cura de Formatações Bobas:** Erros entre Windows (CRLF) e Unix (LF), ou espaços em branco sobrando em dezenas de arquivos, quebrando diffs visuais em repositórios, são agora higienizados automaticamente ao comitar.
- **Entrypoint Único (`Makefile`):** Fim dos longos scripts manuais documentados só "na cabeça do desenvolvedor". Se vai validar, é `make lint`. Se quer preparar algo, há um target central e universal, ajudando Agentes a saberem de modo previsível onde orquestrar ações.
- **Respeito dos Agentes (God Prompting):** O artefato injetado (`AGENTS.md`) serve como uma diretriz severa para que nenhuma IA operando dentro daquele projeto "invente a roda", escrevendo YAMLs e Terraform que ignorem nossos padrões de Zero-Trust e Idempotência.

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
