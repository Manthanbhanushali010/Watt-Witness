# WattWitness Production Deployment Guide

## 🚀 Production Architecture Overview

This guide will help you deploy your WattWitness project to production using the domain `wattwitness.com`.

### Architecture Components:
- **Frontend**: React app deployed to Vercel/Netlify (wattwitness.com)
- **Backend**: FastAPI deployed to Railway/Render/DigitalOcean (api.wattwitness.com)
- **Database**: PostgreSQL (managed database service)
- **Domain**: wattwitness.com with subdomain routing

## 📋 Step-by-Step Deployment

### Phase 1: Backend Production Deployment

#### Option A: Deploy to Railway (Recommended)
1. **Create Railway Account**: Sign up at railway.app
2. **Deploy Backend**: 
   ```bash
   # Install Railway CLI
   npm install -g @railway/cli
   
   # Login and deploy
   railway login
   cd RaspberryPi/backend
   railway deploy
   ```

#### Option B: Deploy to Render
1. **Create Render Account**: Sign up at render.com
2. **Connect GitHub**: Link your repository
3. **Create Web Service**: Select backend folder
4. **Configure Build**: 
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`

### Phase 2: Database Setup

#### PostgreSQL Database (Recommended: Supabase)
1. **Create Supabase Account**: Sign up at supabase.com
2. **Create New Project**: Get connection string
3. **Configure Database**: Use provided connection string

### Phase 3: Frontend Production Deployment

#### Deploy to Vercel (Recommended)
1. **Create Vercel Account**: Sign up at vercel.com
2. **Import Repository**: Connect GitHub repository
3. **Configure Build**:
   - Framework: Vite
   - Root Directory: RaspberryPi/frontend
   - Build Command: `npm run build`
   - Output Directory: `dist`

### Phase 4: Domain Configuration

#### Custom Domain Setup
1. **Add Domain**: In Vercel dashboard, add `wattwitness.com`
2. **Configure DNS**: Point domain to Vercel
3. **SSL Certificate**: Automatically handled by Vercel

## 🔧 Production Configuration Files

### Backend Environment Variables
```env
# Database
DATABASE_URL=postgresql://user:password@host:port/database

# API Configuration
API_V1_STR=/api/v1
PROJECT_NAME=WattWitness
SECRET_KEY=your-production-secret-key-here
ACCESS_TOKEN_EXPIRE_MINUTES=10080

# CORS Configuration
FRONTEND_URL=https://wattwitness.com
ALLOWED_ORIGINS=https://wattwitness.com,https://api.wattwitness.com

# Blockchain Configuration
CHAIN_RPC_URL=your-blockchain-rpc-url
CONTRACT_ADDRESS=your-contract-address
```

### Frontend Environment Variables
```env
# API Configuration
VITE_API_URL=https://api.wattwitness.com

# App Configuration
VITE_APP_NAME=WattWitness
VITE_APP_VERSION=1.0.0
```

## 🛠️ Production Optimizations

### Backend Optimizations
- **Database Connection Pooling**: Configure SQLAlchemy pool
- **CORS Configuration**: Restrict to production domains
- **Rate Limiting**: Implement API rate limiting
- **Logging**: Configure production logging
- **Health Checks**: Add comprehensive health endpoints

### Frontend Optimizations
- **Build Optimization**: Enable production optimizations
- **Asset Compression**: Gzip/Brotli compression
- **CDN Integration**: Use Vercel Edge Network
- **Performance Monitoring**: Add analytics and monitoring

## 📊 Monitoring & Analytics

### Backend Monitoring
- **Health Checks**: `/health` endpoint
- **Database Monitoring**: Connection pool status
- **API Metrics**: Response times and error rates

### Frontend Monitoring
- **Performance Monitoring**: Core Web Vitals
- **Error Tracking**: Production error logging
- **User Analytics**: Usage patterns and engagement

## 🔒 Security Considerations

### Backend Security
- **Environment Variables**: Never commit secrets
- **HTTPS Only**: Force HTTPS in production
- **API Authentication**: Implement proper auth
- **Input Validation**: Validate all inputs
- **Rate Limiting**: Prevent API abuse

### Frontend Security
- **Content Security Policy**: Implement CSP headers
- **HTTPS Enforcement**: Force HTTPS
- **Secure Headers**: Add security headers
- **Input Sanitization**: Sanitize user inputs

## 🚀 Deployment Checklist

### Pre-Deployment
- [ ] Test all endpoints locally
- [ ] Configure production environment variables
- [ ] Set up production database
- [ ] Configure domain DNS
- [ ] Set up SSL certificates

### Post-Deployment
- [ ] Test all functionality in production
- [ ] Verify database connections
- [ ] Check API endpoints
- [ ] Validate frontend-backend integration
- [ ] Monitor system performance
- [ ] Set up backup procedures

## 📱 Making It Accessible to Everyone

### Public Access Features
- **Demo Mode**: Allow users to explore without hardware
- **Documentation**: Comprehensive user guides
- **API Documentation**: Public API docs
- **Open Source**: GitHub repository access
- **Community**: Discord/Slack community

### User Experience
- **Mobile Responsive**: Works on all devices
- **Fast Loading**: Optimized performance
- **Intuitive Interface**: Easy to use
- **Real-time Updates**: Live data streaming
- **Error Handling**: Graceful error messages

## 🎯 Next Steps

1. **Choose Hosting Providers**: Select backend and frontend hosts
2. **Set Up Databases**: Configure production PostgreSQL
3. **Configure Domains**: Set up wattwitness.com routing
4. **Deploy Applications**: Deploy backend and frontend
5. **Test Everything**: Comprehensive testing
6. **Monitor Performance**: Set up monitoring
7. **Launch Publicly**: Make accessible to everyone

## 🔄 Continuous Deployment

### GitHub Actions Workflow
- **Automatic Deployment**: On push to main branch
- **Testing**: Run tests before deployment
- **Rollback**: Easy rollback on failures
- **Notifications**: Deployment status notifications

This guide will help you transform your WattWitness project from a development setup into a fully production-ready platform accessible at wattwitness.com! 