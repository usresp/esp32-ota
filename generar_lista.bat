@echo off

REM Cambiar a la carpeta raíz donde están las imágenes
cd /d C:\MEDIOS\ProyectosArduinoFZ\ProyectosESP-GitHub\esp32-ota\Imagenes

REM Eliminar archivos anteriores si existen
if exist lista.txt del lista.txt
if exist lista_cruda.txt del lista_cruda.txt

echo 🔄 Generando lista cruda...
REM Recorrer todos los archivos recursivamente
for /R %%F in (*) do @echo %%F >> lista_cruda.txt

echo 🔧 Limpiando rutas absolutas a relativas...
REM Quitar ruta completa hasta \Imagenes\, usando comillas dobles y tolerancia a mayúsculas/minúsculas
powershell -Command ^
  "$root = 'C:\MEDIOS\ProyectosArduinoFZ\ProyectosESP-GitHub\esp32-ota\Imagenes\';" ^
  "Get-Content 'lista_cruda.txt' | ForEach-Object { ($_ -replace [regex]::Escape($root), '') -replace '\\', '/' } | Set-Content 'lista.txt'"

echo ✅ Lista generada correctamente: lista.txt
pause
