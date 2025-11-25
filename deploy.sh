#!/bin/bash

# STPZ - GitHub Pages Deployment Script
# This script helps you deploy STPZ to GitHub Pages

echo "🚀 STPZ GitHub Pages Deployment"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo "❌ Error: index.html not found. Run this script from the project root."
    exit 1
fi

echo "✅ Project files found"
echo ""

# Check git status
echo "📋 Checking git status..."
git status --short
echo ""

# Prompt for Supabase configuration
echo "⚠️  IMPORTANT: Have you configured Supabase credentials in index.html?"
echo "   Look for SUPABASE_URL and SUPABASE_ANON_KEY around line 1650"
read -p "   Continue? (y/n): " supabase_check

if [ "$supabase_check" != "y" ]; then
    echo "❌ Please configure Supabase first, then run this script again."
    exit 1
fi

echo ""
echo "📦 Staging changes..."
git add .

echo ""
echo "💬 Creating commit..."
read -p "Enter commit message (or press Enter for default): " commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="feat: deploy with view counter and social features"
fi

git commit -m "$commit_msg"

echo ""
echo "🔄 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "📍 Next steps:"
echo "   1. Go to https://github.com/brunnowski/hyfa/settings/pages"
echo "   2. Set Source to 'GitHub Actions'"
echo "   3. Wait 2-3 minutes for deployment"
echo "   4. Visit https://brunnowski.github.io/hyfa/"
echo ""
echo "🎉 Your STPZ app will be live soon!"
