### Definicao do projeto

- Tipo: `infraestrutura com Terraform`
- Infra-as-Code na AWS: Usar Terraform para subir toda a rede (VPC, Subnets, Security Groups) e uma instância EC2 rodando um servidor web. Tudo via código.
- O que resolve? Evita o 'clica-clica' manual no painel da cloud.
- Na pratica: Cria, altera e destrui servidores e redes usando apenas código
- Para que este projeto existe? `Demonstrar capacidade técnica de automatizar, versionar e gerenciar recursos de nuvem de forma declarativa e escalavel, simulando cenários reais de engenharia DevOps.

### Objetivos Principais do Projeto

- Demonstrar Automacao: Mostrar que posso criar, alterar e destruir insfraestrutura (VMs, redes, bancos de dados) sem usar o console web do provedor de nuvem (AWS)
- Seguir boas praticas (IaC): Utilizar codigo declarativo, modular e organizado, evitando hard-coding dfe valores e facilitando a manutencao.
- Prova de conhecimento em modulos: Estruturar o codigo em modulos reutilizaveis, demonstrando como escalar infraestruturas.
- Gerenciamento de estado: Mostrar entendimento sobre o arquivo de estado (terraform.tfstate) e o uso do backend remoto para colaboracao em equipe.
- GitOps/CI/CD: Integrar o Terraform com pipelines (Github Actions) para aplicar as mudanças de infraestrutura automaticamente após um git push.

