# 🚀 Deploy WattWitness with Render (5 minutes)

## Why Render is Perfect for WattWitness:

- **✅ FREE**: Generous free tier
- **✅ PYTHON-FRIENDLY**: Excellent Python/FastAPI support
- **✅ EASY**: Simple web interface
- **✅ RELIABLE**: Better uptime than Railway
- **✅ FAST**: Quick deployments
- **✅ SECURE**: Built-in SSL certificates

## 🎯 Step-by-Step Deployment

### Step 1: Deploy Backend to Render (2 minutes)

1. **Sign up**: Go to [render.com](https://render.com) and create account
2. **Create Web Service**:
   - Click "New +" → "Web Service"
   - Select "Build and deploy from a Git repository"
   - Connect your GitHub account
   - Select your `Watt-Witness` repository

3. **Configure Service**:
   - **Name**: `wattwitness-backend`
   - **Environment**: `Python 3`
   - **Root Directory**: `RaspberryPi/backend`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`

4. **Set Environment Variables**:
   ```env
   DATABASE_URL=postgresql://user:pass@host:port/db
   SECRET_KEY=your-secret-key-here
   FRONTEND_URL=https://wattwitness-frontend.vercel.app
   ALLOWED_ORIGINS=https://wattwitness-frontend.vercel.app,https://wattwitness-backend.onrender.com
   ENVIRONMENT=production
   DEBUG=false
   LOG_LEVEL=info
   API_V1_STR=/api/v1
   PROJECT_NAME=WattWitness
   ```

5. **Deploy**: Click "Create Web Service"
6. **Get URL**: Render will give you: `https://wattwitness-backend.onrender.com`

### Step 2: Deploy Frontend to Vercel (2 minutes)

1. **Sign up**: Go to [vercel.com](https://vercel.com) and create account
2. **Import Repository**:
   - Click "Import Git Repository"
   - Select your `Watt-Witness` repository
   - Set Root Directory: `RaspberryPi/frontend`
   - Click "Deploy"

3. **Set Environment Variables**:
   ```env
   VITE_API_URL=https://wattwitness-backend.onrender.com
   VITE_APP_NAME=WattWitness
   VITE_ENVIRONMENT=production
   ```

4. **Get URL**: Vercel will give you: `https://wattwitness-frontend.vercel.app`

### Step 3: Setup Database with Supabase (1 minute)

1. **Create Account**: Go to [supabase.com](https://supabase.com)
2. **Create Project**: New project → Choose region
3. **Setup Database**: 
   - Go to SQL Editor
   - Copy-paste contents of `RaspberryPi/backend/setup-production-db.sql`
   - Click "Run"
4. **Get Connection String**: 
   - Go to Settings → Database
   - Copy the connection string
   - Add to Render environment variables as `DATABASE_URL`

## 🎉 DONE! Your WattWitness is Live!

- **Frontend**: https://wattwitness-frontend.vercel.app
- **Backend**: https://wattwitness-backend.onrender.com
- **Database**: Managed by Supabase

## 🔧 Render-Specific Benefits:

### **Auto-Deploy from GitHub**
- Every push to main branch auto-deploys
- No manual CLI commands needed
- Built-in CI/CD pipeline

### **Health Checks**
- Automatic health monitoring
- Auto-restart on failures
- Built-in logging and metrics

### **Free Tier Includes**:
- 750 hours/month (enough for 24/7)
- Custom domains
- SSL certificates
- GitHub integration
- Environment variables

### **Easy Scaling**
- Upgrade to paid plan for more resources
- Auto-scaling available
- Multiple regions supported

## 🚀 Pro Tips for Render:

1. **Startup Time**: Free tier has ~30 second cold start
2. **Logs**: Check logs in Render dashboard for debugging
3. **Health Check**: Backend includes `/health` endpoint
4. **Environment**: Use environment variables for secrets
5. **Domains**: Add custom domain later in Render settings

## 🔄 Update Process:

1. Push changes to GitHub
2. Render auto-deploys backend
3. Vercel auto-deploys frontend
4. Zero downtime updates!

## 🌟 Your WattWitness Platform Features:

- **Real-time Solar Dashboard** with live monitoring
- **Blockchain Integration** via Chainlink
- **Mobile Responsive** design
- **API Access** for developers
- **Demo Mode** for public access
- **Professional UI** with beautiful design

**Ready to deploy? Follow the steps above and your WattWitness platform will be live in 5 minutes!** 🚀 