@echo off
setlocal
cd /d "%~dp0"

if not defined OPENCODE_SERVER_PASSWORD (
  if exist "%~dp0password.txt" (
    set /p OPENCODE_SERVER_PASSWORD=<"%~dp0password.txt"
  )
)
if not defined OPENCODE_SERVER_PASSWORD (
  set /p "OPENCODE_SERVER_PASSWORD=Password for opencode web: "
)
if not defined OPENCODE_SERVER_PASSWORD (
  echo Password is required.
  pause
  exit /b 1
)

set "OPENCODE_EXE=%LOCALAPPDATA%\Programs\opencode-cli\opencode.exe"
if not exist "%OPENCODE_EXE%" (
  for /f "delims=" %%i in ('where opencode 2^>nul') do set "OPENCODE_EXE=%%i"
)
if not exist "%OPENCODE_EXE%" (
  echo opencode.exe not found. Install the opencode CLI first.
  pause
  exit /b 1
)

set "TS_EXE=%ProgramFiles%\Tailscale\tailscale.exe"
if not exist "%TS_EXE%" set "TS_EXE=%LOCALAPPDATA%\Tailscale\tailscale.exe"
if not exist "%TS_EXE%" set "TS_EXE=D:\tailscale\tailscale.exe"
if not exist "%TS_EXE%" set "TS_EXE="

set "TSIP="
if defined TS_EXE (
  for /f "delims=" %%i in ('"%TS_EXE%" ip -4 2^>nul') do set "TSIP=%%i"
)

echo ============================================
echo  OpenCode Web
echo  Project : %CD%
echo  Local   : http://127.0.0.1:4096
if defined TSIP echo  Phone   : http://%TSIP%:4096
echo  User    : opencode
echo ============================================
echo.
echo Keep this window open. Press Ctrl+C to stop.
echo.

netstat -ano | findstr ":4096" | findstr "LISTENING" >nul
if not errorlevel 1 (
  echo OpenCode Web is already running on port 4096.
  echo Open it at http://127.0.0.1:4096
  pause
  exit /b 0
)

"%OPENCODE_EXE%" web --hostname 0.0.0.0 --port 4096

echo.
echo Server stopped.
pause
