@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
cd /d "%~dp0"

:scan
set count=0
for %%f in (*.ps1) do set /a count+=1

if %count%==0 (
    echo.
    echo В папке не найдено .ps1 скриптов:
    echo %cd%
    pause
    exit /b
)

if %count%==1 goto single
goto menu

:single
for %%f in (*.ps1) do set "script=%%~nxf"
echo.
echo Найден единственный скрипт:
call :SafeEcho "%script%"
echo.
echo [Enter] - запустить, [0] - выход
set "choice="
set /p choice="> "
if "%choice%"=="0" exit /b
if "%choice%"=="" goto run
echo Неверный ввод.
goto single

:menu
cls
echo Папка: %cd%
echo.
set idx=0
for %%f in (*.ps1) do (
    set /a idx+=1
    set "name=%%~nxf"
    set "name=!name:^=^^!"
    set "name=!name:&=^&!"
    set "name=!name:|=^|!"
    set "name=!name:<=^<!"
    set "name=!name:>=^>!"
    set "name=!name:(=^(!"
    set "name=!name:)=^)!"
    echo   !idx!. !name!
)
echo   0. Выход
echo.
set "choice="
set /p choice="Номер скрипта (1-%idx%), [0] - выход, [Enter] - повторить список: "
if "%choice%"=="0" exit /b
if "%choice%"=="" goto menu

set "script="
set idx=0
for %%f in (*.ps1) do (
    set /a idx+=1
    if "!idx!"=="%choice%" set "script=%%~nxf"
)

if "%script%"=="" (
    echo Некорректный выбор: %choice%
    timeout /t 2 >nul
    goto menu
)

:run
echo.
echo Запуск скрипта...
call :SafeEcho "%script%"
echo ========================================
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%script%"
echo ========================================
echo Скрипт завершил работу.
pause
exit /b

:SafeEcho
set "text=%~1"
set "text=!text:^=^^!"
set "text=!text:&=^&!"
set "text=!text:|=^|!"
set "text=!text:<=^<!"
set "text=!text:>=^>!"
set "text=!text:(=^(!"
set "text=!text:)=^)!"
echo !text!
goto :eof