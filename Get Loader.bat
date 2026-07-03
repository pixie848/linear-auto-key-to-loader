@echo off
title linear.pub
cd /d "%~dp0"
mode con: cols=82 lines=28 >nul 2>nul
cls

set "SETUP_BAT=%~dp0Install Dependencies.bat"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js was not found. Running setup...
  if not exist "%SETUP_BAT%" (
    echo Install Dependencies.bat was not found.
    echo.
    pause
    exit /b 1
  )
  call "%SETUP_BAT%" --no-pause
  if errorlevel 1 (
    echo.
    echo Setup failed.
    echo.
    pause
    exit /b 1
  )
  call :RefreshNodePath
  where node >nul 2>nul
  if errorlevel 1 (
    echo.
    echo Node.js was installed, but this window cannot see it yet.
    echo Close this window and run Get Loader.bat again.
    echo.
    pause
    exit /b 1
  )
  cls
)

if not exist "node_modules\playwright\package.json" (
  echo npm dependencies are missing. Running setup...
  if not exist "%SETUP_BAT%" (
    echo Install Dependencies.bat was not found.
    echo.
    pause
    exit /b 1
  )
  call "%SETUP_BAT%" --no-pause
  if errorlevel 1 (
    echo.
    echo Setup failed.
    echo.
    pause
    exit /b 1
  )
  cls
)

node -e "const fs=require('fs');try{const { chromium }=require('playwright');process.exit(fs.existsSync(chromium.executablePath())?0:1)}catch(e){process.exit(1)}" >nul 2>nul
if errorlevel 1 (
  echo Playwright Chromium is missing. Running setup...
  if not exist "%SETUP_BAT%" (
    echo Install Dependencies.bat was not found.
    echo.
    pause
    exit /b 1
  )
  call "%SETUP_BAT%" --no-pause
  if errorlevel 1 (
    echo.
    echo Setup failed.
    echo.
    pause
    exit /b 1
  )
  cls
)

node get-loader.js
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
  echo.
  echo The loader script failed. Review the message above.
  echo If it mentions Playwright browsers, run:
  echo Install Dependencies.bat
  echo.
  pause
)

exit /b %EXIT_CODE%

:RefreshNodePath
for %%D in ("%ProgramFiles%\nodejs" "%ProgramFiles(x86)%\nodejs" "%LOCALAPPDATA%\Programs\nodejs") do (
  if exist "%%~D\node.exe" set "PATH=%%~D;%PATH%"
)
exit /b 0
