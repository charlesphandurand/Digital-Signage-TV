@echo off
<<<<<<< HEAD
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
=======
setlocal enabledelayedexpansion

:: Konfigurasi
set "SOURCE=H:\My Drive\Testing digital signage"
set "TARGET=C:\Signage"
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
>>>>>>> a4d69d5 (FINAL Multi Monitor + Auto Run + Python Detect Display)
(
  echo let promos = [
  for /f "delims=" %%F in ('dir /b /on "%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" "%TARGET%\*.gif" "%TARGET%\*.mp4" "%TARGET%\*.webm" "%TARGET%\*.mov" "%TARGET%\*.avi"') do (
    echo "%%F",
  )
  echo ];
) > "%TARGET%\imagelist.js"

<<<<<<< HEAD
:: Jalankan Python launch_signage.py (pastikan python dan modul screeninfo sudah terinstall)
python "%~dp0launch_signage.py"

endlocal
=======
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
>>>>>>> a4d69d5 (FINAL Multi Monitor + Auto Run + Python Detect Display)
