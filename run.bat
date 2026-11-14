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
set "exit_code=%ERRORLEVEL%"
if not defined exit_code set "exit_code=0"
echo ========================================

if "%exit_code%"=="0"    goto run_ok
if "%exit_code%"=="9009" goto run_nops
if %exit_code% LSS 0     goto run_crash
if %exit_code% GEQ 100 if %exit_code% LEQ 125 goto run_custom
goto run_err

:run_ok
echo [OK] Скрипт завершил работу успешно ^(код: 0^).
goto run_done

:run_nops
echo [ОШИБКА] powershell.exe не найден ^(код: 9009^).
goto run_done

:run_crash
echo [ОШИБКА] PowerShell завершился аварийно ^(код: %exit_code%^).
goto run_done

:run_custom
echo [ОШИБКА] Ошибка валидации или бизнес-логики скрипта ^(код: %exit_code%^).
goto run_done

:run_err
echo [ОШИБКА] Скрипт завершился с кодом: %exit_code%

:run_done
echo.
pause
exit /b %exit_code%

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
