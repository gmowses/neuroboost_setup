#!/bin/bash

# Script de Limpeza Completa do Sistema NeuroBoost/ChatDigi
# Este script remove TODOS os containers, volumes, redes e imagens relacionados

set -e

# Cores para output
VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
BRANCO='\033[1;37m'
NC='\033[0m' # No Color

# Função para mensagens coloridas
msg() {
    echo -e "${1}${2}${NC}"
}

# Função para confirmar ação
confirmar() {
    read -p "$(echo -e "${AMARELO}$1 (s/N): ${NC}")" resposta
    case $resposta in
        [Ss]* ) return 0;;
        * ) return 1;;
    esac
}

clear
msg "$VERMELHO" "
╔════════════════════════════════════════════════════════════════╗
║                    ⚠️  SCRIPT DE LIMPEZA TOTAL                ║
║                                                                ║
║  Este script irá REMOVER COMPLETAMENTE:                       ║
║  • Todos os containers do sistema                              ║
║  • Todos os volumes (dados serão PERDIDOS)                    ║
║  • Todas as redes criadas                                     ║
║  • Todas as imagens Docker relacionadas                       ║
║  • Certificados SSL                                           ║
║  • Arquivos de configuração                                   ║
║                                                                ║
║  ⚠️  ESTA AÇÃO É IRREVERSÍVEL! ⚠️                             ║
╚════════════════════════════════════════════════════════════════╝
"

if ! confirmar "Tem certeza que deseja continuar?"; then
    msg "$VERDE" "Operação cancelada."
    exit 0
fi

echo
msg "$AMARELO" "Iniciando limpeza completa do sistema..."
echo

# 1. Parar todos os containers relacionados
msg "$AZUL" "🛑 Parando todos os containers..."

# Lista de arquivos docker-compose para parar
COMPOSE_FILES=(
    "docker-compose.traefik-portainer.yml"
    "docker-compose.minio.yml"
    "docker-compose.redis.yml"
    "docker-compose.postgres.yml"
    "docker-compose.rabbitmq.yml"
    "docker-compose.n8n.yml"
    "docker-compose.faq.yml"
    "docker-compose.chatdigi.yml"
)

for file in "${COMPOSE_FILES[@]}"; do
    if [ -f "$file" ]; then
        msg "$BRANCO" "  Parando serviços em $file..."
        docker compose -f "$file" down --remove-orphans 2>/dev/null || true
    fi
done

# 2. Remover containers órfãos e relacionados
msg "$AZUL" "🗑️  Removendo containers..."

# Parar todos os containers que contenham palavras-chave relacionadas
CONTAINERS=$(docker ps -aq --filter "name=traefik" --filter "name=portainer" --filter "name=minio" --filter "name=redis" --filter "name=postgres" --filter "name=rabbitmq" --filter "name=n8n" --filter "name=faq" --filter "name=chatdigi" --filter "name=whisper" --filter "name=qr-generator" 2>/dev/null || true)

if [ ! -z "$CONTAINERS" ]; then
    msg "$BRANCO" "  Parando containers relacionados..."
    docker stop $CONTAINERS 2>/dev/null || true
    msg "$BRANCO" "  Removendo containers relacionados..."
    docker rm $CONTAINERS 2>/dev/null || true
else
    msg "$BRANCO" "  Nenhum container relacionado encontrado."
fi

# 3. Remover volumes
msg "$AZUL" "💾 Removendo volumes..."

# Lista de volumes para remover
VOLUMES=$(docker volume ls -q | grep -E "(traefik|portainer|minio|redis|postgres|rabbitmq|n8n|faq|chatdigi|whisper)" 2>/dev/null || true)

if [ ! -z "$VOLUMES" ]; then
    msg "$BRANCO" "  Removendo volumes relacionados..."
    echo $VOLUMES | xargs docker volume rm 2>/dev/null || true
else
    msg "$BRANCO" "  Nenhum volume relacionado encontrado."
fi

# Remover volumes órfãos
msg "$BRANCO" "  Removendo volumes órfãos..."
docker volume prune -f 2>/dev/null || true

# 4. Remover redes
msg "$AZUL" "🌐 Removendo redes..."

# Lista de redes para remover
NETWORKS=$(docker network ls -q --filter "name=neuroboost" --filter "name=network" 2>/dev/null || true)

