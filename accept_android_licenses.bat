@echo off
chcp 65001
set JAVA_HOME=C:\Users\ksinelnikov\Java\jdk-17.0.13+11
set PATH=%JAVA_HOME%\bin;%PATH%

echo ============================================
echo Принятие лицензий Android SDK
echo ============================================
echo.

echo ВАЖНО: Сначала включите Developer Mode!
echo.
echo 1. Нажмите Win + I (открыть Настройки)
echo 2. Перейдите: Конфиденциальность и безопасность -^> Для разработчиков
echo 3. Включите "Режим разработчика"
echo.
echo Или выполните команду: start ms-settings:developers
echo.
pause

echo.
echo Запускаем принятие лицензий Android SDK...
echo.

flutter doctor --android-licenses

echo.
echo ============================================
echo Готово!
echo ============================================
echo.
echo Теперь можно собирать APK: build_apk_with_java.bat
echo.
pause
