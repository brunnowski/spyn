# 🌐 SPYN Social Features - Guia Completo de Teste

## 📋 Pré-requisitos

1. **Supabase configurado** - Certifique-se de que suas credenciais estão corretas no `index.html`:
   ```javascript
   const SUPABASE_URL = 'sua-url-aqui';
   const SUPABASE_ANON_KEY = 'sua-chave-aqui';
   ```

2. **Execute o SQL** - Rode o arquivo `database_setup.sql` completo no SQL Editor do Supabase

3. **Configure Redirect URLs** no Supabase Dashboard:
   - `http://localhost:8000`
   - `http://localhost:3000`
   - `https://brunnowski.github.io/hyfa/`

## 🎯 Funcionalidades Implementadas

### 1. ❤️ Sistema de Likes (Curtidas)

**Como funciona:**
- Usuários autenticados podem curtir rotas
- Cada usuário pode curtir uma rota apenas 1 vez
- Likes são salvos em tempo real no Supabase
- Visual muda quando você curte (fundo amarelo)

**Testar:**
1. Crie 2 contas de teste
2. Faça login com conta A
3. Crie uma rota
4. Faça logout e login com conta B
5. Vá ao Feed
6. Clique no botão de ❤️ em uma rota
7. Verifique que o contador aumentou
8. Recarregue a página - o like deve persistir

**Verificar no Supabase:**
```sql
SELECT * FROM route_likes;
```

### 2. 💬 Sistema de Comentários

**Como funciona:**
- Usuários autenticados podem comentar em qualquer rota
- Comentários aparecem em ordem cronológica
- Mostra nome do autor e data
- Salvos em tempo real no Supabase

**Testar:**
1. Faça login
2. No Feed, clique no botão 💬 Comments
3. Digite um comentário
4. Clique em "Post"
5. O comentário deve aparecer imediatamente
6. Recarregue a página - comentários devem persistir

**Verificar no Supabase:**
```sql
SELECT * FROM route_comments ORDER BY created_at DESC;
```

### 3. 👤 Perfis de Usuários Clicáveis

**Como funciona:**
- Nomes de usuários no feed são links
- Clique para ver o perfil completo
- Mostra estatísticas e todas as rotas do usuário

**Testar:**
1. No Feed, clique no nome azul de um criador
2. Você será levado ao perfil daquela pessoa
3. Veja estatísticas: distância, fotos, likes
4. Veja todas as rotas criadas por aquele usuário

### 4. 📊 Estatísticas do Perfil

**Métricas calculadas:**
- **Total Distance** - Soma de todas as rotas
- **Photos** - Total de fotos em todas as rotas
- **Likes** - Total de curtidas recebidas em suas rotas

**Testar:**
1. Crie várias rotas
2. Peça para outros usuários curtirem
3. Acesse seu perfil
4. Verifique se as estatísticas estão corretas

## 🧪 Cenário de Teste Completo

### Preparação
```bash
# Terminal 1 - Inicie o servidor
cd /workspaces/hyfa
python3 -m http.server 8000
```

### Teste 1: Criar Usuários e Rotas

1. **Usuário A (alice@test.com)**
   - Faça signup
   - Verifique email (se configurado)
   - Crie 2 rotas com fotos
   - Faça logout

2. **Usuário B (bob@test.com)**
   - Faça signup
   - Verifique email
   - Crie 1 rota com fotos
   - Faça logout

### Teste 2: Interações Sociais

1. **Login como Alice**
   - Vá ao Feed
   - Curta a rota do Bob (❤️)
   - Comente na rota do Bob: "Great route!"
   - Clique no nome "Bob" → veja perfil dele

2. **Login como Bob**
   - Vá ao Feed
   - Veja o like da Alice na sua rota
   - Veja o comentário da Alice
   - Curta ambas as rotas da Alice
   - Comente em uma rota da Alice: "Nice photos!"

3. **Verifique Persistência**
   - Recarregue a página várias vezes
   - Todos os likes e comentários devem persistir
   - Vá entre páginas (Feed → Map → Profile)
   - Dados devem permanecer consistentes

### Teste 3: Verificação no Banco

```sql
-- Ver todas as rotas
SELECT id, name, user_name, created FROM routes ORDER BY created DESC;

-- Ver todos os likes
SELECT 
  rl.route_id,
  r.name as route_name,
  r.user_name as route_owner,
  (SELECT COUNT(*) FROM route_likes WHERE route_id = r.id) as total_likes
FROM route_likes rl
JOIN routes r ON rl.route_id = r.id
GROUP BY rl.route_id, r.name, r.user_name;

-- Ver todos os comentários
SELECT 
  rc.user_name as commenter,
  r.name as route_name,
  rc.comment,
  rc.created_at
FROM route_comments rc
JOIN routes r ON rc.route_id = r.id
ORDER BY rc.created_at DESC;

-- Ver estatísticas de um usuário
SELECT 
  user_name,
  COUNT(*) as total_routes,
  SUM((SELECT COUNT(*) FROM route_likes WHERE route_id = routes.id)) as total_likes_received
FROM routes
WHERE user_id = 'USER_UUID_AQUI'
GROUP BY user_name;
```

## 🐛 Troubleshooting

### Likes não aparecem
- Verifique se está logado
- Verifique RLS policies no Supabase
- Cheque console do navegador para erros

### Comentários não salvam
- Verifique se o campo `user_name` existe na tabela
- Se necessário, rode:
  ```sql
  ALTER TABLE route_comments ADD COLUMN IF NOT EXISTS user_name TEXT;
  ```

### Perfil não atualiza estatísticas
- Recarregue a página
- Verifique se `loadLikesAndComments()` está sendo chamado
- Cheque console para erros

### "Failed to add comment"
- Verifique credenciais do Supabase
- Confirme que tabelas existem
- Verifique RLS policies

## 📱 Testar em Dispositivos Móveis

1. Encontre seu IP local:
   ```bash
   ip addr show | grep inet
   ```

2. Acesse de outro dispositivo:
   ```
   http://SEU_IP:8000
   ```

3. Teste todas as funcionalidades touch:
   - Scroll do feed
   - Clique em likes
   - Escrever comentários
   - Navegação

## 🎨 Características Visuais

### Feed
- Cards com informações completas
- Nome do criador em azul (clicável)
- Botões de ação: Like, Comment, Share
- Seção de comentários expansível

### Perfil
- Avatar com inicial do nome
- 3 estatísticas principais
- Botões de ação (Logout, Clear All)
- Lista de atividades com métricas

### Interatividade
- Likes mudam cor quando curtido
- Comentários aparecem instantaneamente
- Transições suaves
- Feedback visual em todos os cliques

## 🔐 Segurança

### Row Level Security (RLS)
Todas as tabelas têm RLS ativado:
- Qualquer um pode VER rotas, likes e comentários
- Apenas autenticados podem CRIAR
- Apenas donos podem DELETAR seus dados

### Validações
- Email único por usuário
- Senha mínima de 6 caracteres
- User não pode curtir a mesma rota 2x
- Comentários requerem texto

## 🚀 Próximos Passos

Para expandir a rede social:
1. Sistema de follow/unfollow
2. Feed personalizado (apenas de quem você segue)
3. Notificações de likes e comentários
4. Busca de usuários e rotas
5. Tags em rotas
6. Rotas privadas vs públicas
7. Compartilhamento em outras redes sociais

## 📞 Suporte

Se encontrar problemas:
1. Verifique console do navegador (F12)
2. Verifique logs do Supabase
3. Confirme que RLS policies estão ativas
4. Teste com localStorage (fallback automático)

---

**Happy Testing! 🎉**