if [ ! -z "$NETWORKS" ]; then
    msg "$BRANCO" "  Removendo redes relacionadas..."
    echo $NETWORKS | xargs docker network rm 2>/dev/null || true
else
    msg "$BRANCO" "  Nenhuma rede relacionada encontrada."
fi

# Remover redes órfãs
msg "$BRANCO" "  Removendo redes órfãs..."
docker network prune -f 2>/dev/null || true

# 5. Remover imagens
msg "$AZUL" "🖼️  Removendo imagens..."

# Lista de imagens para remover
IMAGES=$(docker images -q --filter "reference=*traefik*" --filter "reference=*portainer*" --filter "reference=*minio*" --filter "reference=*redis*" --filter "reference=*postgres*" --filter "reference=*rabbitmq*" --filter "reference=*n8n*" --filter "reference=*faq*" --filter "reference=*chatdigi*" --filter "reference=*whisper*" --filter "reference=*qr-generator*" 2>/dev/null || true)

if [ ! -z "$IMAGES" ]; then
    msg "$BRANCO" "  Removendo imagens relacionadas..."
    echo $IMAGES | xargs docker rmi -f 2>/dev/null || true
else
    msg "$BRANCO" "  Nenhuma imagem relacionada encontrada."
fi

# Remover imagens órfãs
msg "$BRANCO" "  Removendo imagens órfãs..."
docker image prune -a -f 2>/dev/null || true

# 6. Limpeza geral do Docker
msg "$AZUL" "🧹 Limpeza geral do Docker..."
docker system prune -a -f --volumes 2>/dev/null || true

# 7. Remover arquivos de configuração
msg "$AZUL" "📁 Removendo arquivos de configuração..."

# Lista de arquivos para remover
ARQUIVOS=(
    "docker-compose.traefik-portainer.yml"
    "docker-compose.minio.yml"
    "docker-compose.redis.yml"
    "docker-compose.postgres.yml"
    "docker-compose.rabbitmq.yml"
    "docker-compose.n8n.yml"
    "docker-compose.faq.yml"
    "docker-compose.chatdigi.yml"
    "credenciais.txt"
    ".env"
)

for arquivo in "${ARQUIVOS[@]}"; do
    if [ -f "$arquivo" ]; then
        msg "$BRANCO" "  Removendo $arquivo..."
        rm -f "$arquivo"
    fi
done

# Remover diretórios
DIRETORIOS=(
    "letsencrypt"
    "data"
    "logs"
    "backups"
)

for dir in "${DIRETORIOS[@]}"; do
    if [ -d "$dir" ]; then
        msg "$BRANCO" "  Removendo diretório $dir..."
        rm -rf "$dir"
    fi
done

# 8. Verificação final
msg "$AZUL" "🔍 Verificação final..."

CONTAINERS_RESTANTES=$(docker ps -aq 2>/dev/null | wc -l)
VOLUMES_RESTANTES=$(docker volume ls -q 2>/dev/null | wc -l)
IMAGENS_RESTANTES=$(docker images -q 2>/dev/null | wc -l)
REDES_RESTANTES=$(docker network ls -q --filter "type=custom" 2>/dev/null | wc -l)

msg "$BRANCO" "  Containers restantes: $CONTAINERS_RESTANTES"
msg "$BRANCO" "  Volumes restantes: $VOLUMES_RESTANTES"
msg "$BRANCO" "  Imagens restantes: $IMAGENES_RESTANTES"
msg "$BRANCO" "  Redes customizadas restantes: $REDES_RESTANTES"

echo
msg "$VERDE" "
╔════════════════════════════════════════════════════════════════╗
║                    ✅ LIMPEZA CONCLUÍDA!                      ║
║                                                                ║
║  O sistema foi completamente removido:                        ║
║  • Todos os containers foram parados e removidos              ║
║  • Todos os volumes foram removidos                           ║
║  • Todas as redes foram removidas                             ║
║  • Todas as imagens foram removidas                           ║
║  • Arquivos de configuração foram removidos                   ║
║                                                                ║
║  Para reinstalar o sistema, execute novamente o Setup         ║
╚════════════════════════════════════════════════════════════════╝
"

msg "$AMARELO" "💡 Para reinstalar o sistema, execute: ./Setup"
echo