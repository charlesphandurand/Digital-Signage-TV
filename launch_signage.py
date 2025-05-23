import os
import subprocess
import time
from screeninfo import get_monitors

# EDIT THIS PATH |||||||||||||||||||||||||||||||||||||||||||||||
SIGNAGE_PATH = r"C:\Digital-Signage-TV"
# EDIT THIS PATH |||||||||||||||||||||||||||||||||||||||||||||||
CHROME_PATH = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
html_file = os.path.join(SIGNAGE_PATH, "index.html")
url = f"file:///{html_file.replace(os.sep, '/')}"

# Tutup Chrome sebelum buka ulang
subprocess.call("taskkill /im chrome.exe /f", shell=True)
time.sleep(1)

monitors = get_monitors()

print("Menjalankan Chrome untuk setiap monitor...")

for i, m in enumerate(monitors):
    user_data_dir = os.path.join(SIGNAGE_PATH, f"user_data_{i}")
    os.makedirs(user_data_dir, exist_ok=True)

    print(f"Monitor {i+1}: x={m.x}, y={m.y}, width={m.width}, height={m.height}")

    subprocess.Popen([
        CHROME_PATH,
        "--new-window",
        "--kiosk",
        "--disable-infobars",
        "--noerrdialogs",
        "--incognito",
        f"--window-position={m.x},{m.y}",
        f"--window-size={m.width},{m.height}",
        f'--user-data-dir={user_data_dir}',
        url
    ])

    time.sleep(1)  # beri delay supaya tidak tumpuk
