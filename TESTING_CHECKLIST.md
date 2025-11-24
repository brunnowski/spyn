# ✅ SPYN Social Network - Checklist de Teste

## 🚀 Setup Inicial

- [ ] **Supabase configurado**
  - [ ] Projeto criado no Supabase
  - [ ] URL e ANON_KEY configurados no `index.html`
  - [ ] SQL executado: `database_setup.sql`
  - [ ] Redirect URLs configuradas

- [ ] **Servidor rodando**
  ```bash
  python3 -m http.server 8000
  ```
  - [ ] Acesso em http://localhost:8000

## 👥 Criar Usuários de Teste

- [ ] **Usuário 1 - Alice**
  - Email: `alice@test.com`
  - Password: `test123`
  - Nome: `Alice`
  - [ ] Conta criada
  - [ ] Email verificado (se necessário)

- [ ] **Usuário 2 - Bob**
  - Email: `bob@test.com`
  - Password: `test123`
  - Nome: `Bob`
  - [ ] Conta criada
  - [ ] Email verificado (se necessário)

## 📸 Criar Rotas

### Alice (Usuário 1)
- [ ] **Rota 1**: "Morning Run"
  - [ ] 3+ fotos com GPS
  - [ ] Nome e descrição preenchidos
  - [ ] Rota gerada com sucesso

- [ ] **Rota 2**: "Beach Walk"
  - [ ] 2+ fotos com GPS
  - [ ] Nome e descrição preenchidos
  - [ ] Rota gerada com sucesso

### Bob (Usuário 2)
- [ ] **Rota 1**: "Mountain Trail"
  - [ ] 4+ fotos com GPS
  - [ ] Nome e descrição preenchidos
  - [ ] Rota gerada com sucesso

## ❤️ Testar Sistema de Likes

### Como Alice
- [ ] Ir ao Feed
- [ ] Ver rota do Bob
- [ ] Clicar no botão ❤️ (coração vazio)
- [ ] Verificar que mudou para ❤️ (coração cheio, fundo amarelo)
- [ ] Verificar que contador aumentou de 0 → 1
- [ ] Recarregar página (F5)
- [ ] Verificar que like ainda está lá

### Como Bob
- [ ] Ir ao Feed
- [ ] Ver rotas da Alice
- [ ] Curtir "Morning Run"
- [ ] Curtir "Beach Walk"
- [ ] Verificar contadores

### Descurtir
- [ ] Como Alice, descurtir rota do Bob
- [ ] Verificar que voltou para 🤍
- [ ] Contador deve diminuir

## 💬 Testar Sistema de Comentários

### Como Alice
- [ ] Ir ao Feed
- [ ] Clicar no botão 💬 na rota do Bob
- [ ] Ver seção de comentários expandir
- [ ] Digitar: "Great photos! 🌟"
- [ ] Clicar "Post"
- [ ] Comentário deve aparecer imediatamente
- [ ] Ver nome "Alice" no comentário
- [ ] Ver data do comentário

### Como Bob
- [ ] Ir ao Feed
- [ ] Clicar em 💬 na rota "Morning Run" da Alice
- [ ] Comentar: "Nice route!"
- [ ] Comentar novamente: "Where is this?"
- [ ] Verificar que ambos comentários aparecem
- [ ] Verificar contador: 2 Comments

### Recarregar
- [ ] Fazer F5 na página
- [ ] Abrir seção de comentários
- [ ] Todos os comentários devem estar lá

## 👤 Testar Perfis Clicáveis

### Visualizar Perfil do Bob
- [ ] Como Alice, ir ao Feed
- [ ] Clicar no nome azul "Bob"
- [ ] Deve ir para página Profile
- [ ] Ver:
  - [ ] Nome: Bob
  - [ ] Avatar: B
  - [ ] Estatísticas corretas
  - [ ] Rota "Mountain Trail" listada
- [ ] Clicar na rota
- [ ] Deve abrir no mapa

### Visualizar Perfil da Alice
- [ ] Como Bob, clicar no nome "Alice" no Feed
- [ ] Ver perfil completo da Alice
- [ ] Ver ambas as rotas dela

### Perfil Próprio
- [ ] Como Alice, clicar em "Profile" na navegação
- [ ] Ver estatísticas:
  - [ ] Total Distance calculado
  - [ ] Total Photos
  - [ ] Total Likes recebidos
