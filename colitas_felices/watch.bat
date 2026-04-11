@echo off
echo ========================================
echo  Colitas Felices - Live Reload
echo ========================================
echo.

REM Verifica si browser-sync esta instalado
where browser-sync >nul 2>nul
if %errorlevel% neq 0 (
    echo Instalando Browser Sync...
    npm install -g browser-sync
)

REM Lee el puerto del archivo .port si existe, si no usa el default
set PORT=44300
if exist .port (
    set /p PORT=<.port
)

echo Proyecto corriendo en: http://localhost:%PORT%
echo Live reload activo en: http://localhost:3000
echo.
echo Observando cambios en CSS, ASPX y JS...
echo Presiona Ctrl+C para detener.
echo.

browser-sync start --proxy "localhost:%PORT%" --files "src/css/**/*.css, src/**/*.aspx, src/js/**/*.js" --no-notify
