Write-Host "🚀 Testing Monkeytype Build for Render Deployment" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Check Node.js version
Write-Host ""
Write-Host "📦 Checking Node.js version..." -ForegroundColor Yellow
$nodeVersion = node --version
Write-Host "Current Node.js version: $nodeVersion" -ForegroundColor White

if ($nodeVersion -ne "v20.16.0") {
    Write-Host "⚠️  Warning: Expected Node.js v20.16.0, but found $nodeVersion" -ForegroundColor Yellow
    Write-Host "   Render expects exact version match" -ForegroundColor Yellow
}

# Check pnpm
Write-Host ""
Write-Host "📦 Checking pnpm..." -ForegroundColor Yellow
try {
    $pnpmVersion = pnpm --version
    Write-Host "✅ pnpm version: $pnpmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ pnpm not found. Installing..." -ForegroundColor Red
    corepack enable
    corepack prepare pnpm@9.6.0 --activate
}

# Check required files
Write-Host ""
Write-Host "🏗️  Checking Render configuration..." -ForegroundColor Yellow

$requiredFiles = @("render.yaml", "pnpm-workspace.yaml", "turbo.json")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ Found $file" -ForegroundColor Green
    } else {
        Write-Host "❌ Missing $file" -ForegroundColor Red
        exit 1
    }
}

# Check environment variables
Write-Host ""
Write-Host "🔧 Checking environment variables..." -ForegroundColor Yellow

if (Test-Path ".env") {
    Write-Host "✅ Found .env file" -ForegroundColor Green
    
    $envContent = Get-Content ".env" -Raw
    if ($envContent -match "RECAPTCHA_SITE_KEY") {
        Write-Host "✅ RECAPTCHA_SITE_KEY is set" -ForegroundColor Green
    } else {
        Write-Host "⚠️  RECAPTCHA_SITE_KEY not found (will use default)" -ForegroundColor Yellow
    }
    
    if ($envContent -match "DB_URI") {
        Write-Host "✅ DB_URI is set" -ForegroundColor Green
    } else {
        Write-Host "⚠️  DB_URI not found (Render will auto-configure)" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  No .env file (Render will use environment variables)" -ForegroundColor Yellow
}

# Clean previous builds
Write-Host ""
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow

@("node_modules", "frontend/node_modules", "backend/node_modules", "frontend/dist", "backend/dist") | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item -Recurse -Force $_
        Write-Host "   Removed $_" -ForegroundColor Gray
    }
}

# Install dependencies
Write-Host ""
Write-Host "📦 Installing dependencies (like Render)..." -ForegroundColor Yellow
Write-Host "   Running: corepack enable && pnpm install" -ForegroundColor Gray

corepack enable
pnpm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green

# Test frontend build
Write-Host ""
Write-Host "🎨 Testing frontend build..." -ForegroundColor Yellow
Write-Host "   Running: pnpm build-fe" -ForegroundColor Gray

pnpm build-fe

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend build failed!" -ForegroundColor Red
    exit 1
}

# Check frontend output
if (Test-Path "frontend/dist") {
    $frontendFiles = (Get-ChildItem "frontend/dist" -Recurse -File).Count
    Write-Host "✅ Frontend built successfully - $frontendFiles files generated" -ForegroundColor Green
    
    # Check critical files
    @("frontend/dist/index.html", "frontend/dist/static") | ForEach-Object {
        if (Test-Path $_) {
            Write-Host "   ✅ Found $_" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Missing $_" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "❌ Frontend dist directory not found!" -ForegroundColor Red
    exit 1
}

# Test backend build
Write-Host ""
Write-Host "🔧 Testing backend build..." -ForegroundColor Yellow
Write-Host "   Running: pnpm build-be" -ForegroundColor Gray

pnpm build-be

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend build failed!" -ForegroundColor Red
    exit 1
}

# Check backend output
if (Test-Path "backend/dist") {
    $backendFiles = (Get-ChildItem "backend/dist" -Recurse -File).Count
    Write-Host "✅ Backend built successfully - $backendFiles files generated" -ForegroundColor Green
    
    # Check server file
    if (Test-Path "backend/dist/server.js") {
        Write-Host "   ✅ Found backend/dist/server.js" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Missing backend/dist/server.js" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Backend dist directory not found!" -ForegroundColor Red
    exit 1
}

# Calculate total build size
Write-Host ""
Write-Host "📊 Build Summary:" -ForegroundColor White

$frontendSize = (Get-ChildItem "frontend/dist" -Recurse | Measure-Object -Property Length -Sum).Sum
$backendSize = (Get-ChildItem "backend/dist" -Recurse | Measure-Object -Property Length -Sum).Sum

$frontendSizeMB = [math]::Round($frontendSize / 1MB, 2)
$backendSizeMB = [math]::Round($backendSize / 1MB, 2)
$totalSizeMB = [math]::Round(($frontendSize + $backendSize) / 1MB, 2)

Write-Host "   Frontend: $frontendSizeMB MB" -ForegroundColor Gray
Write-Host "   Backend:  $backendSizeMB MB" -ForegroundColor Gray
Write-Host "   Total:    $totalSizeMB MB" -ForegroundColor White

Write-Host ""
Write-Host "🎉 All builds successful! Ready for Render deployment!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Push to GitHub: git add . && git commit && git push" -ForegroundColor White
Write-Host "   2. Go to Render Dashboard: https://dashboard.render.com" -ForegroundColor White
Write-Host "   3. Create New → Blueprint" -ForegroundColor White
Write-Host "   4. Connect GitHub repository" -ForegroundColor White
Write-Host "   5. Render will auto-detect render.yaml" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Required for Render:" -ForegroundColor Cyan
Write-Host "   - MongoDB Atlas connection string" -ForegroundColor White
Write-Host "   - ReCAPTCHA secret key" -ForegroundColor White
Write-Host "   - Firebase config (optional)" -ForegroundColor White
Write-Host ""
Write-Host "💡 Render will automatically:" -ForegroundColor Yellow
Write-Host "   - Create frontend static site" -ForegroundColor Gray
Write-Host "   - Create backend web service" -ForegroundColor Gray
Write-Host "   - Create Redis instance" -ForegroundColor Gray
Write-Host "   - Link services together" -ForegroundColor Gray 