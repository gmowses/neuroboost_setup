# Como Usar Embeddings e Busca Semântica

A partir da versão 1.1.0, o Neuroboost Setup inclui suporte completo para embeddings e busca semântica usando a extensão PostgreSQL `vector`.

## Funcionalidades Incluídas

### 1. Extensão Vector
```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### 2. Tabela Documents
```sql
CREATE TABLE documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT,
    metadata JSONB,
    embedding vector(1536),
    titulo TEXT
);
```

### 3. Função de Busca Semântica
```sql
CREATE OR REPLACE FUNCTION match_documents (
  query_embedding vector(1536),
  match_count int DEFAULT NULL,
  filter jsonb DEFAULT '{}'
)
RETURNS TABLE (
  id bigint,
  content text,
  metadata jsonb,
  similarity float
)
```

## Como Usar

### 1. Inserindo Documentos com Embeddings

```sql
-- Exemplo: inserir um documento com embedding
INSERT INTO documents (content, metadata, embedding, titulo) 
VALUES (
    'Este é o conteúdo do documento sobre inteligência artificial',
    '{"categoria": "IA", "fonte": "manual", "data": "2024-12-29"}',
    '[0.1, 0.2, 0.3, ...]', -- array de 1536 números (embedding)
    'Introdução à IA'
);
```

### 2. Fazendo Busca Semântica

```sql
-- Buscar documentos similares
SELECT * FROM match_documents(
    '[0.1, 0.2, 0.3, ...]', -- embedding da consulta
    5, -- máximo 5 resultados
    '{"categoria": "IA"}' -- filtro opcional por metadata
);
```

### 3. Exemplos Práticos

#### Buscar documentos similares sem filtro
```sql
SELECT id, titulo, content, similarity 
FROM match_documents('[0.1, 0.2, ...]', 10, '{}')
WHERE similarity > 0.7;
```

#### Buscar com filtro por categoria
```sql
SELECT * FROM match_documents(
    '[0.1, 0.2, ...]', 
    5, 
    '{"categoria": "FAQ"}'
);
```

#### Buscar com múltiplos filtros
```sql
SELECT * FROM match_documents(
    '[0.1, 0.2, ...]', 
    3, 
    '{"categoria": "IA", "fonte": "manual"}'
);
```

## Integração com APIs

### Usando com Node.js/JavaScript

```javascript
const { Pool } = require('pg');

const pool = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'chatdigi',
    user: 'faq_user',
    password: 'sua_senha_faq'
});

// Função para inserir documento com embedding
async function insertDocument(content, metadata, embedding, titulo) {
    const query = `
        INSERT INTO documents (content, metadata, embedding, titulo) 
        VALUES ($1, $2, $3, $4) 
        RETURNING id
    `;
    
    const embeddingString = `[${embedding.join(',')}]`;
    const result = await pool.query(query, [content, metadata, embeddingString, titulo]);
    return result.rows[0].id;
}

// Função para busca semântica
async function searchDocuments(queryEmbedding, limit = 5, filter = {}) {
    const query = `
        SELECT * FROM match_documents($1, $2, $3)
        WHERE similarity > 0.6
        ORDER BY similarity DESC
    `;
    
    const embeddingString = `[${queryEmbedding.join(',')}]`;
    const result = await pool.query(query, [embeddingString, limit, JSON.stringify(filter)]);
    return result.rows;
}
```

### Usando com Python

```python
import psycopg2
import json

# Conectar ao banco
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="chatdigi",
    user="faq_user",
    password="sua_senha_faq"
)

def insert_document(content, metadata, embedding, titulo):
    """Inserir documento com embedding"""
    with conn.cursor() as cur:
        embedding_str = str(embedding).replace(' ', '')
        cur.execute("""
            INSERT INTO documents (content, metadata, embedding, titulo) 
            VALUES (%s, %s, %s, %s) 
            RETURNING id
        """, (content, json.dumps(metadata), embedding_str, titulo))
        
        return cur.fetchone()[0]

def search_documents(query_embedding, limit=5, filter_dict={}):
    """Busca semântica"""
    with conn.cursor() as cur:
        embedding_str = str(query_embedding).replace(' ', '')
        cur.execute("""
            SELECT * FROM match_documents(%s, %s, %s)
            WHERE similarity > 0.6
            ORDER BY similarity DESC
        """, (embedding_str, limit, json.dumps(filter_dict)))
        
        return cur.fetchall()
```

## Integrações Recomendadas

### OpenAI Embeddings
```javascript
const openai = new OpenAI();

async function getEmbedding(text) {
    const response = await openai.embeddings.create({
        model: "text-embedding-ada-002",
        input: text,
    });
    
    return response.data[0].embedding;
}

// Usar com a busca
const queryEmbedding = await getEmbedding("Como funciona inteligência artificial?");
const results = await searchDocuments(queryEmbedding, 5, {categoria: "IA"});
```

### Sentence Transformers (Python)
```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')

def get_embedding(text):
    """Gerar embedding com Sentence Transformers"""
    embedding = model.encode(text)
    # Pad ou truncar para 1536 dimensões se necessário
    return embedding.tolist()

# Usar com a busca
query_embedding = get_embedding("Como funciona inteligência artificial?")
results = search_documents(query_embedding, 5, {"categoria": "IA"})
```

## Performance e Otimização

### Índices para Performance
```sql
-- Criar índice para busca rápida de embeddings
CREATE INDEX idx_documents_embedding ON documents USING ivfflat (embedding vector_cosine_ops);

-- Índice para metadata
CREATE INDEX idx_documents_metadata ON documents USING gin (metadata);
```

### Configurações Recomendadas
```sql
-- Configurações do PostgreSQL para otimizar vector search
-- Adicionar no postgresql.conf:
-- shared_preload_libraries = 'vector'
-- ivfflat.probes = 10
```

## Exemplos de Uso no FAQ System

### Sincronização com N8N
O webhook configurado em `https://webhook.{instancia}.neuroboost.digital/webhook/sync-rag` pode receber dados para sincronizar embeddings automaticamente.

### Estrutura de Metadados Recomendada
```json
{
    "categoria": "FAQ",
    "subcategoria": "Técnico",
    "fonte": "manual",
    "data_criacao": "2024-12-29",
    "tags": ["IA", "automatização"],
    "autor": "sistema",
    "versao": "1.0"
}
```

## Monitoramento

### Verificar Performance
```sql
-- Ver estatísticas da tabela
SELECT 
    schemaname,
    tablename,
    n_tup_ins,
    n_tup_upd,
    n_tup_del
FROM pg_stat_user_tables 
WHERE tablename = 'documents';

-- Ver tamanho da tabela
SELECT pg_size_pretty(pg_total_relation_size('documents'));
```

### Logs de Busca
```sql
-- Ativar logs de consultas lentas
SET log_min_duration_statement = 1000; -- 1 segundo
```

## Resolução de Problemas

### Verificar se a extensão está instalada
```sql
SELECT * FROM pg_extension WHERE extname = 'vector';
```

### Verificar se a tabela foi criada
```sql
\d documents
```

### Testar função de busca
```sql
SELECT match_documents('[0,0,0]'::vector(1536), 1, '{}');
``` 