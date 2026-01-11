@echo off
REM Ace Launcher for Windows
REM Usage: ace [splash|dashboard|progress]

if "%1"=="" goto splash
if "%1"=="splash" goto splash
if "%1"=="dashboard" goto dashboard
if "%1"=="progress" goto progress
if "%1"=="help" goto help
goto help

:splash
powershell -ExecutionPolicy Bypass -File "%~dp0splash.ps1" -Duration 3
goto end

:dashboard
powershell -ExecutionPolicy Bypass -File "%~dp0dashboard.ps1"
goto end

:progress
powershell -ExecutionPolicy Bypass -File "%~dp0dashboard.ps1" -Watch
goto end

:help
echo.
echo   Ace Terminal Scripts
echo   --------------------
echo.
echo   ace splash     Show animated splash screen
echo   ace dashboard  Show project dashboard
echo   ace progress   Live progress monitoring
echo   ace help       Show this help
echo.
goto end

:end
