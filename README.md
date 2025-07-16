# Neuroboost Setup

Instalador automatizado Docker Compose para stack completa Neuroboost Digital.

**Versão Atual:** 1.2.0

## Instalação Rápida

```bash
bash <(curl -sSL setup.neuroboost.digital)
```

## Versionamento

Este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/):
- **MAJOR** (X.0.0): Mudanças incompatíveis na API
- **MINOR** (0.X.0): Funcionalidades adicionadas de forma compatível
- **PATCH** (0.0.X): Correções de bugs compatíveis

Consulte o [CHANGELOG.md](CHANGELOG.md) para histórico detalhado de mudanças.

Para usar embeddings e busca semântica, veja [EMBEDDINGS_USAGE.md](EMBEDDINGS_USAGE.md).

Para configurar e usar o ChatDigi System, veja [CHATDIGI_SETUP.md](CHATDIGI_SETUP.md).

## Componentes Instalados

- **Traefik** - Reverse proxy com SSL automático
- **Portainer** - Interface de gerenciamento Docker
- **MinIO** - Armazenamento S3 compatível
- **PostgreSQL** - Banco de dados relacional com extensão vector
- **Redis** - Cache e sistema de filas
- **RabbitMQ** - Message broker
- **N8N** - Plataforma de automação (Editor + Webhook + Worker)
- **FAQ System** - Sistema de perguntas e respostas com RAG
- **ChatDigi System** - Sistema completo de chat com IA (Frontend + Backend + QR Generator) - Integrado com Redis e banco FAQ

## Funcionalidades Avançadas

- **Busca Semântica** - Extensão PostgreSQL `vector` para embeddings
- **RAG (Retrieval-Augmented Generation)** - Tabela `documents` com embeddings de 1536 dimensões
- **Função match_documents** - Busca por similaridade de vetores otimizada
- **Metadados JSON** - Filtragem avançada de documentos

## Requisitos

- Ubuntu 24.04 LTS
- Usuário root
- Acesso à internet

## Configuração Automática

O instalador configura automaticamente:
- SSL/TLS via Let's Encrypt
- Senhas seguras geradas automaticamente
- Fuso horário (América/São_Paulo)
- Bancos de dados e usuários
- Rede Docker compartilhada
- URLs personalizadas por instância

## Variáveis de Ambiente

Para instalação automatizada:

```bash
export NEUROBOOST_INSTANCE="cliente1"
export NEUROBOOST_AUTO_CONFIRM="true"
export NEUROBOOST_EMAIL="admin@example.com"
bash <(curl -sSL setup.neuroboost.digital)
```

## Logs e Credenciais

Após a instalação:
- Logs detalhados em: `instalacao_YYYYMMDD_HHMMSS.log`
- Credenciais salvas em: `/root/{instancia}/credenciais.txt`
- Arquivos docker-compose em: `/root/{instancia}/`

## Suporte

Para mais informações: https://neuroboost.digital
