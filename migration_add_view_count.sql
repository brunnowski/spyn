-- Migration: Add view_count column to routes table
-- Execute this in Supabase SQL Editor if your routes table already exists

-- Add view_count column if it doesn't exist
ALTER TABLE routes 
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0;

-- Update existing routes to have 0 views
UPDATE routes 
SET view_count = 0 
WHERE view_count IS NULL;

-- Verify the migration
SELECT id, name, view_count 
FROM routes 
LIMIT 5;
