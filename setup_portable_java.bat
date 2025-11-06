@echo off
chcp 65001
echo ============================================
echo Установка портативной Java (без прав админа)
echo ============================================
echo.

echo Инструкция:
echo.
echo 1. Скачайте портативный JDK:
echo    https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.9%%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.9_9.zip
echo.
echo 2. Распакуйте в любую папку (например: C:\Users\%USERNAME%\Java\jdk-17)
echo.
echo 3. Введите путь к папке JDK ниже
echo.
set /p JAVA_PATH="Введите полный путь к JDK (например: C:\Users\%USERNAME%\Java\jdk-17.0.9+9): "

if not exist "%JAVA_PATH%" (
    echo.
    echo [ОШИБКА] Папка не найдена: %JAVA_PATH%
    echo.
    pause
    exit /b 1
)

if not exist "%JAVA_PATH%\bin\java.exe" (
    echo.
    echo [ОШИБКА] java.exe не найден в %JAVA_PATH%\bin\
    echo Убедитесь, что путь указан правильно
    echo.
    pause
    exit /b 1
)

echo.
echo Проверяем Java...
"%JAVA_PATH%\bin\java.exe" -version
if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Не удалось запустить Java
    pause
    exit /b 1
)

echo.
echo [OK] Java работает!
echo.

echo Создаём build_apk_portable.bat с правильными путями...
(
echo @echo off
echo chcp 65001
echo set JAVA_HOME=%JAVA_PATH%
echo set PATH=%JAVA_PATH%\bin;%%PATH%%
echo.
echo echo ============================================
echo echo Building APK with portable Java
echo echo ============================================
echo echo JAVA_HOME: %%JAVA_HOME%%
echo echo.
echo.
echo java -version
echo echo.
echo.
echo echo Cleaning...
echo call flutter clean
echo echo.
echo echo Getting dependencies...
echo call flutter pub get
echo echo.
echo echo Building APK...
echo call flutter build apk --release
echo.
echo echo ============================================
echo echo Build complete!
echo echo ============================================
echo echo APK: build\app\outputs\flutter-apk\app-release.apk
echo echo.
echo pause
) > build_apk_portable.bat

echo.
echo ============================================
echo [OK] Готово!
echo ============================================
echo.
echo Создан файл: build_apk_portable.bat
echo Запустите его для сборки APK
echo.
pause
