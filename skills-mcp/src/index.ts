import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import * as dotenv from "dotenv";
import axios from "axios";

// Carrega as variáveis do ~/.agents-env (que configuramos na Fase 1) ou do ambiente do sistema
dotenv.config({ path: `${process.env.HOME}/.agents-env` });

// O Servidor MCP atua como uma interface padronizada entre a IA e nosso Ferramental
const server = new Server(
  {
    name: "devops-mcp-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

/**
 * 1. REGISTRO DE FERRAMENTAS:
 * Define quais funções o LLM (Copilot/Claude) "enxerga" quando se conecta.
 */
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "trigger_n8n_workflow",
        description: "Dispara um workflow do n8n remotamente via Webhook, repassando os parâmetros necessários.",
        inputSchema: {
          type: "object",
          properties: {
            webhookPath: {
              type: "string",
              description: "O final da URL do Webhook do n8n (ex: build-pipeline-prd)",
            },
            payload: {
              type: "object",
              description: "JSON contendo as variáveis exigidas pelo workflow",
            },
          },
          required: ["webhookPath"],
        },
      },
      {
        name: "check_qdrant_status",
        description: "Verifica a integridade da memória vetorial e do host local Qdrant",
        inputSchema: {
          type: "object",
          properties: {},
        },
      }
    ],
  };
});

/**
 * 2. EXECUÇÃO DE FERRAMENTAS:
 * Contém a lógica pesada de quando o LLM realmente "Clica" na ferramenta descrita acima.
 */
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  // ==== TOOL 1: INTEGRAÇÃO n8n ====
  if (name === "trigger_n8n_workflow") {
    const { webhookPath, payload = {} } = args as any;
    const n8nUrl = process.env.N8N_URL || "https://n8n.nexobasis.com.br";

    try {
      const fullUrl = `${n8nUrl}/webhook/${webhookPath}`;
      const response = await axios.post(fullUrl, payload);

      return {
        content: [
          {
            type: "text",
            text: `[Sucesso] Payload enviado ao N8N via Webhook.\nURL: ${fullUrl}\nResposta: ${JSON.stringify(response.data)}`,
          },
        ],
      };
    } catch (error: any) {
      return {
        isError: true,
        content: [
          {
            type: "text",
            text: `[Falha] Nāo foi possivel acionar o n8n. Erro: ${error.message}`,
          },
        ],
      };
    }
  }

  // ==== TOOL 2: HEALTHCHECK QDRANT ====
  if (name === "check_qdrant_status") {
    const qdrantUrl = process.env.QDRANT_URL || "http://localhost:6333";
    try {
      const resp = await axios.get(`${qdrantUrl}/collections`);
      return {
        content: [{ type: "text", text: `[Qdrant Online] Memória pronta para uso. Status da API Vetorial OK. Coleções: ${JSON.stringify(resp.data)}` }]
      };
    } catch(err: any) {
      return {
        isError: true,
        content: [{ type: "text", text: `[Qdrant Offline] Erro ao conectar na porta 6333: ${err.message}. Garanta que 'docker compose up' foi executado no Cockpit.` }]
      };
    }
  }

  throw new Error(`Tool desconhecida: ${name}`);
});

/**
 * 3. INICIALIZAÇÃO VIA STDIO
 * (Essencial para MCPs locais operarem de forma transparente na linha de comando)
 */
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("🚀 Servidor MCP da Diego AI inciado (STDIO Transport)...");
}

main().catch(console.error);
