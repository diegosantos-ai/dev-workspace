# ADR 0007: Provisionamento Multi-Cloud VPS

## Status
Aceito

## Contexto
Para os laboratórios e testes que necessitam de exposição externa (VPS e simulações de Staging), manter configurações ad-hoc pela interface web dos provedores viola a idempotência do workspace. Precisávamos de um mecanismo que garantisse que os servidores remotos pudessem ser recriados do zero sob a mesma governança do `dev-workspace`.

## Decisão
Adotamos a segregação de blueprints via **Terraform** no módulo `cloud-setup`.
- Os provedores primários definidos são **AWS** (para instâncias baseadas no ecossistema Amazon) e **OVH** (para instâncias de custo otimizado na Europa).
- Cada provedor possui sua árvore isolada (`terraform-aws-base` e `terraform-ovh-base`) para evitar state locks acidentais e mistura de providers complexos.
- Os módulos devem separar logicamente a rede, segurança e computação, permitindo reuso em ambientes `dev` e `prod`.

## Consequências
- **Positivas:** Infraestrutura externa testável, com logs de `terraform plan` e segurança auditada pelo `pre-commit` (tfsec, tflint) da máquina do engenheiro.
- **Negativas:** Requer a injeção estrita de credenciais exportadas localmente para os providers e gerenciamento manual do remote state (já que o workspace não commita arquivos `.tfstate`).
