@echo off
setlocal EnableDelayedExpansion

REM ================================
REM 🗂️ Generar lista de imágenes
REM ================================

cd /d C:\MEDIOS\ProyectosArduinoFZ\ProyectosESP-GitHub\MiCompendio\

REM Borrar archivos antiguos
if exist ListaArchivosGlobal.txt del /f /q ListaArchivosGlobal.txt
if exist ListaArchivosGlobal-cruda.txt del /f /q ListaArchivosGlobal-cruda.txt
set estado_borrado=[OK]

echo 🔄 Generando lista cruda...
for /R %%F in (*) do @echo %%F >> ListaArchivosGlobal-cruda.txt
if exist ListaArchivosGlobal-cruda.txt (
    set estado_lista=[OK]
) else (
    set estado_lista=[FALLÓ]
)

echo 🔧 Limpiando rutas absolutas a relativas...
powershell -Command ^
  "$root = 'C:\MEDIOS\ProyectosArduinoFZ\ProyectosESP-GitHub\MiCompendio\';" ^
  "Get-Content 'ListaArchivosGlobal-cruda.txt' | ForEach-Object { ($_ -replace [regex]::Escape($root), '') -replace '\\', '/' } | Set-Content 'ListaArchivosGlobal.txt'"
if %errorlevel%==0 (
    set estado_limpieza=[OK]
) else (
    set estado_limpieza=[FALLÓ]
)

REM ================================
REM 🧠 Subir cambios a Git
REM ================================

cd /d C:\MEDIOS\ProyectosArduinoFZ\ProyectosESP-GitHub\MiCompendio

echo 🔄 Agregando archivos de MiCompendio al git...
git add .
if %errorlevel%==0 (
    set estado_add_img=[OK]
) else (
    set estado_add_img=[FALLÓ]
)

git commit -m "Estructura"
if %errorlevel%==0 (
    set estado_commit=[OK]
) else (
    set estado_commit=[FALLÓ]
)

git pull origin main --rebase
if %errorlevel%==0 (
    set estado_pull=[OK]
) else (
    set estado_pull=[FALLÓ]
)

git push origin main
if %errorlevel%==0 (
    set estado_push=[OK]
) else (
    set estado_push=[FALLÓ]
)

REM ================================
REM 📋 Mostrar resumen de ejecución
REM ================================
echo.
echo ================================
echo 📋 RESUMEN DE EJECUCIÓN
echo ================================
echo [*] Archivos antiguos borrados:         !estado_borrado!
echo [*] Lista cruda generada:              !estado_lista!
echo [*] Rutas limpiadas (relativas):       !estado_limpieza!
echo [*] Archivos agregados al git:         !estado_add_img!
echo [*] Commit creado:                     !estado_commit!
echo [*] Pull con rebase:                   !estado_pull!
echo [*] Push al repositorio remoto:        !estado_push!
echo ================================

pause
endlocal
