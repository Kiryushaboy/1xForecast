@echo off
chcp 65001
echo ============================================
echo Building APK for 1xForecast
echo ============================================
echo.

echo Checking Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java not found! Please run check_java.bat first
    pause
    exit /b 1
)
echo [OK] Java is installed
echo.

echo Step 1: Cleaning build...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Building APK (release mode)...
call flutter build apk --release

echo.
echo ============================================
echo Build complete!
echo ============================================
echo.
echo APK location: build\app\outputs\flutter-apk\app-release.apk
echo.
pause
