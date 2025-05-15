@REM @echo off
@REM setlocal

@REM :: Folder sumber (Google Drive sinkron)
@REM set "SOURCE=H:\My Drive\Testing digital signage"
@REM set "TARGET=C:\Signage"

@REM :: Buat folder target jika belum ada
@REM if not exist "%TARGET%" mkdir "%TARGET%"

@REM :: Hapus semua gambar lama
@REM del /q "%TARGET%\*.jpg"
@REM del /q "%TARGET%\*.png"

@REM :: Salin file gambar terbaru dari Google Drive
@REM xcopy "%SOURCE%\*.jpg" "%TARGET%\" /D /Y >nul
@REM xcopy "%SOURCE%\*.png" "%TARGET%\" /D /Y >nul

@REM :: Buat array JavaScript dengan semua gambar
@REM echo let promos = [> "%TARGET%\imagelist.js"

@REM :: Tambahkan nama file JPG dan PNG ke array
@REM for %%F in ("%TARGET%\*.jpg" "%TARGET%\*.png") do (
@REM   echo "%%~nxF",>> "%TARGET%\imagelist.js"
@REM )

@REM :: Tutup array
@REM echo ];>> "%TARGET%\imagelist.js"

@REM :: Update HTML dengan array gambar baru
@REM powershell -Command "(Get-Content '%TARGET%\index.html') -replace 'let promos = \[.*?\]; // BAT WILL REPLACE THIS LINE', (Get-Content '%TARGET%\imagelist.js' -Raw).Trim() | Set-Content '%TARGET%\index.html'"

@REM :: Buka Chrome dalam mode kiosk ke HTML lokal
@REM start chrome --kiosk "file:///C:/Signage/index.html"

@REM endlocal
@REM exit





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
xcopy "%SOURCE%\*.jpg" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.jpeg" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.png" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.gif" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.mp4" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.webm" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.mov" "%TARGET%\" /D /Y >nul
xcopy "%SOURCE%\*.avi" "%TARGET%\" /D /Y >nul

:: Copy index.html kalau belum ada
if not exist "%TARGET%\index.html" copy "%~dp0index.html" "%TARGET%\index.html"

:: Buat daftar file media
(
  echo let promos = [
  for %%F in ("%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" "%TARGET%\*.gif" ^
              "%TARGET%\*.mp4" "%TARGET%\*.webm" "%TARGET%\*.mov" "%TARGET%\*.avi") do (
    echo "%%~nxF",
  )
  echo ];
) > "%TARGET%\imagelist.js"

:: Buka di Chrome mode kiosk
start chrome --kiosk "file:///C:/Signage/index.html"

endlocal
exit
