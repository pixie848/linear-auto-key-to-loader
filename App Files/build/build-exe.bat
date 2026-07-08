@echo off
setlocal
cd /d "%~dp0"
title Build Get Loader.exe

rem Rebuilds "Get Loader.exe" (in the app root) from Launcher.cs + linear.ico
rem using the C# compiler that ships with the .NET Framework. Run this only if
rem you change the launcher or the icon; the finished exe is committed already.

set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if not exist "%CSC%" set "CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe"
if not exist "%CSC%" (
  echo Could not find the C# compiler ^(csc.exe^).
  echo Install the .NET Framework 4.x and try again.
  pause
  exit /b 1
)

"%CSC%" /nologo /target:winexe /win32icon:"linear.ico" /reference:System.dll /reference:System.Windows.Forms.dll /out:"..\..\Get Loader.exe" "Launcher.cs"
if errorlevel 1 (
  echo.
  echo Build failed.
  pause
  exit /b 1
)

echo.
echo Built "Get Loader.exe" in the app root.
pause
exit /b 0
