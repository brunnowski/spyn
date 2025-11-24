# 🌐 SPYN - Guia de Acesso Multi-Dispositivo

## URLs do Projeto

### GitHub Pages (Produção)
- **URL:** https://brunnowski.github.io/hyfa/
- **Status:** Deploy automático via GitHub Actions
- **Uso:** Acesso público em qualquer dispositivo com internet

### Codespace (Desenvolvimento)
- **URL:** https://orange-goggles-7wj9rvvrrj4hq7r-8000.app.github.dev
- **Status:** Temporário (ativo apenas quando Codespace está rodando)
- **Uso:** Desenvolvimento e testes rápidos

---

## 🔧 Configuração do Supabase

Para que a autenticação funcione corretamente, adicione as seguintes URLs no Supabase:

### Site URL
```
https://brunnowski.github.io
```

### Redirect URLs (adicione TODAS)
```
http://localhost:8000
http://localhost:3000
https://brunnowski.github.io/hyfa/
https://orange-goggles-7wj9rvvrrj4hq7r-8000.app.github.dev
```

### Como configurar:
1. Acesse: https://supabase.com/dashboard
2. Selecione seu projeto
3. Vá em: **Authentication** → **URL Configuration**
4. Adicione as URLs acima em **Redirect URLs**
5. Salve as alterações

---

## 📱 Testando em Diferentes Dispositivos

### Desktop/Laptop
- Chrome, Firefox, Safari, Edge
- Acesse: https://brunnowski.github.io/hyfa/

### Smartphone (iOS/Android)
1. Abra o navegador (Safari, Chrome, Firefox)
2. Digite: `https://brunnowski.github.io/hyfa/`
3. Para melhor experiência, adicione à tela inicial:
   - **iOS:** Toque em "Compartilhar" → "Adicionar à Tela de Início"
   - **Android:** Menu → "Adicionar à tela inicial"

### Tablet (iPad/Android)
- Mesma URL: https://brunnowski.github.io/hyfa/
- Layout responsivo se adapta automaticamente

---

## 🧪 Cenários de Teste Multi-Dispositivo

### 1. Criar Conta e Login
- [ ] Criar conta no desktop
- [ ] Fazer login no smartphone
- [ ] Verificar sincronização de dados

### 2. Criar Rota
- [ ] Criar rota com fotos no smartphone (usando câmera)
- [ ] Visualizar rota criada no desktop
- [ ] Editar/deletar do tablet

### 3. Interações Sociais
- [ ] Curtir rota no smartphone
- [ ] Comentar no desktop
- [ ] Ver notificações no tablet
- [ ] Clicar em perfil de usuário

### 4. Performance
- [ ] Testar carregamento de feed com 10+ rotas
- [ ] Verificar renderização de mini-mapas
- [ ] Testar em conexão 3G/4G/5G/WiFi

---

## 🚀 Deploy e Updates

### Deploy Automático
Toda vez que você faz `git push origin main`:
1. GitHub Actions é acionado
2. Código é construído e testado
3. Deploy para GitHub Pages em ~2-3 minutos
4. URL pública atualizada automaticamente

### Verificar Status do Deploy
```bash
gh run list --limit 5
```

### Ver Logs do Deploy
```bash
gh run view
```

---

## 🔍 Troubleshooting

### Erro de Autenticação
- Verifique se todas as redirect URLs estão configuradas no Supabase
- Limpe cache do navegador
- Teste em janela anônima

### Mini-mapas não carregam
- Verifique conexão com internet
- OpenStreetMap pode estar temporariamente lento
- Mapas têm fallback para linha reta se OSRM falhar

### Performance lenta
- Minimize fotos antes de upload
- Use conexão WiFi para upload de múltiplas fotos
- Limpe histórico do navegador

---

## 📊 Dados de Teste

Use estes scripts SQL (no Supabase SQL Editor) para criar dados de teste:

```sql
-- Ver o arquivo test_data.sql na raiz do projeto
```

---

## 🌟 Próximos Passos

1. **PWA (Progressive Web App)**
   - Adicionar service worker
   - Cache offline
   - Instalável como app nativo

2. **Notificações Push**
   - Notificar quando alguém curte sua rota
   - Notificar novos comentários

3. **Compartilhamento**
   - Integração com Web Share API
   - QR Code para rotas

---

## 📞 Suporte

- **Repositório:** https://github.com/brunnowski/hyfa
- **Issues:** https://github.com/brunnowski/hyfa/issues
- **Documentação:** Ver README.md

---

**Última atualização:** 24/11/2025
