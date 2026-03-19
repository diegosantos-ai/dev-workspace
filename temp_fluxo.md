
## 🔄 Como a Plataforma Funciona na Prática? (O Fluxo de Vida do Dev/DevOps)

Esta arquitetura foi desenhada para resolver os maiores atritos do ciclo de vida de desenvolvimento: configurar máquina, garantir que está tudo seguro antes de codar, e manter rastreabilidade em IA.

Aqui está a jornada diária padrão guiada pela plataforma:

1. **Bootstrap & Inicialização (`make setup`):**
   *(Feito 1x por máquina)*. O usuário roda o setup, e o Ansible assume o controle baixando binários do APT/Snap (Terraform, Docker, Kubectl) e aplicando `.dotfiles` pré-aprovados globalmente.
2. **O Acordar do Sistema (`make morning` / `make env-check`):**
   *Todo dia ao iniciar o trabalho*. A esteira de Segurança **Shift-Left Operacional** (Sanidade-Ambiente) verifica se os Daemons (Docker/Git) e Libs obrigatórias estão ativas. Se o daemon falhar, ela barra o engenheiro de prosseguir, impedindo "falsos positivos" cruéis em tempo de deploy.
3. **Desenvolvimento Orquestrado (Logs & MCP):**
   *A hora do código.* O engenheiro usa `make day-start` para rastrear no Git tudo que construirá no dia. Ele não trabalha sozinho: a Gestão de Agentes via VS Code injeta contexto, impedindo erros como tokens hard-codados nos templates Terraform.
4. **Governança Pós-Código (`make lint`):**
   *Antes de ir pra nuvem.* A camada `pre-commit` impede arquivos de subirem desformatados, caça segredos (*Gitleaks*) e impede shell scripts de rodarem vulneráveis (*Shellcheck* puro em Python evitando bloqueio de Docker no CI).

