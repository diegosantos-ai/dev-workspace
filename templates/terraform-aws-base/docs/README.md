# Projeto 02 — AWS Web Infrastructure with Terraform

Provisionamento de infraestrutura básica na AWS com Terraform para hospedagem de serviço web simples, aplicando práticas de IaC, organização progressiva, validação, automação e rastreabilidade.

![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![EC2](https://img.shields.io/badge/Amazon_EC2-Compute-FF9900?style=for-the-badge&logo=amazon-ec2&logoColor=white)
![VPC](https://img.shields.io/badge/Amazon_VPC-Networking-146EB4?style=for-the-badge&logo=amazonaws&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Server-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Git](https://img.shields.io/badge/Git-Versionamento-F05032?style=for-the-badge&logo=git&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Status](https://img.shields.io/badge/status-em%20valida%C3%A7%C3%A3o%20final-blue?style=for-the-badge)

## Visão geral

Este projeto provisiona, via Terraform, uma infraestrutura básica na AWS para hospedar um serviço web simples, aplicando práticas de Infraestrutura como Código (IaC), organização modular, gerenciamento de estado remoto, validação automatizada e entrega controlada.

A proposta simula um cenário real em que uma equipe precisa publicar rapidamente um serviço web institucional de forma padronizada, reproduzível e rastreável, evitando a criação manual de recursos no console da AWS.

---

## Objetivo principal

Provisionar uma infraestrutura básica na AWS para hospedar um serviço web simples, demonstrando capacidade de:

- modelar infraestrutura como código
- organizar a solução por módulos
- gerenciar state remoto com segurança
- automatizar validações com CI
- automatizar deploy com CD controlado

---

## Case do projeto

Uma equipe precisa publicar um serviço web institucional simples na AWS de forma rápida, padronizada e reproduzível.

Em vez de criar manualmente VPC, subnets, regras de firewall e instâncias EC2 no console, a infraestrutura é provisionada integralmente com Terraform, permitindo versionamento, revisão, reaplicação e maior previsibilidade operacional.

---

## Escopo do projeto

A infraestrutura contempla:

- VPC customizada
- subnet pública
- Internet Gateway
- route table pública
- rota default para internet
- associação da route table à subnet pública
- security group para serviço web
- acesso HTTP público
- acesso SSH restrito por IP
- instância EC2 com IP público
- `user_data` para publicação automática de serviço web simples
- outputs para consulta e validação da infraestrutura

---

## Tecnologias utilizadas

- Terraform
- AWS
- Amazon VPC
- Amazon EC2
- Subnet
- Internet Gateway
- Route Table
- Security Groups
- Linux
- HTTP
- Git
- GitHub
- GitHub Actions

---

## Região e convenções do projeto

### Região AWS
- `us-east-1`

### Convenção de nomes
- `p02-dev-<recurso>`

### Tags padrão
- `Project = projeto-02`
- `Name = nome-do-recurso`
- `Environment = dev`
- `ManagedBy = Terraform`
- `Owner = DiegoSantos`

---

## Estrutura atual do projeto

```text
.
├── backend.tf
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── terraform.tfvars.example
├── network.tf
├── security.tf
├── ec2.tf
├── infra
│   └── backend
├── modules
│   ├── network
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── .github
│   └── workflows
│       ├── terraform-ci.yml
│       └── terraform-cd.yml
├── README.md
└── .gitignore
```

## Responsabilidade dos arquivos

| Arquivo/Diretório | Descrição |
|---|---|
| `backend.tf` | Configuração do backend remoto S3 do Terraform. |
| `main.tf` | Orquestra os módulos do projeto e registra os blocos `moved` da refatoração. |
| `provider.tf` | Configuração do provider AWS. |
| `variables.tf` | Declaração das variáveis de entrada do projeto no root module. |
| `outputs.tf` | Saídas finais expostas pelo root module. |
| `terraform.tfvars` | Valores locais reais utilizados na execução. |
| `terraform.tfvars.example` | Exemplo de preenchimento das variáveis. |
| `infra/backend` | Bootstrap do backend remoto do Terraform. |
| `modules/network` | Recursos de rede: VPC, subnet pública, Internet Gateway, route table, rota default e associação. |
| `modules/security` | Recursos de segurança: security group e regras de entrada e saída. |
| `modules/compute` | Recursos de computação: busca de AMI e provisionamento da instância EC2. |
| `.github/workflows/terraform-ci.yml` | Workflow de CI para `fmt`, `validate` e `plan`. |
| `.github/workflows/terraform-cd.yml` | Workflow de CD para `terraform apply` controlado. |
| `network.tf`, `security.tf`, `ec2.tf` | Arquivos legados mantidos apenas como referência da refatoração, com recursos migrados para módulos. |
| `README.md` | Documentação principal do projeto. |

---

## Arquitetura da solução

A arquitetura do projeto foi estruturada para separar responsabilidades e permitir evolução progressiva da infraestrutura.

O root module atua como camada de orquestração, concentrando:

- chamadas dos módulos
- variáveis globais
- outputs finais
- blocos `moved` utilizados na refatoração segura da infraestrutura

A implementação foi dividida em três módulos:

- `modules/network` — recursos de rede, como VPC, subnet pública, Internet Gateway, route table e associação
- `modules/security` — security group da aplicação e regras de entrada e saída
- `modules/compute` — consulta de AMI e provisionamento da instância EC2

Além da estrutura modular, o projeto utiliza:

- backend remoto em S3 para gerenciamento do state do Terraform
- workflow de CI no GitHub Actions para `fmt`, `validate` e `plan`
- workflow de CD no GitHub Actions para `terraform apply`
- deploy controlado com gatilho manual (`workflow_dispatch`) e restrição à branch `main`

Essa arquitetura foi adotada para melhorar organização, rastreabilidade, reprodutibilidade e segurança operacional do projeto.

---

## Status do projeto

### Fases concluídas

- Fase 1 — Definição e base do projeto
- Fase 2 — Estruturação base do Terraform
- Fase 3 — Provisionamento da rede
- Fase 4 — Segurança de acesso
- Fase 5 — Provisionamento da EC2
- Fase 6 — Refino do projeto
- Fase 7 — Modularização
- Fase 8 — Estado remoto
- Fase 9 — CI/CD com GitHub Actions

### Fase atual

Fase 10 — Documentação e validação final

---

## Infraestrutura provisionada até o momento

### Rede

- `aws_vpc.main`
- `aws_subnet.public`
- `aws_internet_gateway.main`
- `aws_route_table.public`
- `aws_route.public_internet_access`
- `aws_route_table_association.public`

### Segurança

- `aws_security_group.web`
- `aws_vpc_security_group_ingress_rule.web_http`
- `aws_vpc_security_group_ingress_rule.web_ssh`
- `aws_vpc_security_group_egress_rule.web_all_outbound`

### Computação

- `aws_instance.web`

---

## Outputs disponíveis

- `aws_region`
- `environment`
- `project_name`
- `owner`
- `vpc_id`
- `public_subnet_id`
- `internet_gateway_id`
- `public_route_table_id`
- `web_security_group_id`
- `web_instance_id`
- `web_instance_public_ip`
- `web_instance_public_dns`

---

## Pré-requisitos

Antes de executar o projeto, é necessário ter:

- Terraform instalado
- AWS CLI instalada e configurada
- credenciais AWS válidas no ambiente local
- um Key Pair já existente na AWS na região `us-east-1`
- permissões suficientes para criar recursos de rede, segurança e EC2

---

## Configuração do projeto

### 1. Clonar o repositório

```bash
git clone <url-do-repositorio>
cd projeto-02-terraform-cloud
```

### 2. Revisar o arquivo de exemplo

Use o arquivo `terraform.tfvars.example` como referência para preencher o `terraform.tfvars`.

### 3. Criar ou ajustar o `terraform.tfvars`

Exemplo:

```hcl
aws_region         = "us-east-1"
project_name       = "projeto-02"
environment        = "dev"
owner              = "DiegoSantos"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
public_subnet_az   = "us-east-1a"
ssh_allowed_cidr   = "SEU_IP_PUBLICO/32"
instance_type      = "t3.micro"
key_pair_name      = "diego-key"
```

> O valor de `key_pair_name` deve ser o nome exato de um Key Pair já existente na AWS na região `us-east-1`.

---

## Fluxo de execução

A execução padrão do projeto segue esta ordem:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform state list
```

---

## Fluxo operacional recomendado

### Antes de alterar

- revisar contexto atual do projeto
- confirmar branch correta
- verificar `git status`
- validar estado atual da infraestrutura
- revisar impacto antes de aplicar mudanças

### Durante a execução

- rodar `terraform fmt`
- rodar `terraform validate`
- ler o `terraform plan`
- aplicar somente após validação do comportamento esperado

### Após a execução

- revisar `terraform output`
- revisar `terraform state list`
- validar recursos no console AWS
- validar entrega funcional do serviço

---

## CI/CD com GitHub Actions

A partir da Fase 9, o projeto passou a contar com automação de validação e entrega controlada usando GitHub Actions.

### Workflow de CI

O workflow de CI executa automaticamente em:

- `push` para `main`
- `push` para `feature/**`
- `pull_request` para `main`

Esse workflow realiza dois jobs:

#### Terraform Validate
Validação estrutural do projeto sem depender do backend remoto:

```bash
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
```

#### Terraform Plan
Validação da infraestrutura com backend remoto e provider AWS reais:

```bash
terraform init
terraform plan -input=false
```

Esse job utiliza autenticação AWS e variáveis do projeto configuradas no GitHub Actions.

### Workflow de CD

O workflow de CD executa o deploy da infraestrutura com:

```bash
terraform init
terraform apply -auto-approve -input=false
```

O deploy foi implementado com gatilho manual (`workflow_dispatch`) e restrição de execução apenas na branch `main`.

Esse workflow não é executado automaticamente após o CI. O `terraform apply` foi mantido sob disparo manual para aumentar controle e reduzir risco operacional.

Essa decisão foi adotada para manter o `terraform apply` sob controle humano explícito, reduzindo risco operacional em alterações reais na AWS.

### Secrets utilizados

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Variáveis utilizadas

- `TF_VAR_aws_region`
- `TF_VAR_project_name`
- `TF_VAR_environment`
- `TF_VAR_owner`
- `TF_VAR_ssh_allowed_cidr`
- `TF_VAR_key_pair_name`

### Observação de manutenção

Durante a execução dos workflows, o projeto apresentou warning relacionado ao uso de `hashicorp/setup-terraform@v3` por conta da transição de runtime do GitHub Actions de Node.js 20 para Node.js 24.

Esse ponto não bloqueia a execução atual, mas deve ser acompanhado em futuras manutenções do projeto.

---

## Evidências de execução

Ao longo do projeto, a infraestrutura foi validada com execução real na AWS e com automação via GitHub Actions.

### Evidências técnicas consolidadas

- `terraform validate` executado com sucesso após refatorações e modularização
- `terraform plan` final validando integridade da infraestrutura sem recriação indevida
- backend remoto S3 inicializado e utilizado com sucesso
- workflow de CI executando com sucesso:
  - `terraform init -backend=false`
  - `terraform fmt -check -recursive`
  - `terraform validate`
  - `terraform plan -input=false`
- workflow de CD executando com sucesso:
  - `terraform init`
  - `terraform apply -auto-approve -input=false`

### Evidência final do deploy automatizado

Na execução final do workflow de CD, o `terraform apply` foi executado com sucesso no GitHub Actions e retornou:

```bash
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

Esse resultado confirmou que:

- o backend remoto estava íntegro
- as credenciais AWS estavam corretas
- a automação de deploy estava funcional
- a infraestrutura provisionada estava convergente com a configuração do código

### Evidências funcionais

A entrega também foi validada por meio de:

- outputs do Terraform
- leitura do state
- inspeção no console AWS
- publicação do serviço web na instância EC2

---

## Critérios de validação do projeto

A validação do projeto não termina no `terraform apply`.

Cada fase deve ser considerada concluída apenas quando houver evidência técnica e funcional da entrega.

### Validações padrão

- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply`
- `terraform output`
- `terraform state list`
- validação no console AWS

### Validação funcional da EC2

- instância criada com sucesso
- subnet correta
- security group correto
- IP público atribuído
- serviço web respondendo externamente

### Exemplo de validação HTTP

```bash
curl http://IP_PUBLICO
```

---

## Exemplo de resultado esperado

Após o provisionamento da EC2, espera-se que o serviço responda algo semelhante a:

```html
<html>
  <head>
    <title>Projeto 02</title>
  </head>
  <body>
    <h1>Projeto 02 - AWS Web Infrastructure with Terraform</h1>
    <p>Servico web publicado com sucesso via Terraform.</p>
    <p>Environment: dev</p>
    <p>Owner: DiegoSantos</p>
  </body>
</html>
```

---

## Decisão de arquitetura

A principal decisão arquitetural do projeto foi evoluir de uma estrutura flat no root module para uma organização modular por domínio funcional.

Essa mudança foi adotada para:

- reduzir acoplamento entre componentes
- melhorar legibilidade e manutenção
- permitir reuso
- preparar o projeto para backend remoto, CI/CD e colaboração futura

A refatoração foi executada com preservação de state por meio de blocos `moved`, evitando destruição e recriação indevida dos recursos existentes.

### Resultado da decisão

- rede isolada em `module.network`
- segurança isolada em `module.security`
- computação isolada em `module.compute`
- root module simplificado como camada de orquestração

---

## Boas práticas aplicadas

- provisionamento via Infraestrutura como Código
- separação de responsabilidades por arquivo e por módulo
- leitura de `terraform plan` antes de `apply`
- uso de variáveis e outputs para legibilidade e reuso
- controle de acesso SSH com restrição por IP
- validação terminal + console AWS
- versionamento por branch e fase
- backend remoto para state
- automação de validação com CI
- automação de deploy com CD controlado
- documentação contínua do projeto

---

## Cuidados importantes

- não versionar `terraform.tfvars`
- não versionar arquivos de state
- não armazenar credenciais AWS em arquivos do projeto
- validar mudanças antes de aplicar em ambiente
- tratar recursos de segurança com cuidado, especialmente SSH
- destruir recursos ao final do uso se o objetivo for apenas laboratório, evitando custos desnecessários

---

## Limpeza do ambiente

Caso seja necessário remover os recursos provisionados:

```bash
terraform destroy
```

> Execute com atenção e somente quando tiver certeza de que o ambiente pode ser removido.

---

## Próximos passos

A próxima etapa do projeto é a **Fase 10 — Documentação e validação final**, com foco em:

- consolidar a documentação técnica do projeto
- registrar evidências da execução
- revisar arquitetura, decisões e aprendizados
- reforçar a apresentação do projeto como item de portfólio
- validar reprodutibilidade e encerramento técnico
- executar teardown controlado da infraestrutura

---

## Autor

**Diego Santos**

Projeto desenvolvido como prática de portfólio com foco em evolução técnica em DevOps, Cloud e Infraestrutura como Código.
