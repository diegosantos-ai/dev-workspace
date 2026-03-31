# cloud-setup

## Propósito

Módulo de provisionamento de instâncias VPS e infraestrutura de rede remota. Contém configurações Terraform para provedores externos (AWS e OVH), usadas para subir ambientes de laboratório ou staging remotos.

## Quando Usar

- Para provisionar uma nova instância VPS em AWS ou OVH.
- Para recriar ou destruir ambientes de laboratório remoto.
- Para configurar rede, firewall ou DNS de um servidor externo.

## Dependências

- Terraform instalado (provisionado via `make bootstrap`).
- Credenciais de provedor configuradas via variáveis de ambiente (`AWS_ACCESS_KEY_ID`, `OVH_APPLICATION_KEY`, etc.) — nunca hardcoded.
- Acesso SSH ao host remoto para operações pós-provisionamento.

## Estrutura

```text
cloud-setup/
├── terraform-aws-base/   # Blueprint para instâncias AWS EC2
└── terraform-ovh-base/   # Blueprint para instâncias OVH VPS
```

## Relação com o Core

Módulo independente. Não interfere no bootstrap local. Consome os `templates/` do repositório como base arquitetural. O estado do Terraform (`.tfstate`) nunca é versionado — deve ser gerenciado via backend remoto (S3, Terraform Cloud) ou localmente fora do repositório.

## Entrypoint Local

Não há target dedicado no `Makefile` raiz para este módulo. Operação direta via Terraform:

```bash
cd cloud-setup/terraform-aws-base
terraform init
terraform plan
terraform apply
```

Siga os runbooks em `runbooks/` para o procedimento completo de provisionamento.
