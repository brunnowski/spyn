-- Troubleshooting Guide for Follow System
-- Execute these queries in Supabase SQL Editor to diagnose issues

-- 1. Check if follows table exists
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'follows';

-- 2. Check if RLS is enabled on follows table
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'follows';

-- 3. Check existing policies on follows table
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'follows';

-- 4. Test if you can insert a follow (replace UUIDs with real user IDs)
-- First, get some real user IDs:
SELECT id, email FROM auth.users LIMIT 5;

-- Then test insert (use actual IDs from above):
-- INSERT INTO follows (follower_id, following_id) 
-- VALUES ('your-user-id', 'another-user-id');

-- 5. Check existing follows
SELECT * FROM follows LIMIT 10;

-- 6. If table doesn't exist, create it:
-- Run the commands from database_setup.sql lines 32-39

-- 7. If RLS policies don't exist, create them:
-- Run the commands from database_setup.sql lines 122-134

-- 8. Force reload schema cache in Supabase:
-- Go to: Project Settings → API → Reload schema cache button

-- Common Issues and Solutions:

-- ISSUE: "relation public.follows does not exist"
-- SOLUTION: Run the CREATE TABLE command from database_setup.sql

-- ISSUE: "permission denied for table follows"
-- SOLUTION: Check RLS policies are created and RLS is enabled

-- ISSUE: "new row violates row-level security policy"
-- SOLUTION: Make sure you're authenticated and policies allow the operation

-- ISSUE: Follow button does nothing
-- SOLUTION: 
--   1. Open browser console (F12)
--   2. Look for JavaScript errors
--   3. Check if currentUser is set (console.log should show it)
--   4. Verify Supabase credentials are correct in index.html
