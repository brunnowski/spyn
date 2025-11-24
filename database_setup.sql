-- SPYN Database Setup
-- Execute this SQL in your Supabase SQL Editor

-- ============================================
-- 1. CREATE TABLES
-- ============================================

-- Routes table (already exists, but let's ensure it has the right structure)
CREATE TABLE IF NOT EXISTS routes (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  waypoints JSONB NOT NULL,
  created TIMESTAMPTZ DEFAULT NOW(),
  photo_count INTEGER,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT
);

-- User profiles table (extended user data)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE,
  full_name TEXT,
  bio TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Follows table (for social network features)
CREATE TABLE IF NOT EXISTS follows (
  follower_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);

-- Likes table (users can like routes)
CREATE TABLE IF NOT EXISTS route_likes (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  route_id TEXT REFERENCES routes(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (user_id, route_id)
);

-- Comments table (users can comment on routes)
CREATE TABLE IF NOT EXISTS route_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id TEXT REFERENCES routes(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  comment TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. ENABLE ROW LEVEL SECURITY
-- ============================================

ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE route_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE route_comments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3. DROP EXISTING POLICIES (if any conflicts)
-- ============================================

DROP POLICY IF EXISTS "Routes are viewable by everyone" ON routes;
DROP POLICY IF EXISTS "Authenticated users can insert routes" ON routes;
DROP POLICY IF EXISTS "Users can update their own routes" ON routes;
DROP POLICY IF EXISTS "Users can delete their own routes" ON routes;

DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- ============================================
-- 4. CREATE RLS POLICIES
-- ============================================

-- ROUTES POLICIES
CREATE POLICY "Routes are viewable by everyone"
  ON routes FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can insert routes"
  ON routes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own routes"
  ON routes FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own routes"
  ON routes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- PROFILES POLICIES
CREATE POLICY "Profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- FOLLOWS POLICIES
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

-- ROUTE LIKES POLICIES
CREATE POLICY "Likes are viewable by everyone"
  ON route_likes FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can like routes"
  ON route_likes FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike routes"
  ON route_likes FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ROUTE COMMENTS POLICIES
CREATE POLICY "Comments are viewable by everyone"
  ON route_comments FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can comment"
  ON route_comments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments"
  ON route_comments FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- ============================================
-- 5. CREATE INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_routes_user_id ON routes(user_id);
CREATE INDEX IF NOT EXISTS idx_routes_created ON routes(created DESC);

CREATE INDEX IF NOT EXISTS idx_profiles_username ON profiles(username);

CREATE INDEX IF NOT EXISTS idx_follows_follower ON follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_following ON follows(following_id);

CREATE INDEX IF NOT EXISTS idx_route_likes_route ON route_likes(route_id);
CREATE INDEX IF NOT EXISTS idx_route_likes_user ON route_likes(user_id);

CREATE INDEX IF NOT EXISTS idx_route_comments_route ON route_comments(route_id);
CREATE INDEX IF NOT EXISTS idx_route_comments_user ON route_comments(user_id);

-- ============================================
-- 6. CREATE FUNCTIONS
-- ============================================

-- Function to automatically create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, username)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'name',
    LOWER(SPLIT_PART(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Trigger to create profile on user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to get user stats
CREATE OR REPLACE FUNCTION get_user_stats(user_uuid UUID)
RETURNS JSON AS $$
DECLARE
  stats JSON;
BEGIN
  SELECT json_build_object(
    'routes_count', (SELECT COUNT(*) FROM routes WHERE user_id = user_uuid),
    'followers_count', (SELECT COUNT(*) FROM follows WHERE following_id = user_uuid),
    'following_count', (SELECT COUNT(*) FROM follows WHERE follower_id = user_uuid),
    'likes_received', (
      SELECT COUNT(*) 
      FROM route_likes 
      WHERE route_id IN (SELECT id FROM routes WHERE user_id = user_uuid)
    )
  ) INTO stats;
  RETURN stats;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- 7. CREATE VIEWS FOR FEED
-- ============================================

-- View for route feed with like counts
CREATE OR REPLACE VIEW route_feed AS
SELECT 
  r.*,
  p.username,
  p.avatar_url,
  (SELECT COUNT(*) FROM route_likes WHERE route_id = r.id) as likes_count,
  (SELECT COUNT(*) FROM route_comments WHERE route_id = r.id) as comments_count
FROM routes r
LEFT JOIN profiles p ON r.user_id = p.id
ORDER BY r.created DESC;

-- Grant access to authenticated users
GRANT SELECT ON route_feed TO authenticated;
GRANT SELECT ON route_feed TO anon;

-- ============================================
-- DONE! Your database is ready for SPYN
-- ============================================

-- Test the setup with:
-- SELECT * FROM profiles;
-- SELECT * FROM routes;
-- SELECT * FROM route_feed LIMIT 10;
