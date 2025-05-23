@echo off
setlocal enabledelayedexpansion

:: Konfigurasi
set "SOURCE=H:\My Drive\Testing digital signage"
set "TARGET=C:\Digital-Signage-TV"
set "SCRIPT_DIR=%~dp0"
set "SNAPFILE=%TEMP%\signage_snapshot.txt"

:: Pastikan folder target ada
if not exist "%TARGET%" mkdir "%TARGET%"

:: Ambil snapshot awal
dir "%SOURCE%\*.jpg" "%SOURCE%\*.jpeg" "%SOURCE%\*.png" "%SOURCE%\*.gif" ^
    "%SOURCE%\*.mp4" "%SOURCE%\*.webm" "%SOURCE%\*.mov" "%SOURCE%\*.avi" /a:-d /t:w > "%SNAPFILE%" 2>nul

echo [INFO] Memulai signage pertama kali...

:: SALIN DAN BUAT FILE PERTAMA KALI
robocopy "%SOURCE%" "%TARGET%" *.jpg *.jpeg *.png *.gif *.mp4 *.webm *.mov *.avi /mir /njh /njs /ndl /r:1 /w:1 >nul
if not exist "%TARGET%\index.html" copy "%SCRIPT_DIR%index.html" "%TARGET%\index.html" >nul
(
  echo let promos = [
  for /f "delims=" %%F in ('dir /b /on "%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" "%TARGET%\*.gif" "%TARGET%\*.mp4" "%TARGET%\*.webm" "%TARGET%\*.mov" "%TARGET%\*.avi"') do (
    echo "%%F",
  )
  echo ];
) > "%TARGET%\imagelist.js"

:: Jalankan signage (chrome + python)
taskkill /f /im chrome.exe >nul 2>&1
echo [%time%] 🚀 Menjalankan signage...
python "%SCRIPT_DIR%launch_signage.py"

echo.
echo [INFO] Memulai pemantauan folder signage...
echo [INFO] Tekan Ctrl+C untuk keluar.
echo.

:: Loop utama cek perubahan
:loop
timeout /t 10 /nobreak >nul

:: Snapshot baru
dir "%SOURCE%\*.jpg" "%SOURCE%\*.jpeg" "%SOURCE%\*.png" "%SOURCE%\*.gif" ^
    "%SOURCE%\*.mp4" "%SOURCE%\*.webm" "%SOURCE%\*.mov" "%SOURCE%\*.avi" /a:-d /t:w > "%SNAPFILE%.tmp" 2>nul

:: Bandingkan snapshot lama dan baru
fc "%SNAPFILE%" "%SNAPFILE%.tmp" >nul
if %ERRORLEVEL%==0 (
    echo [%time%] 🔁 Tidak ada perubahan.
    goto loop
)

:: Perubahan terdeteksi
echo [%time%] 🔄 Perubahan terdeteksi. Memperbarui signage...

:: Update snapshot
copy /y "%SNAPFILE%.tmp" "%SNAPFILE%" >nul

:: Sinkronisasi file
robocopy "%SOURCE%" "%TARGET%" *.jpg *.jpeg *.png *.gif *.mp4 *.webm *.mov *.avi /mir /njh /njs /ndl /r:1 /w:1 >nul

:: Pastikan index.html ada
if not exist "%TARGET%\index.html" copy "%SCRIPT_DIR%index.html" "%TARGET%\index.html" >nul

:: Buat ulang imagelist.js
(
  echo let promos = [
  for /f "delims=" %%F in ('dir /b /on "%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" "%TARGET%\*.gif" "%TARGET%\*.mp4" "%TARGET%\*.webm" "%TARGET%\*.mov" "%TARGET%\*.avi"') do (
    echo "%%F",
  )
  echo ];
) > "%TARGET%\imagelist.js"

:: Restart signage
taskkill /f /im chrome.exe >nul 2>&1
echo [%time%] 🚀 Menjalankan signage ulang...
python "%SCRIPT_DIR%launch_signage.py"

goto loop
