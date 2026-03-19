# Sanidade do Ambiente

Módulo responsável por garantir a saúde, configuração, segurança e resiliência do ambiente de trabalho DevOps.

## Arquitetura do Módulo

Avaliando o princípio de Separação de Preocupações, este módulo divide-se em:

- `scripts/`: Contém a lógica de validação executável.
  - `daily-check.sh`: Focado em inicialização rápida (fricção zero).
  - `env-audit.sh`: Focado em troubleshooting e varredura profunda (compliance).
- `reports/`: Armazena saídas pontuais e logs das auditorias completas (ignorados no tracking de versão da raiz se necessário futuramente).
- `templates/`: Mantém a estrutura de formatação exigida para saídas (Ex: modelo de relatório Markdown ou JSON).
