-- Migration: Add user_name column to route_comments
-- Execute this in Supabase SQL Editor

-- Check if column exists, if not add it
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name='route_comments' 
        AND column_name='user_name'
    ) THEN
        ALTER TABLE route_comments 
        ADD COLUMN user_name TEXT NOT NULL DEFAULT 'Anonymous';
        
        -- Update existing comments with user names from profiles
        UPDATE route_comments rc
        SET user_name = COALESCE(
            (SELECT full_name FROM profiles WHERE id = rc.user_id),
            (SELECT email FROM auth.users WHERE id = rc.user_id),
            'Anonymous'
        );
    END IF;
END $$;

-- Verify the column was added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'route_comments';
