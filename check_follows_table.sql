-- QUICK CHECK: Verificar se a tabela follows está configurada corretamente
-- Execute este SQL no Supabase SQL Editor

-- 1. Verificar se a tabela exists
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name = 'follows'
        ) THEN '✅ Tabela follows existe'
        ELSE '❌ Tabela follows NÃO existe - Execute database_setup.sql'
    END as status;

-- 2. Verificar structure da tabela
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns
WHERE table_name = 'follows'
ORDER BY ordinal_position;

-- 3. Verificar RLS policies
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'follows';

-- 4. Contar registros
SELECT 
    COUNT(*) as total_follows,
    COUNT(DISTINCT follower_id) as users_following,
    COUNT(DISTINCT following_id) as users_followed
FROM follows;

-- 5. Ver últimos follows
SELECT 
    follower_id,
    following_id,
    created_at
FROM follows
ORDER BY created_at DESC
LIMIT 10;

-- ============================================
-- SE A TABELA NÃO EXISTIR, execute este bloco:
-- ============================================

/*
CREATE TABLE IF NOT EXISTS follows (
  follower_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);

ALTER TABLE follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Follows are viewable by everyone"
  ON follows FOR SELECT
  USING (true);

CREATE POLICY "Users can follow others"
  ON follows FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Users can unfollow"
  ON follows FOR DELETE
  TO authenticated
  USING (auth.uid() = follower_id);

CREATE INDEX IF NOT EXISTS idx_follows_follower ON follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_following ON follows(following_id);
*/

-- ============================================
-- APÓS CRIAR/MODIFICAR A TABELA:
-- ============================================
-- IMPORTANTE: Vá para API > Reload schema cache no Dashboard do Supabase!
