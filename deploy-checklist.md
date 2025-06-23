# ✅ Render Deployment Checklist

## 🚀 Pre-deployment Checklist

### Local Testing
- [ ] Run `.\test-render.ps1` successfully
- [ ] Both frontend and backend build without errors
- [ ] Node.js version 20.16.0 installed
- [ ] pnpm 9.6.0 working

### Repository Preparation
- [ ] Push all changes to GitHub
- [ ] Repository is public or accessible to Render
- [ ] `render.yaml` file in root directory
- [ ] All build commands work locally

## 🔧 External Services Setup

### MongoDB Atlas
- [ ] Create free M0 cluster
- [ ] Create database user: `monkeytype`
- [ ] Set network access: `0.0.0.0/0`
- [ ] Copy connection string
- [ ] Database name: `monkeytype`

### ReCAPTCHA
- [ ] Get site key: `6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI` (test)
- [ ] Get secret key from Google ReCAPTCHA
- [ ] Or use test secret: `6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe`

### Firebase (Optional)
- [ ] Create Firebase project
- [ ] Enable Authentication > Email/Password
- [ ] Get web app config
- [ ] Generate service account key

## 🌐 Render Deployment

### Connect Repository
- [ ] Login to [Render Dashboard](https://dashboard.render.com)
- [ ] New → Blueprint
- [ ] Connect GitHub repository
- [ ] Render detects `render.yaml`

### Environment Variables

**Frontend (monkeytype-frontend):**
```
RECAPTCHA_SITE_KEY=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI
FIREBASE_APIKEY=(optional)
FIREBASE_AUTHDOMAIN=(optional)
FIREBASE_PROJECTID=(optional)
FIREBASE_STORAGEBUCKET=(optional)
FIREBASE_MESSAGINGSENDERID=(optional)
FIREBASE_APPID=(optional)
```

**Backend (monkeytype-backend):**
```
DB_URI=mongodb+srv://monkeytype:password@cluster.mongodb.net/monkeytype
RECAPTCHA_SECRET=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
FIREBASE_SERVICE_ACCOUNT_KEY={"type":"service_account",...}
```

### Service URLs (After Deployment)
- [ ] Frontend: `https://monkeytype-frontend.onrender.com`
- [ ] Backend: `https://monkeytype-backend.onrender.com`
- [ ] Redis: Auto-configured internally

## 🔍 Post-deployment Verification

### Frontend Tests
- [ ] Site loads successfully
- [ ] Typing test works
- [ ] Themes can be changed
- [ ] Settings persist
- [ ] Responsive design works

### Backend Tests
- [ ] API endpoints respond
- [ ] Database connection works
- [ ] Redis connection works
- [ ] User authentication (if enabled)

### Full Integration
- [ ] Frontend can communicate with backend
- [ ] Results can be saved (if user system enabled)
- [ ] No CORS errors
- [ ] Performance is acceptable

## 🛠️ Troubleshooting

### Common Issues
- [ ] Check Render service logs
- [ ] Verify environment variables
- [ ] Ensure MongoDB Atlas allows connections
- [ ] Check Node.js/pnpm versions
- [ ] Verify build commands

### Performance Optimization
- [ ] Enable Redis caching
- [ ] Configure CDN headers
- [ ] Monitor resource usage
- [ ] Consider upgrading to paid plans

## 📊 Expected Results

After successful deployment:

✅ **Full-stack Monkeytype application**
- Frontend static site serving typing tests
- Backend API handling requests
- Database storing user data (if enabled)
- Redis providing caching
- Complete typing game functionality

🎯 **Free Tier Resources:**
- Static Sites: Unlimited
- Web Services: 750 hours/month  
- Redis: 25MB memory
- Bandwidth: 100GB/month

---

**🎉 Success Criteria:** Monkeytype app fully functional on Render with all features working! 