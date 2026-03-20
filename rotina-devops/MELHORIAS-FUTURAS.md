# Backlog de Melhorias Futuras (Rotina DevOps)

Este documento registra ideias de evolução para o sistema de worklog.
**Regra de Ouro (Filtro de Qualidade):** Nenhuma sugestão aqui pode ser apenas "maquiagem" visual ou adicionar complexidade desnecessária. Toda melhoria deve reduzir o esforço cognitivo e manter a resiliência (idempotência e portabilidade) dos scripts, sem engessar a rotina do engenheiro.

---

## 1. Melhorias Avaliadas (Aprovadas no Filtro)

### [M-01] Auto-abertura do arquivo gerado no Editor
- **O que é:** Ao final do script `worklog-start.sh` (e futuramente do `add` e `close`), invocar a abertura automática do arquivo gerado via `$EDITOR` ou `code`.
- **Por que não é maquiagem?** Reduz a fricção e o tempo de transição. O objetivo de rodar o setup pelo terminal é poder digitar no painel logo em seguida. Ter que caçar o arquivo na árvore de diretórios quebra o fluxo de trabalho "focado".
- **Esforço:** Baixíssimo (Adicionar `code "$DAILY_FILE"` ou fallback para variável `$EDITOR`).

### [M-02] Validação Simples de Projetos (`projects.yaml`)
- **O que é:** Permitir que, no momento dos prompts, o usuário aperte `TAB` (via `fzf` ou auto-complete nativo bash) ou tenha sugestões de projetos baseados no `projects.yaml`.
- **Por que não é maquiagem?** Padronização de logs. Se um dia o usuário digita "DevOps", no outro "dev-ops", o script de fechamento semanal (`worklog-weekly.sh`) vai sofrer ou entregar métricas furadas/gaps. Mapear do YAML garante consolidação perfeita.
- **Esforço/Atenção:** Só entra se o fallback for forte. Se a máquina não tiver `yq` ou `fzf`, o script deve simplesmente voltar ao input normal, sem quebrar ou exigir downloads complexos.

---
*Nota: A cada nova task na construção da \`rotina-devops\`, novas ideias brutas serão filtradas e descritas aqui.*
### [M-03] Modo Interativo no worklog-add.sh
- **O que é:** Permitir a chamada do script `worklog-add.sh` sem passar os 5 parâmetros via CLI, engatilhando um wizard (perguntas e respostas no terminal) igual ao `start` e `close`.
- **Por que não é maquiagem?** Formatar parâmetros numa CLI (abrir/fechar aspas, ordem correta) quebra o flow cognitivo. Se o engenheiro estiver com pressa, ele só digita o comando seco e vai respondendo as perguntas "passo-a-passo".
- **Esforço:** Baixo. Uma condicional para `$# == 0` que ativa um bloco de `read -p`.

### [M-04] Extrator Automático de Highlights para o Semanal
- **O que é:** Ao gerar o `worklog-weekly.sh`, em vez de apenas sugerir que o usuário leia os logs diários, fazer um script bash extrair dinamicamente a seção "1. Plano do Dia" e "3. Fechamento" dos últimos 5/7 logs e injetar como um "Rascunho a ser Reescrito" no template semanal.
- **Por que não é maquiagem?** Isso remove 90% da frustração de sexta-feira à tarde ("O que eu fiz na terça mesmo?"). Ler o próprio log já é bom, mas ter um bloco condensado que só exige edição e exclusão (em vez de reescrita total a partir de janelas separadas) acelera radicalmente o fechamento da semana.
- **Esforço:** Médio. Requer uso preciso do `awk`/`sed` para caçar parágrafos baseados em anchors entre os arquivos.
