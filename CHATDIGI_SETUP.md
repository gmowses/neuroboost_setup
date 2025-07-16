# ChatDigi System - Configuração e Uso

O ChatDigi é um sistema completo de chat com IA que inclui frontend React, backend API e gerador de QR codes para WhatsApp.

## Componentes

### 1. Frontend (React)
- **URL**: `https://chat.{instancia}.neuroboost.digital`
- **Porta**: 80 (interna)
- **Imagem**: `ghcr.io/gmowses/chatdigi-frontend:v1`

### 2. Backend API (Node.js)
- **URL**: `https://api.{instancia}.neuroboost.digital`
- **Porta**: 8080 (interna)
- **Imagem**: `ghcr.io/gmowses/chatdigi-backend:v1`

### 3. QR Generator (Flask)
- **Imagem**: `mowses1997/qr-generator:latest`
- **Função**: Gerar QR codes para conexão WhatsApp

## Configuração Automática

### Variáveis de Ambiente Configuradas

#### Banco de Dados
```bash
DB_DIALECT=postgres
DB_HOST=postgres
DB_PORT=5432
DB_NAME=chatdigi
DB_USER=faq_user
DB_PASS=[senha_gerada_automaticamente]
DB_POOL_MAX=20
DB_POOL_MIN=5
DB_POOL_ACQUIRE=30000
DB_POOL_IDLE=10000
```

#### Redis
```bash
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_URI=redis://redis:6379
REDIS_URI_ACK=redis://redis:6379
```

#### JWT Authentication
```bash
JWT_SECRET=[senha_gerada_automaticamente]
JWT_REFRESH_SECRET=[senha_gerada_automaticamente]
```

#### URLs
```bash
FRONTEND_URL=https://chat.{instancia}.neuroboost.digital
REACT_APP_BACKEND_URL=https://api.{instancia}.neuroboost.digital
```

#### Configurações da Aplicação
```bash
NODE_ENV=production
PORT=8080
MAX_FILE_SIZE=10485760  # 10MB
WHATSAPP_TIMEOUT=30000  # 30 segundos
TZ=America/Sao_Paulo
```

## Integrações (Configurar Manualmente)

### OpenAI
```bash
OPENAI_API_KEY=sua_chave_openai_aqui
```

### Gerencianet (Pagamentos)
```bash
GERENCIANET_CLIENT_ID=seu_client_id_aqui
GERENCIANET_CLIENT_SECRET=seu_client_secret_aqui
```

## Volumes Criados

### Backend Uploads
```bash
Volume: {instancia}_chatdigi_backend_uploads
Path: /app/public
Uso: Armazenar arquivos enviados pelos usuários
```

### Backend Logs
```bash
Volume: {instancia}_chatdigi_backend_logs
Path: /app/logs
Uso: Logs da aplicação backend
```

## Como Configurar Integrações

### 1. Configurar OpenAI

1. Acesse o container do backend:
```bash
docker exec -it {instancia}_chatdigi_backend bash
```

2. Edite as variáveis de ambiente:
```bash
# Dentro do container
export OPENAI_API_KEY="sua_chave_aqui"
```

3. Ou reinicie o container com a nova variável:
```bash
docker compose -f docker-compose.chatdigi.yml down
# Edite o arquivo docker-compose.chatdigi.yml
# Adicione: - OPENAI_API_KEY=sua_chave_aqui
docker compose -f docker-compose.chatdigi.yml up -d
```

### 2. Configurar Gerencianet

Siga o mesmo processo para as variáveis:
```bash
GERENCIANET_CLIENT_ID=seu_client_id
GERENCIANET_CLIENT_SECRET=seu_client_secret
```

## Estrutura de URLs

### Frontend
- **URL Principal**: `https://chat.{instancia}.neuroboost.digital`
- **Login**: `/login`
- **Dashboard**: `/dashboard`
- **Chat**: `/chat`

### Backend API
- **URL Base**: `https://api.{instancia}.neuroboost.digital`
- **API Docs**: `/api/docs`
- **Health Check**: `/health`
- **Socket.IO**: `/socket.io`

## Comandos Úteis

### Ver Logs
```bash
# Logs do frontend
docker logs {instancia}_chatdigi_frontend

# Logs do backend
docker logs {instancia}_chatdigi_backend

# Logs do QR generator
docker logs {instancia}_qr_generator

# Todos os logs
docker compose -f docker-compose.chatdigi.yml logs -f
```

