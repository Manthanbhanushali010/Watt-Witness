# WattWitness Domain Configuration Update

## 🌐 Updating Your Domain Configuration

Since you need to deploy to a different domain, here's how to update all the configuration files:

### Step 1: Choose Your New Domain

Let's say you choose: `wattwitness.tech` (replace with your actual domain)

### Step 2: Update Configuration Files

#### Frontend Environment Variables
Update `RaspberryPi/frontend/production.env.example`:
```env
# API Configuration
VITE_API_URL=https://api.wattwitness.tech

# App Configuration
VITE_APP_NAME=WattWitness
VITE_APP_VERSION=1.0.0
VITE_APP_DESCRIPTION=Trust-minimized electricity meter using blockchain technology

# Production Settings
VITE_ENVIRONMENT=production
VITE_DEBUG=false
```

#### Backend Environment Variables
Update `RaspberryPi/backend/production.env.example`:
```env
# CORS Configuration
FRONTEND_URL=https://wattwitness.tech
ALLOWED_ORIGINS=https://wattwitness.tech,https://api.wattwitness.tech

# Other settings remain the same...
```

#### Vercel Configuration
Update `vercel.json`:
```json
{
  "version": 2,
  "name": "wattwitness-frontend",
  "env": {
    "VITE_API_URL": "https://api.wattwitness.tech",
    "VITE_APP_NAME": "WattWitness",
    "VITE_APP_VERSION": "1.0.0",
    "VITE_ENVIRONMENT": "production"
  }
}
```

#### GitHub Actions Workflow
Update `.github/workflows/deploy.yml`:
```yaml
env:
  VITE_API_URL: https://api.wattwitness.tech
  VITE_APP_NAME: WattWitness
  VITE_ENVIRONMENT: production
```

## 🚀 Quick Deployment Options

### Option A: Use Vercel's Free Domain (Immediate)
1. Deploy to Vercel → Get `your-project.vercel.app`
2. Deploy backend to Railway → Get `your-app.railway.app`
3. Update API URL in frontend to point to Railway URL
4. **Ready in 5 minutes!**

### Option B: Buy New Domain + Full Setup
1. Purchase domain (e.g., `wattwitness.tech`)
2. Update configuration files
3. Deploy to Vercel with custom domain
4. Configure DNS records
5. **Professional setup in 15 minutes**

### Option C: Use GitHub Pages (Free)
1. Deploy frontend to GitHub Pages
2. Use Railway for backend
3. Configure custom domain later
4. **Cost-effective solution**

## 🔧 Domain-Specific Instructions

### For wattwitness.tech (or your chosen domain):
```bash
# Update all configuration files
find . -name "*.json" -o -name "*.env*" -o -name "*.md" | xargs sed -i 's/wattwitness\.com/wattwitness.tech/g'

# Update API subdomain
find . -name "*.json" -o -name "*.env*" -o -name "*.md" | xargs sed -i 's/api\.wattwitness\.com/api.wattwitness.tech/g'
```

### DNS Configuration for Your New Domain:
```
# DNS Records to add:
A record: wattwitness.tech → Vercel IP
CNAME: api.wattwitness.tech → your-app.railway.app
CNAME: www.wattwitness.tech → wattwitness.tech
```

## 🎯 Recommended Next Steps:

1. **Immediate**: Deploy to free subdomains for testing
2. **Short-term**: Purchase a domain you like
3. **Long-term**: Build your own brand independent of any partnerships

Would you like me to help you with any of these options? 