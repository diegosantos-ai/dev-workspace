# Estrutura Oficial do Repositório (Ticket 1.1)

Este documento define a árvore oficial do workspace, as responsabilidades de cada domínio principal e também classifica partes do projeto que não fazem parte do padrão final arquitetural.

## 1. Estrutura Oficial (Core)

Estes diretórios e arquivos compõem a base funcional adotável do projeto:

* **`ansible/`**
  * **Função:** Automação da máquina e setup local. Responsável pela instalação de pacotes e provisionamento base (ex: `local-setup.yml`).
* **`docs-referencia/`**
  * **Função:** Concentrar a documentação arquitetural, padrões de design e histórico de Decisões Técnicas (ADRs).
* **`dotfiles/`**
  * **Função:** Versionamento das configurações do sistema (shell, vscode, etc) integradas através de `stow`.
* **`gestao-centralizada-agents/`**
  * **Função:** Governança local de agentes de IA. Inclui o registro das personas, restrições e as Skills (via protocolo MCP).
* **`sanidade-ambiente/`**
  * **Função:** Rotinas que garantem a validação, auditoria de dependências essenciais instaladas e testes isolados sobre o estado da máquina.
* **`templates/`**
  * **Função:** Infraestrutura como Código. Concentra os templates nativos do Terraform (módulos agnósticos e divisões de ambiente).
* **`rotina-devops/`**
  * **Função:** Scripts e templates que regulamentam a linha diária de trabalho operacional, com ênfase na automação de worklogs.

**Principais Arquivos Raiz:**
* **`Makefile`**: Interface e ponto de entrada orquestrador oficial de comandos.
* **`AGENTS.md`**: Manifesto principal exigindo conformidade de IAs locais.
* **`.pre-commit-config.yaml`**: Trava ativada de verificação e pipeline estático (Shift-Left).
* **`README.md`**: Abertura formal do repositório.

## 2. Componentes Mistos ou Pessoais

Estes diretórios agregam valor mas representam adaptações momentâneas ou estilo de operação pessoal:

* **`playbooks/`** (Misto)
  * Checklist manuais baseados em texto. São guias de uso de workflow particular e, dependendo do conteúdo, servem à rotina ou à infraestrutura.

## 3. Ambíguos, Legados ou fora da estrutura oficial

Estes compenentes estão poluindo, despadronizados ou contêm acoplamentos inadequados e devem ou sofrer refatorações, relocações, exclusões ou permanecer marcados como não-oficial:

* **`teste-python/` (Ambíguo / Órfão)**
  * Hospeda script Bash `check_devops_env.sh` que faz a mesma atribuição que a pasta `sanidade-ambiente/`. *Deve ser consolidado ou descartado futuramente.*
* **`rotina-devops.md` (Duplicado)**
  * Arquivo contendo premissas teóricas na pasta raiz, cujo propósito colide frontalmente com `rotina-devops/README.md`.
* **`backup-setup.tar.gz` (Anti-padrão / Pessoal)**
  * Dependência comprimida empurrada sobre o diretório `home` durante o playbook Ansible sem visibilidade de versionamento. *Estado oculto não suportado por padrão de referência.*
* **`diagnostico-projeto/` (Temporário / Transicional)**
  * Diretório gerado unicamente para comportar a migração em prol da reprodutibilidade. Não é componente entregável persistente para terceiro.

---
**Nota:** Componentes situados fora do estrato "Oficial (Core)" não deverão ser considerados "Referência de Mercado", devendo ser sanados para adoção externa.
