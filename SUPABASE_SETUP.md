# Configuração do Supabase para Hyfa

## 1. Criar conta no Supabase

1. Acesse [https://supabase.com](https://supabase.com)
2. Crie uma conta gratuita
3. Crie um novo projeto

## 2. Obter as credenciais

No painel do seu projeto Supabase:

1. Vá em **Settings** → **API**
2. Copie:
   - `Project URL` (SUPABASE_URL)
   - `anon public` key (SUPABASE_ANON_KEY)

## 3. Atualizar o código

No arquivo `index.html`, substitua as linhas:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

Pelas suas credenciais reais.

## 4. Criar a tabela no Supabase

No painel do Supabase, vá em **SQL Editor** e execute:

```sql
-- Criar tabela de rotas
CREATE TABLE routes (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  name TEXT NOT NULL,
  description TEXT,
  waypoints JSONB NOT NULL,
  created TIMESTAMPTZ DEFAULT NOW(),
  photo_count INTEGER,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT
);

-- Habilitar RLS (Row Level Security)
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;

-- Política: usuários podem ver todas as rotas (feed público)
CREATE POLICY "Public routes are viewable by everyone"
  ON routes FOR SELECT
  USING (true);

-- Política: usuários autenticados podem inserir suas próprias rotas
CREATE POLICY "Users can insert their own routes"
  ON routes FOR INSERT
  WITH CHECK (auth.uid() = user_id::uuid);

-- Política: usuários podem atualizar suas próprias rotas
CREATE POLICY "Users can update their own routes"
  ON routes FOR UPDATE
  USING (auth.uid() = user_id::uuid);

-- Política: usuários podem deletar suas próprias rotas
CREATE POLICY "Users can delete their own routes"
  ON routes FOR DELETE
  USING (auth.uid() = user_id::uuid);

-- Criar índices para melhor performance
CREATE INDEX idx_routes_user_id ON routes(user_id);
CREATE INDEX idx_routes_created ON routes(created DESC);
```

## 5. Configurar autenticação

No painel do Supabase:

1. Vá em **Authentication** → **Providers**
2. Certifique-se que **Email** está habilitado
3. Em **Authentication** → **URL Configuration**, configure:
   - Site URL: `http://localhost:8000` (para desenvolvimento)
   - Redirect URLs: adicione `http://localhost:8000`

## 6. (Opcional) Configurar Email Templates

Em **Authentication** → **Email Templates**, você pode personalizar:
- Confirm signup
- Reset password
- etc.

## 7. Testar a aplicação

1. Inicie o servidor: `python3 -m http.server 8000`
2. Acesse: `http://localhost:8000/index.html`
3. Crie uma conta
4. Verifique no painel do Supabase:
   - **Authentication** → **Users** (usuários criados)
   - **Table Editor** → **routes** (rotas salvas)

## Estrutura de Dados

### Tabela `routes`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | TEXT | ID único da rota |
| name | TEXT | Nome da rota |
| description | TEXT | Descrição da rota |
| waypoints | JSONB | Array de waypoints com fotos e GPS |
| created | TIMESTAMPTZ | Data de criação |
| photo_count | INTEGER | Número de fotos |
| user_id | UUID | ID do usuário (FK para auth.users) |
| user_name | TEXT | Nome do usuário |

### Estrutura de waypoints (JSONB)

```json
[
  {
    "lat": -23.550520,
    "lng": -46.633308,
    "timestamp": 1700000000000,
    "photo": "data:image/jpeg;base64,..."
  }
]
```

## Funcionalidades implementadas

✅ **Autenticação**
- Signup com email/password
- Login com email/password
- Logout
- Sessão persistente

✅ **Rotas**
- Salvar rotas no Supabase
- Carregar rotas do Supabase
- Feed público (todas as rotas)
- Filtro por usuário no profile

✅ **Segurança**
- Row Level Security (RLS)
- Políticas de acesso
- Validação de usuário

## Próximos passos (opcional)

- [ ] Implementar edição de rotas no Supabase
- [ ] Adicionar Storage do Supabase para fotos (em vez de base64)
- [ ] Implementar busca de rotas
- [ ] Adicionar likes/comentários
- [ ] Configurar domain para produção