### Reiniciar Serviços
```bash
# Reiniciar tudo
docker compose -f docker-compose.chatdigi.yml restart

# Reiniciar apenas backend
docker compose -f docker-compose.chatdigi.yml restart chatdigi-backend

# Reiniciar apenas frontend
docker compose -f docker-compose.chatdigi.yml restart chatdigi-frontend
```

### Atualizar Imagens
```bash
docker compose -f docker-compose.chatdigi.yml pull
docker compose -f docker-compose.chatdigi.yml up -d
```

## Monitoramento

### Verificar Status
```bash
# Status dos containers
docker ps | grep chatdigi

# Uso de recursos
docker stats {instancia}_chatdigi_backend {instancia}_chatdigi_frontend
```

### Verificar Conectividade
```bash
# Testar API
curl -k https://api.{instancia}.neuroboost.digital/health

# Testar Frontend
curl -k https://chat.{instancia}.neuroboost.digital
```

## Banco de Dados

O ChatDigi usa o mesmo banco `chatdigi` do FAQ System, compartilhando:
- **Usuário**: `faq_user`
- **Senha**: Gerada automaticamente
- **Tabelas**: Criadas automaticamente pelo backend

### Tabelas Principais
- `users` - Usuários do sistema
- `chats` - Conversas
- `messages` - Mensagens
- `contacts` - Contatos
- `sessions` - Sessões ativas

## Segurança

### JWT Tokens
- **Access Token**: 15 minutos
- **Refresh Token**: 7 dias
- **Secrets**: Gerados automaticamente

### Upload de Arquivos
- **Tamanho máximo**: 10MB
- **Tipos permitidos**: Configurados no backend
- **Armazenamento**: Volume Docker dedicado

### Redis
- **Conexão**: Redis existente sem senha
- **Uso**: Cache e sessões
- **Configuração**: Simplificada sem secret key
- **Persistência**: Configurada automaticamente

## Troubleshooting

### Problemas Comuns

#### 1. Frontend não carrega
```bash
# Verificar logs
docker logs {instancia}_chatdigi_frontend

# Verificar conectividade com backend
curl -k https://api.{instancia}.neuroboost.digital/health
```

#### 2. Backend não responde
```bash
# Verificar logs
docker logs {instancia}_chatdigi_backend

# Verificar banco de dados
docker exec {instancia}_postgres psql -U faq_user -d chatdigi -c "SELECT 1;"
```

#### 3. QR Code não gera
```bash
# Verificar logs do QR generator
docker logs {instancia}_qr_generator

# Verificar conectividade
docker exec {instancia}_qr_generator ping -c 3 google.com
```

#### 4. Problemas de Redis
```bash
# Verificar conectividade Redis
docker exec {instancia}_chatdigi_backend redis-cli -h redis ping
```

### Logs Importantes

#### Backend
- **Aplicação**: `/app/logs/app.log`
- **Erros**: `/app/logs/error.log`
- **Acesso**: `/app/logs/access.log`

#### Frontend
- **Console**: Logs do navegador
- **Build**: Logs de compilação

## Backup e Restore

### Backup dos Dados
```bash
# Backup do banco
docker exec {instancia}_postgres pg_dump -U faq_user chatdigi > backup_chatdigi.sql

# Backup dos uploads
docker run --rm -v {instancia}_chatdigi_backend_uploads:/data -v $(pwd):/backup alpine tar czf /backup/chatdigi_uploads.tar.gz -C /data .
```

### Restore dos Dados
```bash
# Restore do banco
docker exec -i {instancia}_postgres psql -U faq_user -d chatdigi < backup_chatdigi.sql

# Restore dos uploads
docker run --rm -v {instancia}_chatdigi_backend_uploads:/data -v $(pwd):/backup alpine tar xzf /backup/chatdigi_uploads.tar.gz -C /data
```

## Desenvolvimento

### Modo Desenvolvimento
Para desenvolvimento local, você pode:

1. **Clonar os repositórios**:
```bash
git clone https://github.com/gmowses/chatdigi-frontend.git
git clone https://github.com/gmowses/chatdigi-backend.git
```

2. **Configurar variáveis de ambiente**:
```bash
# .env para desenvolvimento
DB_HOST=localhost
DB_PORT=5432
DB_NAME=chatdigi
DB_USER=faq_user
DB_PASS=sua_senha
```

3. **Executar localmente**:
```bash
# Backend
cd chatdigi-backend
npm install
npm run dev

# Frontend
cd chatdigi-frontend
npm install
npm start
```

## Suporte

Para suporte técnico:
- **Documentação**: Este arquivo
- **Issues**: Repositório do projeto
- **Email**: suporte@neuroboost.digital 