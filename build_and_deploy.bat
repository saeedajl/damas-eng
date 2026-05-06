@echo off
echo 🔵 Building Flutter Web with correct base-href...
flutter build web --release --base-href="/damas-eng/" --pwa-strategy=offline-first

echo 🔵 Copying build to GitHub Pages folder...
xcopy /E /I /Y build\web E:\Flattuer\damas-eng

echo 🔵 Committing changes...
cd /d E:\Flattuer\damas-eng
git add .
git commit -m "Deploy new version"
git push

echo 🟢 Deployment complete!
pause
