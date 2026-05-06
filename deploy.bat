@echo off
echo ============================================
echo      Damas Eng - Flutter Web Deployment
echo ============================================

echo.
echo 🔄 Cleaning old build...
rmdir /s /q build

echo.
echo 🚀 Building Flutter Web...
flutter build web --release --base-href="/damas-eng/" --pwa-strategy=offline-first

echo.
echo 📁 Copying build/web to project root...
xcopy /E /I /Y build\web\* .

echo.
echo ➕ Adding files to Git...
git add .

echo.
echo 📝 Committing changes...
git commit -m "Auto Deploy Flutter Web build"

echo.
echo 📤 Pushing to GitHub...
git push origin main

echo.
echo ============================================
echo   🎉 Deployment Completed Successfully!
echo   Visit: https://saeedajl.github.io/damas-eng/
echo ============================================
pause
