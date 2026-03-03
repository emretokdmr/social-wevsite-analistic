@echo off
title Social Growth - Public URL (ngrok)
color 0D

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║   PUBLIC URL OLUSTURULUYOR (ngrok)           ║
echo  ║   İnternet uzerinden erisim saglayacak       ║
echo  ╚══════════════════════════════════════════════╝
echo.

:: ngrok kurulu mu?
ngrok version >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] ngrok bulunamadi.
    echo.
    echo Kurulum icin:
    echo   1. https://ngrok.com/download adresinden indir
    echo   2. ZIP'i ac ve ngrok.exe'yi bu klasore koy
    echo   3. Hesap olustur: https://ngrok.com
    echo   4. Auth token al ve su komutu calistir:
    echo      ngrok config add-authtoken SENIN_TOKEN_BURAYA
    echo.
    echo Alternatif (pip ile):
    echo   pip install pyngrok
    echo   Sonra start_public_pyngrok.bat'i kullan
    echo.
    pause
    exit /b
)

:: Streamlit'i arka planda baslat
echo [1/2] Streamlit baslatiliyor (arka planda)...
start /b streamlit run app.py --server.address=0.0.0.0 --server.port=8501 --server.headless=true

timeout /t 3 /nobreak >nul

:: ngrok tunnel ac
echo [2/2] Public URL olusturuluyor...
echo.
echo  Asagida "Forwarding" satirindaki https://xxxx.ngrok-free.app adresini kullan
echo  Bu adresi herkesle paylasabilirsin (ngrok aktif oldugu surece)
echo.
echo  ─────────────────────────────────────────────
ngrok http 8501

pause
