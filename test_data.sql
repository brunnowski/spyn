-- Test Data for SPYN Social Features
-- Execute AFTER database_setup.sql and AFTER creating at least 2 test users

-- ============================================
-- HELPER: Get User IDs
-- ============================================
-- First, find your test user IDs:
-- SELECT id, email FROM auth.users;

-- ============================================
-- EXAMPLE: Insert Test Data (REPLACE UUIDs)
-- ============================================

-- Replace these with your actual user UUIDs
-- User 1: 'user-uuid-1-here'
-- User 2: 'user-uuid-2-here'

-- Example Routes (adjust user_id and user_name to match your users)
/*
INSERT INTO routes (id, name, description, waypoints, user_id, user_name, photo_count, created) VALUES
(
  'test-route-1',
  'Morning Run in Central Park',
  'Beautiful sunny morning run through the park',
  '[
    {"lat": 40.785091, "lng": -73.968285, "timestamp": 1700000000000, "dateTime": "2024-11-15T08:30:00Z"},
    {"lat": 40.768731, "lng": -73.981681, "timestamp": 1700000300000, "dateTime": "2024-11-15T08:35:00Z"},
    {"lat": 40.764896, "lng": -73.972967, "timestamp": 1700000600000, "dateTime": "2024-11-15T08:40:00Z"}
  ]'::jsonb,
  'user-uuid-1-here',
  'Alice',
  3,
  NOW() - INTERVAL '2 days'
),
(
  'test-route-2',
  'Beach Sunset Walk',
  'Relaxing walk along the beach at sunset',
  '[
    {"lat": 34.024212, "lng": -118.496475, "timestamp": 1700100000000, "dateTime": "2024-11-16T18:00:00Z"},
    {"lat": 34.016431, "lng": -118.491622, "timestamp": 1700100300000, "dateTime": "2024-11-16T18:05:00Z"}
  ]'::jsonb,
  'user-uuid-1-here',
  'Alice',
  2,
  NOW() - INTERVAL '1 day'
),
(
  'test-route-3',
  'Mountain Trail Adventure',
  'Challenging but rewarding mountain trail',
  '[
    {"lat": 36.123456, "lng": -115.987654, "timestamp": 1700200000000, "dateTime": "2024-11-17T10:00:00Z"},
    {"lat": 36.125678, "lng": -115.989876, "timestamp": 1700200300000, "dateTime": "2024-11-17T10:05:00Z"},
    {"lat": 36.127890, "lng": -115.991098, "timestamp": 1700200600000, "dateTime": "2024-11-17T10:10:00Z"},
    {"lat": 36.129012, "lng": -115.992210, "timestamp": 1700200900000, "dateTime": "2024-11-17T10:15:00Z"}
  ]'::jsonb,
  'user-uuid-2-here',
  'Bob',
  4,
  NOW()
);

-- Example Likes
INSERT INTO route_likes (user_id, route_id) VALUES
('user-uuid-1-here', 'test-route-3'),  -- Alice likes Bob's route
('user-uuid-2-here', 'test-route-1'),  -- Bob likes Alice's first route
('user-uuid-2-here', 'test-route-2');  -- Bob likes Alice's second route

-- Example Comments
INSERT INTO route_comments (route_id, user_id, user_name, comment) VALUES
('test-route-1', 'user-uuid-2-here', 'Bob', 'Great photos! Love the scenery 🌟'),
('test-route-2', 'user-uuid-2-here', 'Bob', 'Beautiful sunset! 🌅'),
('test-route-3', 'user-uuid-1-here', 'Alice', 'Looks challenging but amazing! 🏔️'),
('test-route-3', 'user-uuid-1-here', 'Alice', 'How long did it take you?');
*/

-- ============================================
-- QUERIES TO VIEW TEST DATA
-- ============================================

-- View all routes with stats
SELECT 
  r.name,
  r.user_name as creator,
  (SELECT COUNT(*) FROM route_likes WHERE route_id = r.id) as likes,
  (SELECT COUNT(*) FROM route_comments WHERE route_id = r.id) as comments,
  r.created
FROM routes r
ORDER BY r.created DESC;

-- View all interactions
SELECT 
  'LIKE' as type,
  r.name as route_name,
  r.user_name as route_owner,
  u.email as interacted_by,
  rl.created_at as when
FROM route_likes rl
JOIN routes r ON rl.route_id = r.id
JOIN auth.users u ON rl.user_id = u.id

UNION ALL

SELECT 
  'COMMENT' as type,
  r.name as route_name,
  r.user_name as route_owner,
  rc.user_name as interacted_by,
  rc.created_at as when
FROM route_comments rc
JOIN routes r ON rc.route_id = r.id
ORDER BY when DESC;

-- ============================================
-- CLEANUP (if needed)
-- ============================================

-- Delete all test data (use with caution!)
/*
DELETE FROM route_comments WHERE route_id LIKE 'test-route-%';
DELETE FROM route_likes WHERE route_id LIKE 'test-route-%';
DELETE FROM routes WHERE id LIKE 'test-route-%';
*/
