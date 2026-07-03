@echo off
setlocal
title linear.pub setup
cd /d "%~dp0"

set "NO_PAUSE="
if /i "%~1"=="--no-pause" set "NO_PAUSE=1"

echo.
echo === linear.pub setup ===
echo This checks Node.js, npm packages, and Playwright Chromium.
echo Already-installed parts are skipped.
echo.

call :FindNode
if not defined NODE_FOUND (
  echo Node.js was not found.
  call :InstallNode
  if errorlevel 1 exit /b 1
)

call :FindNode
if not defined NODE_FOUND (
  echo Node.js still was not found after setup.
  echo Close this window, reopen it, then run this file again.
  call :PauseIfNeeded
  exit /b 1
)

for /f "usebackq delims=" %%V in (`node --version`) do set "NODE_VERSION=%%V"
echo Node.js already installed: %NODE_VERSION%

if not exist "package.json" (
  echo package.json was not found in this folder.
  call :PauseIfNeeded
  exit /b 1
)

echo.
call :FindNpmPackages
if defined NPM_PACKAGES_FOUND (
  echo npm dependencies already installed.
) else (
  echo Installing npm dependencies...
  call npm.cmd install
  if errorlevel 1 (
    echo npm install failed.
    call :PauseIfNeeded
    exit /b 1
  )
)

echo.
call :FindPlaywrightChromium
if defined PLAYWRIGHT_CHROMIUM_FOUND (
  echo Playwright Chromium already installed:
  echo %PLAYWRIGHT_CHROMIUM_PATH%
) else (
  echo Installing Playwright Chromium...
  call npx.cmd playwright install chromium
  if errorlevel 1 (
    echo Playwright Chromium install failed.
    call :PauseIfNeeded
    exit /b 1
  )

  echo.
  echo Verifying Playwright Chromium...
  call :FindPlaywrightChromium
  if not defined PLAYWRIGHT_CHROMIUM_FOUND (
    echo Playwright Chromium was not found after install.
    call :PauseIfNeeded
    exit /b 1
  )
  echo %PLAYWRIGHT_CHROMIUM_PATH%
)

echo.
echo Setup complete. You can run Get Loader.bat now.
call :PauseIfNeeded
exit /b 0

:FindNode
set "NODE_FOUND="
where node >nul 2>nul
if not errorlevel 1 set "NODE_FOUND=1"
exit /b 0

:FindNpmPackages
set "NPM_PACKAGES_FOUND="
if exist "node_modules\playwright\package.json" if exist "node_modules\playwright-core\package.json" set "NPM_PACKAGES_FOUND=1"
exit /b 0

:FindPlaywrightChromium
set "PLAYWRIGHT_CHROMIUM_FOUND="
set "PLAYWRIGHT_CHROMIUM_PATH="
for /f "usebackq delims=" %%P in (`node -e "const fs=require('fs');try{const { chromium }=require('playwright');const p=chromium.executablePath();if(fs.existsSync(p)){console.log(p);process.exit(0)}}catch(e){}process.exit(1)" 2^>nul`) do set "PLAYWRIGHT_CHROMIUM_PATH=%%P"
if defined PLAYWRIGHT_CHROMIUM_PATH set "PLAYWRIGHT_CHROMIUM_FOUND=1"
exit /b 0

:InstallNode
where winget >nul 2>nul
if errorlevel 1 (
  echo winget was not found, so Node.js cannot be installed automatically.
  echo Install Node.js LTS from https://nodejs.org/ and run this file again.
  start "" "https://nodejs.org/"
  call :PauseIfNeeded
  exit /b 1
)

echo Installing Node.js LTS with winget...
winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-package-agreements --accept-source-agreements
if errorlevel 1 (
  echo Node.js install failed.
  call :PauseIfNeeded
  exit /b 1
)

call :RefreshNodePath
exit /b 0

:RefreshNodePath
for %%D in ("%ProgramFiles%\nodejs" "%ProgramFiles(x86)%\nodejs" "%LOCALAPPDATA%\Programs\nodejs") do (
  if exist "%%~D\node.exe" set "PATH=%%~D;%PATH%"
)
exit /b 0

:PauseIfNeeded
if not defined NO_PAUSE (
  echo.
  pause
)
exit /b 0
