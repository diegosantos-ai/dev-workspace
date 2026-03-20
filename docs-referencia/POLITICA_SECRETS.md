# Política de Secrets e Segurança (Ticket 2.5)

Para atuar na vanguarda do modelo `Shift-Left Engine`, as regras desta arquitetura definem as amarras inegociáveis para o manuseio de credenciais, certificados e *tokens* pessoais do desenvolvedor.

## 1. Zero Tolerância ao Versionamento "Em-claro" (Hardcoded)
Sob NENHUMA hipótese serão aceitos valores transacionais armazenados diretamente nas passagens de estado do git:

* Sem inserção na construção do `provider.tf`.
* Sem embutir nas *tasks* declaradas no playbook `ansible/local-setup.yml`.
* Sem estipular *tokens* estáticos injetados na documentação interativa ou relatórios de bash (`rotinas-devops`).
* Sem repasses via `curl -H "Authorization: Bearer <token>"` soltos nos *scripts*.

## 2. A Barreira Ativa do Commit
A garantia técnica desta proibição assenta-se sobre o utilitário **Gitleaks** em conjunto com a automação `.pre-commit`.
Todos os mantenedores terão, pós-setup, sua esteira avaliada no comando `git commit`. Se o linter pegar assinaturas ou strings literais suspeitas (`AWS_.*`, chaves `RSA`, conexões URI de `Postgres` contendo _password_:), o commit falhará de forma irreversível até o expurgo do código ou justificação correta via injeção parametrizada.

## 3. Onde os Secrets Vivem (Camada Física)
Se eles não vão ao git, devem repousar num gestor ou estado efêmero seguro da máquina subjacente à qual foi dado o Setup.
Recomendamos e suportamos as seguintes saídas:

1. **Gestores de Cofres de CLI:** (Padrão ouro). Abstrair sua adoção utilizando comandos em passagens para o cofre GPG gerenciado via `pass` (por exemplo, exportando para o zsh aliando `export AWS_ACCESS=$(pass aws/personal_access)`).
2. **Isolamento Modular Variável (`.env`):** Como definido no manifesto `PADRAO_ENV_VARS.md`, inserindo pontualmente sua instância local restrita em `gestao-centralizada-agents/.env`.
3. **Plataformas de CI Distribuídas:** Github Actions operam baseados sob *Secrets Repository/Organization*. É proibido espelhar *outputs* verbosos de variáveis dinâmicas rodando em Action runners na string de echo `${{ secrets.AWS_KEY }}`.

## 4. Auditoria de Contaminação
No evento raro e severo de bypass intencional, um token acrítico subido no log persistente ou branch demandará a operação purista (BFG Repo-Cleaner / `git filter-repo`) associada obrigatoriamente à rotação das chaves providas no cloud-provider em até MÁXIMO de 1 hora comercial.