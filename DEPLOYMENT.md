# 🚀 Deploying STPZ to GitHub Pages

## Quick Setup

Your project is **already configured** for GitHub Pages! Just follow these steps:

### 1. Enable GitHub Pages

1. Go to your repository: https://github.com/brunnowski/hyfa
2. Click **Settings** → **Pages** (left sidebar)
3. Under "Build and deployment":
   - **Source**: Select "GitHub Actions"
4. Click **Save**

### 2. Push Your Changes

```bash
git add .
git commit -m "feat: add view counter and GitHub Pages deployment"
git push origin main
```

### 3. Wait for Deployment

- Go to the **Actions** tab in your repository
- Watch the "Deploy to GitHub Pages" workflow run
- Once complete (✅ green checkmark), your site is live!

### 4. Access Your Site

Your STPZ app will be available at:
```
https://brunnowski.github.io/hyfa/
```

## 📋 Pre-Deployment Checklist

Before going live, make sure you:

### ✅ Configure Supabase (REQUIRED for production)

1. Open `index.html`
2. Find these lines (around line 1650):
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace with your actual Supabase credentials
4. **Important**: Add your GitHub Pages URL to Supabase Authentication settings:
   - Go to Supabase Dashboard → Authentication → URL Configuration
   - Add `https://brunnowski.github.io` to **Site URL**
   - Add `https://brunnowski.github.io/hyfa/**` to **Redirect URLs**

### ✅ Run Database Migration

Execute the migration in Supabase SQL Editor:
```sql
-- Add view_count column
ALTER TABLE routes 
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0;

UPDATE routes 
SET view_count = 0 
WHERE view_count IS NULL;
```

### ✅ Test Locally First

```bash
# Start local server
python3 -m http.server 8000

# Open in browser
# Visit: http://localhost:8000
```

## 🔧 Configuration Files

Your project includes:

- ✅ `.github/workflows/deploy.yml` - Auto-deployment workflow
- ✅ `index.html` - Single-file SPA (no build step needed!)
- ✅ `database_setup.sql` - Complete database schema
- ✅ `migration_add_view_count.sql` - View counter migration

## 🌐 Custom Domain (Optional)

Want to use a custom domain like `stpz.app`?

1. Buy a domain from any registrar
2. In GitHub: Settings → Pages → Custom domain
3. Add your domain and follow DNS setup instructions
4. Update Supabase redirect URLs accordingly

## 📊 Features Available on GitHub Pages

All features work on GitHub Pages:
- ✅ Interactive maps (Maplibre GL)
- ✅ User authentication (Supabase Auth)
- ✅ Route creation & sharing
- ✅ Social features (likes, comments, follows)
- ✅ Photo uploads (base64 encoded)
- ✅ View counter & analytics
- ✅ OSRM routing
- ✅ Mobile responsive

## 🐛 Troubleshooting

### Site not loading?
- Check Actions tab for deployment errors
- Verify GitHub Pages is enabled in Settings
- Wait 2-3 minutes after first deployment

### Authentication not working?
- Verify Supabase credentials in `index.html`
- Check redirect URLs in Supabase dashboard
- Must include GitHub Pages URL

### Maps not showing?
- Maplibre GL loads from CDN (no API key needed!)
- Check browser console for errors
- Ensure https:// (not http://)

## 🔒 Security Notes

⚠️ **Important**: Your Supabase `ANON_KEY` will be visible in the HTML source. This is normal for frontend apps, but:

1. Use Row Level Security (RLS) in Supabase
2. The anon key has limited permissions
3. Never expose your `SERVICE_ROLE` key in frontend code
4. Configure proper authentication policies in Supabase

## 📈 Monitoring

After deployment, you can:
- View deployment history in Actions tab
- Monitor usage in Supabase Dashboard
- Check errors in browser DevTools console
- Share with testers immediately!

## 🎉 That's It!

Your STPZ app is now live and accessible worldwide. Share the link with friends and start testing!

---

**Next Steps:**
1. Enable GitHub Pages (see step 1 above)
2. Add Supabase credentials
3. Push to main branch
4. Share `https://brunnowski.github.io/hyfa/` with testers! 🚀
