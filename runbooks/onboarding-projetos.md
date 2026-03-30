# Guia de Operação e Início de Projetos (Platform Engineering)

## Objetivo
Você preparou sua máquina no `dev-workspace`. A dúvida daqui em diante é simples: qual `make` usar e em qual pasta estar.

Regra direta:

- Em `~/labs/dev-workspace`, você usa o `make` da plataforma.
- Em `~/labs/projetos/meu-projeto`, você usa o `make` do projeto.
- Você não copia `Makefile` manualmente.
- Você não continua usando o `make` do `dev-workspace` para desenvolver dentro de outro repositório.

Puxar as regras da sua plataforma para qualquer pasta nova ou antiga não deve exigir copiar/colar blocos longos de arquivo no VS Code. Existe um fluxo _100% automatizado_.

## O Fluxo Único Baseado em Script

Ao invés de sofrer copiando Makefiles e documentações de IA, a plataforma possui o fluxo "Adopt". Ele converte sua pasta num repositório governado.

### 1. Execute a Adoção a partir do `dev-workspace`

Primeiro, fique na raiz do `dev-workspace`:

```bash
cd ~/labs/dev-workspace
make adopt TARGET=~/labs/projetos/meu-novo-projeto
```

A automação fará o seguinte:

- Vai checar se você está usando um ambiente `.git` (obrigatório).
- **Copia o Pipeline**: Copiará automaticamente o `.pre-commit-config.yaml` escondido.
- **Injeta a Governança de Agentes**: Ele mesmo cria (ou injeta o rodapé de comportamento restritivo) no `AGENTS.md`.
- **Cria o Target de Automação**: Gera um `Makefile` limpo padrão para te livrar da digitação constante.
- **Estruturação de Base de Refatoração**: Vai automaticamente dar um _mkdir_ em `docs/`, fazer setup e limpeza de segredos gerando o seu `.env.example`, gerando ainda o `.gitignore` para bloquear commit de artefato denso e secrets reais.
- **Bloqueio de Fogo (Shift-left)**: Realiza a carga final local executando a fixação de `pre-commit install`.

### 2. Depois da adoção, mude para o projeto

Depois que a governança foi aplicada, o fluxo muda de lugar:

```bash
cd ~/labs/projetos/meu-novo-projeto
make lint
```

Daqui em diante, o `make` é o do projeto. O `dev-workspace` volta a ser usado apenas para tarefas de plataforma, máquina e governança.

## Passo a Passo Pós-Adoção (Rotina de Limpeza)

Sua pasta acabou de engolir a inteligência inteira da plataforma com um só comando. Certo, e agora?

### Identificou erro de lint ao tentar fazer commit?
Isso seria muito normal em um projeto que já estava preenchido. Secreções soltas (chumbadas) e senhas vão acionar o alarme do gitleaks instantaneamente.

1. Use o repositório modelo gerado `.env.example` para passar qual o nome da credencial que deveria estar externalizada.
2. Troque as senhas vazadas do código por ponteiros de injeção de ambiente (`os.environ`, `import.meta.env`, etc).
3. Caso a arquitetura mude, suba as proibições específicas sob o topo visual do arquivo `AGENTS.md` (no próprio alvo).

### Entrypoint Declarado (O seu README)
Evite redigir um "manual" novo na descrição da sua branch. O modelo espera que você entre e escreva as interfaces únicas pelo arquivo *Make* e simplesmente refira em seu `README.md` a execução limpa de:

```bash
make lint
make dev
```
