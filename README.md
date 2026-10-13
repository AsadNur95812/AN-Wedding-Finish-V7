# AN Wedding Finish V7 RC1 — Lightroom Classic Windows plugin

This repository contains the **source code** and a GitHub Actions Windows build workflow. It does not contain a compiled EXE until the workflow succeeds.

## Build using GitHub Actions

1. Upload the **contents** of this folder to the repository root, including `.github/workflows/build-windows-plugin.yml`. Do not upload only the ZIP.
2. Open **Actions** → **Build Windows Lightroom Plugin** → **Run workflow** (or wait for the `main` push workflow).
3. When the run finishes successfully, open its **Artifacts** and download `AN_Wedding_Finish_V7_Windows_x64_Compiled_Plugin`.
4. Extract the artifact and follow `WINDOWS_PLUGIN_INSTALL.txt`.

The workflow builds `runtime/ANWeddingFinish.exe` on Windows 2022 with Python 3.12, smoke-tests it, and packages it with `lightroom/AN_Wedding_Finish.lrplugin`.

**Status:** The Windows EXE build and Lightroom Classic integration have not yet been validated. Do not distribute as tested until you verify it.
