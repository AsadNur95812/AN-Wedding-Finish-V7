@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build_EXE.ps1"
if errorlevel 1 (
  echo.
  echo BUILD FAILED. Read the error above and BUILD_GUIDE.txt.
  pause
  exit /b 1
)
echo.
echo Build complete. EXE: runtime\ANWeddingFinish.exe
pause
