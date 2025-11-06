@echo off
chcp 65001
set JAVA_HOME=C:\Users\ksinelnikov\Java\jdk-17.0.13+11
set PATH=%JAVA_HOME%\bin;%PATH%

echo ============================================
echo Building Split APKs with portable Java
echo ============================================
echo JAVA_HOME: %JAVA_HOME%
echo.

echo Проверяем Java...
java -version
echo.

echo Step 1: Cleaning build...
call flutter clean

echo.
echo Step 2: Getting dependencies...
call flutter pub get

echo.
echo Step 3: Building Split APKs (release mode)...
call flutter build apk --split-per-abi --release

echo.
echo ============================================
echo Build complete!
echo ============================================
echo.
echo APK files location: build\app\outputs\flutter-apk\
echo   - app-armeabi-v7a-release.apk (для старых устройств)
echo   - app-arm64-v8a-release.apk (для современных устройств)
echo   - app-x86_64-release.apk (для эмуляторов)
echo.
echo Выберите app-arm64-v8a-release.apk для вашего телефона
echo.
pause
