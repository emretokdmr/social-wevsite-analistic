@echo off
title Social Growth Dashboard
color 0B

echo.
echo  ╔══════════════════════════════════════╗
echo  ║    Social Growth Dashboard           ║
echo  ║    Baslatiliyor...                   ║
echo  ╚══════════════════════════════════════╝
echo.

:: Python ve pip kontrol
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] Python bulunamadi. https://python.org adresinden yukle.
    pause
    exit /b
)

:: Gerekli paketleri kur (ilk sefer)
echo [1/2] Bagimliliklar kontrol ediliyor...
pip install streamlit pandas plotly --quiet

:: IP adresini bul
echo.
echo [2/2] Sunucu baslatiliyor...
echo.

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set LOCAL_IP=%%a
    goto :found
)
:found
set LOCAL_IP=%LOCAL_IP: =%

echo  ┌─────────────────────────────────────────┐
echo  │  LOCAL ERISIM:                          │
echo  │  http://localhost:8501                  │
echo  │                                         │
echo  │  AG ERISIMI (diger cihazlar):           │
echo  │  http://%LOCAL_IP%:8501          │
echo  └─────────────────────────────────────────┘
echo.
echo  Tarayici otomatik acilacak...
echo  Durdurmak icin: CTRL + C
echo.

:: Tarayiciyi 3 saniye sonra ac
start /b cmd /c "timeout /t 3 /nobreak >nul && start http://localhost:8501"

:: Streamlit'i baslat
streamlit run app.py --server.address=0.0.0.0 --server.port=8501 --server.headless=true

pause
