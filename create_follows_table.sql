-- Create follows table for user follow/follower relationships
CREATE TABLE IF NOT EXISTS follows (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    follower_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    followed_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(follower_id, followed_id),
    CHECK (follower_id != followed_id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_follows_follower ON follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_followed ON follows(followed_id);

-- Enable Row Level Security
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view follows (public information)
CREATE POLICY "Anyone can view follows" ON follows
    FOR SELECT
    USING (true);

-- Policy: Users can only insert their own follows
CREATE POLICY "Users can follow others" ON follows
    FOR INSERT
    WITH CHECK (auth.uid() = follower_id);

-- Policy: Users can only delete their own follows
CREATE POLICY "Users can unfollow" ON follows
    FOR DELETE
    USING (auth.uid() = follower_id);