- [ ] Ver botões: Logout e Clear All

## 📊 Verificar Estatísticas

### Perfil da Alice
- [ ] Routes: 2
- [ ] Photos: 5+ (soma das duas rotas)
- [ ] Likes: 2 (curtidas do Bob)
- [ ] Distance: valor calculado

### Perfil do Bob
- [ ] Routes: 1
- [ ] Photos: 4+
- [ ] Likes: 1 ou 0 (dependendo dos testes)
- [ ] Distance: valor calculado

## 🔄 Testar Persistência

- [ ] **Recarregar página múltiplas vezes**
  - [ ] Likes permanecem
  - [ ] Comentários permanecem
  - [ ] Estatísticas corretas

- [ ] **Navegar entre páginas**
  - Feed → Map → Profile → Feed
  - [ ] Dados consistentes

- [ ] **Fazer logout e login novamente**
  - [ ] Dados ainda estão lá

## 🗄️ Verificar no Supabase

### Via SQL Editor
```sql
-- Ver rotas
SELECT id, name, user_name, created FROM routes;

-- Ver likes
SELECT * FROM route_likes;

-- Ver comentários
SELECT * FROM route_comments;
```

- [ ] Rotas estão salvas
- [ ] Likes estão salvos
- [ ] Comentários estão salvos
- [ ] User IDs corretos
- [ ] Timestamps corretos

### Via Table Editor
- [ ] Tabela `routes`: 3 linhas
- [ ] Tabela `route_likes`: múltiplas linhas
- [ ] Tabela `route_comments`: múltiplas linhas

## 🐛 Testar Casos de Erro

### Sem Login
- [ ] Tentar curtir sem estar logado
- [ ] Deve abrir modal de login
- [ ] Tentar comentar sem login
- [ ] Deve abrir modal de login

### Comentário Vazio
- [ ] Tentar postar comentário vazio
- [ ] Deve mostrar erro: "Please enter a comment"

### Like Duplicado
- [ ] Curtir uma rota
- [ ] Tentar curtir novamente (via console se necessário)
- [ ] Deve ser bloqueado pelo banco (unique constraint)

## 📱 Teste Mobile (Opcional)

- [ ] Abrir em dispositivo móvel
- [ ] Testar scroll do feed
- [ ] Testar cliques em likes
- [ ] Testar escrita de comentários
- [ ] Testar navegação

## 🎨 Verificar Visual

### Feed
- [ ] Cards bem formatados
- [ ] Nome do criador em azul
- [ ] Botões Like, Comment, Share visíveis
- [ ] Ícones aparecem corretamente (❤️, 💬)
- [ ] Likes curtidos aparecem com fundo amarelo

### Comentários
- [ ] Seção expande/recolhe corretamente
- [ ] Nome do autor em destaque
- [ ] Data formatada
- [ ] Input de comentário funcional

### Perfil
- [ ] Avatar com letra correta
- [ ] Estatísticas em grid 3 colunas
- [ ] Cards de rotas com todas as métricas
- [ ] Botões estilizados

## 🎉 Funcionalidades Avançadas (Bonus)

- [ ] **Múltiplos comentários na mesma rota**
  - [ ] Ordem cronológica mantida
  - [ ] Scroll funciona se muitos comentários

- [ ] **Interações cruzadas**
  - [ ] Alice curte e comenta rota do Bob
  - [ ] Bob vê notificação visual (contador)
  - [ ] Bob responde comentário

- [ ] **Performance**
  - [ ] Feed carrega rápido com 10+ rotas
  - [ ] Likes/comentários atualizam instantaneamente
  - [ ] Sem erros no console

## 📝 Notas Finais

### Console do Navegador (F12)
Verificar logs:
- [x] "Loaded likes from Supabase: X total likes"
- [x] "Loaded comments from Supabase: X total comments"
- [x] "Route liked successfully" / "Route unliked successfully"
- [x] "Comment added successfully"

### Nenhum erro deve aparecer!

### Se algo falhar:
1. Verificar credenciais Supabase
2. Verificar RLS policies
3. Ver console do navegador
4. Ver logs do Supabase
5. Consultar SOCIAL_FEATURES_GUIDE.md

---

## ✅ Conclusão

Total de checks: **~100 itens**

Quando todos os checks estiverem ✅, sua rede social está funcionando perfeitamente! 🎉

**Próximo passo:** Convidar amigos reais para testar!
