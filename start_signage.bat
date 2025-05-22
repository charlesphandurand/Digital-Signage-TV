@echo off
setlocal

:: Folder sumber dan tujuan
set "SOURCE=H:\My Drive\Testing digital signage"
set "TARGET=C:\Signage"

:: Buat folder tujuan jika belum ada
if not exist "%TARGET%" mkdir "%TARGET%"

:: Hapus media lama
del /q "%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" "%TARGET%\*.gif"
del /q "%TARGET%\*.mp4" "%TARGET%\*.webm" "%TARGET%\*.mov" "%TARGET%\*.avi"

:: Salin media terbaru dari Google Drive
xcopy "%SOURCE%\*.jpg"   "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.jpeg"  "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.png"   "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.gif"   "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.mp4"   "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.webm"  "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.mov"   "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.avi"   "%TARGET%\" /D /Y >nul

:: Copy index.html kalau belum ada
if not exist "%TARGET%\index.html" copy "%~dp0index.html" "%TARGET%\index.html"

:: Buat file imagelist.js urut A-Z
(
  echo let promos = [
  for /f "delims=" %%F in ('dir /b /on "%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" "%TARGET%\*.gif" "%TARGET%\*.mp4" "%TARGET%\*.webm" "%TARGET%\*.mov" "%TARGET%\*.avi"') do (
    echo "%%F",
  )
  echo ];
) > "%TARGET%\imagelist.js"

:: Jalankan Python launch_signage.py (pastikan python dan modul screeninfo sudah terinstall)
python "%~dp0launch_signage.py"

endlocal
