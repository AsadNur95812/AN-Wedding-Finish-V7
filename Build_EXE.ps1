# AN Wedding Finish V7 RC1 — Windows x64 EXE builder.
# Runs on Windows with Python 3.12 x64 and internet access (first build only).
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $root

function Run-Checked([string]$Exe, [string[]]$Arguments) {
    & $Exe @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Command failed (exit $LASTEXITCODE): $Exe $($Arguments -join ' ')" }
}

Write-Host '=== AN Wedding Finish V7 RC1 - Windows x64 EXE Builder ===' -ForegroundColor Cyan
$basePython = $null
$baseArgs = @()
if (Get-Command py -ErrorAction SilentlyContinue) {
    & py -3.12 -c 'import sys; print(sys.version)' 2>$null
    if ($LASTEXITCODE -eq 0) { $basePython = 'py'; $baseArgs = @('-3.12') }
}
if (-not $basePython -and (Get-Command python -ErrorAction SilentlyContinue)) {
    & python -c 'import sys; assert sys.version_info[:2] == (3,12) and sys.maxsize > 2**32'
    if ($LASTEXITCODE -eq 0) { $basePython = 'python' }
}
if (-not $basePython) {
    throw 'Python 3.12 x64 not found. Install Python 3.12 x64 from https://www.python.org/downloads/windows/ (select Add Python to PATH), then run Build_EXE.bat again.'
}
Run-Checked $basePython ($baseArgs + @('-c', 'import sys,struct; assert sys.version_info[:2] == (3,12) and struct.calcsize("P")==8'))
$venv = Join-Path $root '.build-venv'
$venvPython = Join-Path $venv 'Scripts\python.exe'
if (-not (Test-Path -LiteralPath $venvPython)) {
    Write-Host 'Creating isolated Python build environment...'
    Run-Checked $basePython ($baseArgs + @('-m','venv',$venv))
}
Write-Host 'Installing Windows build dependencies (internet required)...'
Run-Checked $venvPython @('-m','pip','install','--disable-pip-version-check','--only-binary=:all:',
    'pyinstaller>=6.15,<7', 'numpy==2.2.6', 'Pillow==11.2.1',
    'tifffile==2025.5.10', 'opencv-python-headless==4.11.0.86')
Write-Host 'Building Windows executable (this may take several minutes)...'
Run-Checked $venvPython @('-m','PyInstaller',
    '--noconfirm','--clean','--onefile','--console','--noupx',
    '--name','ANWeddingFinish',
    '--paths',(Join-Path $root 'engine'),
    '--collect-all','cv2',
    '--collect-data','PIL',
    '--add-binary',('engine/native/lcms2.dll' + [IO.Path]::PathSeparator + 'native'),
    '--distpath',(Join-Path $root 'dist'),
    '--workpath',(Join-Path $root 'build'),
    '--specpath',$root,
    (Join-Path $root 'engine\worker.py'))

New-Item -ItemType Directory -Force -Path (Join-Path $root 'runtime') | Out-Null
$exe = Join-Path $root 'runtime\ANWeddingFinish.exe'
Copy-Item -LiteralPath (Join-Path $root 'dist\ANWeddingFinish.exe') -Destination $exe -Force
Write-Host 'Testing compiled executable...' -ForegroundColor Yellow
Run-Checked $exe @('--diagnostics')
Write-Host "SUCCESS: $exe" -ForegroundColor Green
Write-Host 'Open Lightroom Classic > File > Plug-in Manager > Add and select lightroom\AN_Wedding_Finish.lrplugin'
