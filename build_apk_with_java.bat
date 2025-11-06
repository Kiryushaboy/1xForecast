@echo off
chcp 65001
set JAVA_HOME=C:\Users\ksinelnikov\Java\jdk-17.0.13+11
set PATH=%JAVA_HOME%\bin;%PATH%

echo ============================================
echo Building APK with portable Java
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
