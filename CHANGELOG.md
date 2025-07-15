# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [1.0.0] - 2024-12-29

### Adicionado
- Versão inicial do instalador completo Neuroboost Digital
- Sistema de versionamento SEMVER
- Instalação automatizada de:
  - Traefik (reverse proxy com SSL)
  - Portainer (gerenciamento Docker)
  - MinIO (armazenamento S3)
  - PostgreSQL (banco de dados)
  - Redis (cache e filas)
  - RabbitMQ (message broker)
  - N8N (automação - editor, webhook e worker)
  - FAQ System (sistema de perguntas e respostas)
- Verificação de requisitos de sistema (Ubuntu 24.04 LTS + root)
- Configuração automática de SSL via Let's Encrypt
- Geração automática de senhas seguras
- Configuração de fuso horário (Brasília)
- Sistema de logs detalhados
- Arquivo de credenciais completo
- Configuração automática do Portainer via API
- Criação automática de bancos de dados e usuários
- Estrutura de tabelas para o FAQ System

### Características
- Suporte a variáveis de ambiente para automação
- Logs detalhados de toda a instalação
- Verificação de saúde dos containers
- Configuração de rede Docker compartilhada
- URLs personalizadas por instância
- Backup automático de configurações 