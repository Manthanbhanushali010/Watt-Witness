#!/bin/bash

# WattWitness GitHub Deployment Script
# This script will help deploy your WattWitness project to GitHub

echo "🚀 WattWitness GitHub Deployment Script"
echo "========================================"

# Check if remote origin exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "✅ GitHub remote already configured"
    echo "📤 Pushing to GitHub..."
    git push -u origin main
else
    echo "⚠️  GitHub remote not configured"
    echo "Please create a new repository on GitHub first, then run:"
    echo "git remote add origin https://github.com/yourusername/your-repo-name.git"
    echo "git push -u origin main"
fi

echo ""
echo "📝 After deployment, your WattWitness project will include:"
echo "   - 🔌 ESP32 firmware for power monitoring"
echo "   - 🍓 Raspberry Pi backend (Python/FastAPI)"
echo "   - ⚛️  React frontend dashboard"
echo "   - 🔗 Smart contracts for blockchain integration"
echo "   - 👂 Blockchain listener service"
echo ""
echo "✨ Happy coding with WattWitness!" 