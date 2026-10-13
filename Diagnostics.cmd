@echo off
setlocal
cd /d "%~dp0"
if not exist "runtime\ANWeddingFinish.exe" (
  echo EXE not found. First run Build_EXE.bat on Windows x64.
  pause
  exit /b 1
)
"%~dp0runtime\ANWeddingFinish.exe" --diagnostics
echo Exit code: %errorlevel%
pause
