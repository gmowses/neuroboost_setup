# Gerenciamento de Versões

Este documento descreve como gerenciar versões no projeto Neuroboost Setup.

## Estrutura de Versionamento

O projeto segue [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Mudanças que quebram compatibilidade
- **MINOR** (0.X.0): Novas funcionalidades compatíveis
- **PATCH** (0.0.X): Correções de bugs

## Como Atualizar a Versão

### 1. Editar a Versão no Script

```bash
# No arquivo Setup, linha ~18:
VERSION="1.0.1"  # Atualizar aqui
```

### 2. Atualizar CHANGELOG.md

Adicione uma nova entrada no topo do arquivo:

```markdown
## [1.0.1] - 2024-12-30

### Corrigido
- Descrição da correção realizada

### Adicionado
- Nova funcionalidade (se aplicável)

### Modificado
- Mudança na funcionalidade existente (se aplicável)
```

### 3. Atualizar README.md

```markdown
**Versão Atual:** 1.0.1
```

### 4. Testar a Instalação

Sempre teste a instalação completa após mudanças:

```bash
# Em ambiente de teste Ubuntu 24.04
export NEUROBOOST_INSTANCE="teste"
export NEUROBOOST_AUTO_CONFIRM="true"
sudo ./Setup
```

### 5. Commit e Tag

```bash
git add .
git commit -m "bump: version 1.0.1"
git tag -a v1.0.1 -m "Version 1.0.1"
git push origin main --tags
```

## Tipos de Mudanças

### PATCH (0.0.X)
- Correção de bugs
- Melhorias na documentação
- Ajustes de configuração
- Correções de logs

**Exemplo:** 1.0.0 → 1.0.1

### MINOR (0.X.0)
- Novos serviços/containers
- Novas funcionalidades
- Novas variáveis de ambiente
- Melhorias significativas

**Exemplo:** 1.0.5 → 1.1.0

### MAJOR (X.0.0)
- Mudanças nos requisitos de sistema
- Alterações que quebram instalações existentes
- Mudanças na estrutura de arquivos
- Alterações incompatíveis na API

**Exemplo:** 1.5.2 → 2.0.0

## Checklist de Release

### Antes do Release
- [ ] Versão atualizada no `Setup`
- [ ] CHANGELOG.md atualizado
- [ ] README.md atualizado
- [ ] Teste de instalação completa
- [ ] Verificação de todos os serviços

### Após o Release
- [ ] Commit das alterações
- [ ] Tag da versão criada
- [ ] Push para repositório
- [ ] Teste da URL de instalação
- [ ] Documentação atualizada

## URLs de Teste

Durante desenvolvimento, teste com diferentes URLs:

```bash
# Local
sudo ./Setup

# Repositório específico
bash <(curl -sSL https://raw.githubusercontent.com/user/repo/branch/Setup)

# Produção
bash <(curl -sSL setup.neuroboost.digital)
```

## Versionamento de Componentes

Mantenha registro das versões dos componentes principais:

### Versão 1.2.0
- Traefik: v3.4.0
- Portainer: latest
- MinIO: latest
- PostgreSQL: 14 + extensão vector
- Redis: latest (compartilhado entre serviços)
- RabbitMQ: management
- N8N: latest
- FAQ System: ghcr.io/gmowses/faq:v1
- ChatDigi Backend: ghcr.io/gmowses/chatdigi-backend:v1
- ChatDigi Frontend: ghcr.io/gmowses/chatdigi-frontend:v1
- QR Generator: mowses1997/qr-generator:latest
- **Novo:** Sistema completo de chat com IA
- **Integração:** Redis compartilhado e usuário FAQ compartilhado

### Versão 1.1.0
- Traefik: v3.4.0
- Portainer: latest
- MinIO: latest
- PostgreSQL: 14 + extensão vector
- Redis: latest
- RabbitMQ: management
- N8N: latest
- FAQ System: ghcr.io/gmowses/faq:v1
- **Novo:** Suporte a embeddings e busca semântica

### Versão 1.0.0
- Traefik: v3.4.0
- Portainer: latest
- MinIO: latest
- PostgreSQL: 14
- Redis: latest
- RabbitMQ: management
- N8N: latest
- FAQ System: ghcr.io/gmowses/faq:v1

## Notas de Compatibilidade

### Ubuntu
- Testado: 24.04 LTS
- Mínimo: 24.04 LTS

### Docker
- Mínimo: 24.x
- Recomendado: Última versão

### Recursos
- RAM: Mínimo 2GB
- Disk: Mínimo 10GB
- CPU: Mínimo 1 core 