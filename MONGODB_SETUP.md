# 🍃 MongoDB Atlas Setup cho Render

## ✅ Connection String của bạn:
```
mongodb+srv://monkeytype:gAEKcpKPtqCz05Lc@cluster0.vanthangbk.mongodb.net/monkeytype
```

## 🔧 Đã cấu hình trong render.yaml

File `render.yaml` đã được cập nhật để sử dụng MongoDB Atlas của bạn thay vì tạo database mới.

## 🚀 Deploy Steps

### 1. Push code lên GitHub
```bash
git add .
git commit -m "Configure MongoDB Atlas connection"
git push
```

### 2. Deploy trên Render
1. Đăng nhập [Render Dashboard](https://dashboard.render.com)
2. **New** → **Blueprint**
3. Connect GitHub repository
4. Render sẽ tự động:
   - Tạo frontend static site
   - Tạo backend web service với DB_URI đã set
   - Tạo Redis cache
   - Link các services với nhau

### 3. Environment Variables (Tự động)

**Backend sẽ có:**
- ✅ `DB_URI`: `mongodb+srv://monkeytype:gAEKcpKPtqCz05Lc@cluster0.vanthangbk.mongodb.net/monkeytype`
- ✅ `REDIS_URI`: Auto-configured by Render
- ✅ `PORT`: 10000
- ✅ `NODE_ENV`: production

### 4. Cần thêm Environment Variables

**Trong Render Dashboard, thêm:**

#### Backend Service:
```
RECAPTCHA_SECRET=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe
```

#### Frontend Service (optional):
```
FIREBASE_APIKEY=your_firebase_api_key
FIREBASE_AUTHDOMAIN=your_domain.firebaseapp.com
FIREBASE_PROJECTID=your_project_id
FIREBASE_STORAGEBUCKET=your_bucket.appspot.com
FIREBASE_MESSAGINGSENDERID=your_sender_id
FIREBASE_APPID=your_app_id
```

## 🔍 Verify MongoDB Connection

### 1. Check MongoDB Atlas
- **Network Access**: Đảm bảo có `0.0.0.0/0` (allow all IPs)
- **Database User**: `monkeytype` with password `gAEKcpKPtqCz05Lc`
- **Database**: `monkeytype` database exists

### 2. Check Render Logs
Sau khi deploy, check backend service logs:
```
✅ Connected to MongoDB Atlas
✅ Server listening on port 10000
✅ Redis connected
```

## 🎯 Expected URLs

Sau khi deploy thành công:
- **Frontend**: `https://monkeytype-frontend-[hash].onrender.com`
- **Backend**: `https://monkeytype-backend-[hash].onrender.com`

## 🛠️ Troubleshooting

### Nếu connection fails:
1. Check MongoDB Atlas network access
2. Verify user credentials
3. Ensure database name is correct
4. Check Render service logs

### Nếu backend không start:
```bash
# Test locally first
DB_URI="mongodb+srv://monkeytype:gAEKcpKPtqCz05Lc@cluster0.vanthangbk.mongodb.net/monkeytype" npm run dev-be
```

## 🚀 Quick Deploy Command

```bash
# Test build
.\test-render.ps1

# Push và deploy
git add . && git commit -m "Ready for Render with MongoDB Atlas" && git push

# Sau đó deploy trên Render Dashboard
```

---

✅ **All set!** MongoDB Atlas connection string đã được cấu hình sẵn trong render.yaml 