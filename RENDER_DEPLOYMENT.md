# 🚀 Deploy Monkeytype lên Render

Hướng dẫn complete deployment cho dự án Monkeytype full-stack lên Render platform.

## 📋 Tổng quan

Deployment này bao gồm:
- **Frontend**: Static site (React/Vite)
- **Backend**: Node.js web service
- **Database**: PostgreSQL (MongoDB không supported, dùng MongoDB Atlas)
- **Redis**: In-memory cache
- **Full-stack**: Complete typing application

## 🔧 Bước 1: Chuẩn bị

### 1.1 Yêu cầu
- [GitHub repository](https://github.com) public/private
- [Render account](https://render.com)
- [MongoDB Atlas account](https://www.mongodb.com/atlas) (cho database)

### 1.2 Cấu trúc files
```
monkeytype/
├── render.yaml          # Multi-service config
├── pnpm-workspace.yaml  # Workspace config
├── package.json         # Root scripts
├── frontend/            # Frontend app
└── backend/            # Backend API
```

## 🌐 Bước 2: Setup MongoDB Atlas

**Tại sao MongoDB Atlas?**
Render không support MongoDB native, nên cần external database.

### 2.1 Tạo MongoDB Atlas
1. Đăng ký [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Tạo **Free Cluster** (M0)
3. Tạo **Database User**:
   - Username: `monkeytype`
   - Password: `[generate secure password]`
4. **Network Access**: Add `0.0.0.0/0` (allow from anywhere)
5. **Connect**: Copy connection string
   ```
   mongodb+srv://monkeytype:<password>@cluster0.xxxxx.mongodb.net/monkeytype
   ```

### 2.2 Cấu hình Database
1. **Database name**: `monkeytype`
2. **Collections**: Sẽ tự tạo khi app chạy
3. **Security**: Lưu connection string an toàn

## 🚀 Bước 3: Deploy lên Render

### 3.1 Connect Repository
1. Login [Render Dashboard](https://dashboard.render.com)
2. Click **"New"** → **"Blueprint"**
3. Connect GitHub repository
4. Render sẽ detect `render.yaml` tự động

### 3.2 Configure Services

**Render sẽ tự động tạo:**
- ✅ `monkeytype-frontend` (Static Site)
- ✅ `monkeytype-backend` (Web Service)  
- ✅ `monkeytype-redis` (Redis)

### 3.3 Set Environment Variables

**Sau khi services tạo, configure:**

#### Frontend Environment Variables:
| Variable | Value | Required |
|----------|-------|----------|
| `RECAPTCHA_SITE_KEY` | `6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI` | ✅ Yes |
| `FIREBASE_APIKEY` | `your_api_key` | 🔶 Optional |
| `FIREBASE_AUTHDOMAIN` | `your_domain.firebaseapp.com` | 🔶 Optional |
| `FIREBASE_PROJECTID` | `your_project_id` | 🔶 Optional |
| `FIREBASE_STORAGEBUCKET` | `your_bucket.appspot.com` | 🔶 Optional |
| `FIREBASE_MESSAGINGSENDERID` | `your_sender_id` | 🔶 Optional |
| `FIREBASE_APPID` | `your_app_id` | 🔶 Optional |

#### Backend Environment Variables:
| Variable | Value | Required |
|----------|-------|----------|
| `DB_URI` | `mongodb+srv://monkeytype:password@cluster.mongodb.net/monkeytype` | ✅ Yes |
| `RECAPTCHA_SECRET` | `your_recaptcha_secret` | ✅ Yes |
| `FIREBASE_SERVICE_ACCOUNT_KEY` | `{"type":"service_account",...}` | 🔶 Optional |

## 🔥 Bước 4: Cấu hình Firebase (Tùy chọn)

### 4.1 Tạo Firebase Project
1. [Firebase Console](https://console.firebase.google.com/)
2. Create project: **"monkeytype"**
3. Disable Google Analytics

### 4.2 Enable Authentication
1. **Authentication > Sign-in method**
2. Enable **Email/Password**
3. Save

### 4.3 Get Configuration
1. **Project Settings** ⚙️
2. **Your apps** → Add **Web app**
3. Copy config object
4. Paste values vào Render Environment Variables

### 4.4 Service Account Key
1. **Project Settings > Service accounts**
2. **Generate new private key**
3. Download JSON file
4. Copy entire JSON content vào `FIREBASE_SERVICE_ACCOUNT_KEY`

## ⚙️ Bước 5: Build Process

### 5.1 Frontend Build
```bash
corepack enable
pnpm install
pnpm build-fe
# Output: frontend/dist/
```

### 5.2 Backend Build
```bash
corepack enable
pnpm install 
pnpm build-be
# Output: backend/dist/
```

### 5.3 Backend Start
```bash
cd backend
npm start
# Runs: node ./dist/server.js
```

## 🔍 Bước 6: Verification

### 6.1 Check Services
1. **Frontend**: `https://monkeytype-frontend.onrender.com`
   - ✅ Typing test loads
   - ✅ Themes work
   - ✅ Settings save

2. **Backend**: `https://monkeytype-backend.onrender.com`
   - ✅ API responds
   - ✅ Database connected
   - ✅ Redis connected

### 6.2 Test Features
- ✅ **Typing tests**: All modes work
- ✅ **Themes**: Switching works
- ✅ **Settings**: Persist in localStorage
- ✅ **Responsive**: Mobile/desktop
- ✅ **Performance**: Fast loading

## 🎯 Bước 7: Custom Domain (Tùy chọn)

### 7.1 Add Domain
1. **Render Service > Settings > Custom Domains**
2. Add your domain: `yourdomain.com`
3. Configure DNS:
   ```
   CNAME  www  monkeytype-frontend.onrender.com
   A      @    216.24.57.1
   ```

## 💰 Pricing & Resources

### Free Tier Limits:
- **Static Sites**: Unlimited
- **Web Services**: 750 hours/month
- **Redis**: 25MB memory
- **Bandwidth**: 100GB/month

### Paid Plans:
- **Web Service**: $7/month (always on)
- **Redis**: $7/month (256MB)
- **MongoDB Atlas**: Free M0 cluster

## 🛠️ Troubleshooting

### Build Fails
```bash
# Check Node.js version
node --version  # Should be 20.16.0

# Local test
pnpm install
pnpm build-fe
pnpm build-be
```

### Service Won't Start
1. Check **Logs** trong Render Dashboard
2. Verify environment variables
3. Ensure MongoDB Atlas allows connections
4. Check Redis connection

### Database Connection Issues
1. Verify MongoDB Atlas connection string
2. Check IP whitelist (0.0.0.0/0)
3. Verify database user credentials
4. Test connection locally

### Frontend/Backend Communication
1. Check CORS settings trong backend
2. Verify BACKEND_URL trong frontend
3. Ensure both services deployed successfully

## 📚 Useful Commands

```bash
# Local development
pnpm dev                # Start all services
pnpm dev-fe            # Frontend only
pnpm dev-be            # Backend only

# Build
pnpm build             # Build all
pnpm build-fe          # Frontend only  
pnpm build-be          # Backend only

# Test
pnpm test              # Run tests
pnpm lint              # Check code quality
```

## 🚀 Deployment Status

After successful deployment:

- **Frontend**: ✅ `https://monkeytype-frontend.onrender.com`
- **Backend**: ✅ `https://monkeytype-backend.onrender.com`  
- **Database**: ✅ MongoDB Atlas
- **Cache**: ✅ Render Redis
- **Features**: ✅ Full typing application

## 🎉 Next Steps

1. **Monitor**: Check Render Dashboard logs
2. **Optimize**: Configure caching headers
3. **Scale**: Upgrade to paid plans if needed
4. **Secure**: Add proper authentication
5. **Domain**: Set up custom domain

---

✨ **Congratulations!** Monkeytype is now live on Render!

🔥 **Pro Tips:**
- Use MongoDB Atlas free tier for database
- Enable Redis for better performance  
- Monitor build logs for issues
- Set up alerts for downtime 