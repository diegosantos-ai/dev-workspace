# ADR 0002: Padrão Multi-Ambientes para Terraform (Clean Workspaces)

## Status
Aceito

## Contexto
O código de infraestrutura (AWS e OVH) possuía os recursos de módulo e declarações finais mesclados na raiz, causando misturas de estados `.tfstate` em testes locais e um isolamento precário onde Dev e Prod tocava nos mesmos arquivos, propiciando acidentes.

## Decisão
Decidimos adotar uma arquitetura de Terraform baseada em segregação lógica estéril e separação por pastas de estado:
1. `modules/`: Conterá apenas a lógica do recuso puro (ex: `compute`, sem valores diretos, sem `.tfstate`).
2. `envs/<environment>/`: As pastas como `dev/` ou `prod/` instanciam o Provider AWS, usam o remote backend do S3/DynamoDB e chamam os módulos com os dados de `terraform.tfvars`.

## Consequências
- **Positivas:** Redução massiva do raio de explosão (Blast Radius). Aplicar o terraform em "Dev" tem risco zero de afetar "Prod", mesmo localmente. O código fica enxuto seguindo padrão D.R.Y (Don't Repeat Yourself).
- **Negativas:** Requer navegar entre `modules/` e `envs/` durante manutenções mais extensas em recursos.
