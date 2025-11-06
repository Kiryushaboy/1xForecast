@echo off
chcp 65001
echo ============================================
echo Проверка Java для Flutter
echo ============================================
echo.

echo Проверяем Java...
java -version
if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Java не найдена!
    echo.
    echo Решения:
    echo.
    echo 1. Установите Java JDK:
    echo    https://www.oracle.com/java/technologies/downloads/
    echo    или OpenJDK: https://adoptium.net/
    echo.
    echo 2. После установки перезапустите терминал
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Java установлена!
echo.

echo Проверяем JAVA_HOME...
if defined JAVA_HOME (
    echo [OK] JAVA_HOME установлена: %JAVA_HOME%
) else (
    echo [ПРЕДУПРЕЖДЕНИЕ] JAVA_HOME не установлена
    echo.
    echo Попытка найти Java автоматически...
    
    for /f "tokens=2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\JDK" /s /v JavaHome 2^>nul ^| findstr JavaHome') do (
        set "JAVA_HOME=%%j"
        echo Найдена Java: %%j
        goto :found
    )
    
    for /f "tokens=2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit" /s /v JavaHome 2^>nul ^| findstr JavaHome') do (
        set "JAVA_HOME=%%j"
        echo Найдена Java: %%j
        goto :found
    )
    
    echo.
    echo [ОШИБКА] Не удалось найти JAVA_HOME автоматически
    echo.
    echo Пожалуйста, установите вручную:
    echo 1. Найдите папку установки Java (например: C:\Program Files\Java\jdk-17)
    echo 2. Добавьте в переменные окружения системы
    echo.
    pause
    exit /b 1
)

:found
echo.
echo Устанавливаем JAVA_HOME для текущей сессии...
setx JAVA_HOME "%JAVA_HOME%" >nul 2>&1
echo.
echo ============================================
echo [OK] Java настроена!
echo ============================================
echo.
echo JAVA_HOME: %JAVA_HOME%
echo.
echo Теперь можно собирать APK!
echo Запустите: build_apk.bat
echo.
pause
