#!/bin/bash

# WattWitness Production Deployment Script
# This script automates the deployment of WattWitness to production

set -e

echo "🚀 WattWitness Production Deployment"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if required tools are installed
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install git first."
        exit 1
    fi
    
    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install Node.js and npm first."
        exit 1
    fi
    
    # Check if python is installed
    if ! command -v python3 &> /dev/null; then
        print_error "Python 3 is not installed. Please install Python 3 first."
        exit 1
    fi
    
    print_status "All prerequisites are installed"
}

# Build frontend for production
build_frontend() {
    print_info "Building frontend for production..."
    
    cd RaspberryPi/frontend
    
    # Install dependencies
    print_info "Installing frontend dependencies..."
    npm install
    
    # Build for production
    print_info "Building frontend..."
    npm run build
    
    # Check if build was successful
    if [ -d "dist" ]; then
        print_status "Frontend build successful"
    else
        print_error "Frontend build failed"
        exit 1
    fi
    
    cd ../..
}

# Test backend
test_backend() {
    print_info "Testing backend..."
    
    cd RaspberryPi/backend
    
    # Install dependencies
    print_info "Installing backend dependencies..."
    pip install -r requirements.txt
    
    # Run tests if they exist
    if [ -d "tests" ]; then
        print_info "Running backend tests..."
        python -m pytest tests/ -v
    else
        print_warning "No tests found for backend"
    fi
    
    cd ../..
}

# Deploy to Vercel (Frontend)
deploy_frontend() {
    print_info "Deploying frontend to Vercel..."
    
    # Check if Vercel CLI is installed
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI not found. Installing..."
        npm install -g vercel
    fi
    
    # Deploy to Vercel
    vercel --prod
    
    print_status "Frontend deployed to Vercel"
}

# Deploy to Railway (Backend)
deploy_backend() {
    print_info "Deploying backend to Railway..."
    
    # Check if Railway CLI is installed
    if ! command -v railway &> /dev/null; then
        print_warning "Railway CLI not found. Installing..."
        npm install -g @railway/cli
    fi
    
    cd RaspberryPi/backend
    
    # Deploy to Railway
    railway up
    
    print_status "Backend deployed to Railway"
    
    cd ../..
}

# Update GitHub repository
update_github() {
    print_info "Updating GitHub repository..."
    
    # Add all changes
    git add .
    
    # Commit changes
    git commit -m "Production deployment: $(date)"
    
    # Push to GitHub
    git push origin main
    
    print_status "GitHub repository updated"
}

# Main deployment function
main() {
    echo "Starting production deployment process..."
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Build and test
    build_frontend
    test_backend
    
    # Update GitHub first
    update_github
    
    # Deploy to production
    print_info "Deploying to production environments..."
    deploy_frontend
    deploy_backend
    
    echo ""
    echo "🎉 Production deployment completed!"
    echo "=================================="
    echo ""
    echo "Your WattWitness platform is now live at:"
    echo "🌐 Frontend: https://wattwitness.com"
    echo "🔗 Backend API: https://api.wattwitness.com"
    echo "📚 GitHub: https://github.com/Manthanbhanushali010/Watt-Witness"
    echo ""
    echo "🔧 Next steps:"
    echo "1. Configure your domain DNS to point to Vercel"
    echo "2. Set up monitoring and analytics"
    echo "3. Configure SSL certificates"
    echo "4. Set up backup procedures"
    echo ""
    echo "✨ Your WattWitness platform is ready for everyone to use!"
}

# Run the main function
main "$@" 