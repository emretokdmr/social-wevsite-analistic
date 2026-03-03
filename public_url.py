"""
pyngrok ile public URL - ngrok binary gerekmez.
Kullanim: python public_url.py
"""
import subprocess, sys, time, threading

def install_if_missing(pkg):
    try:
        __import__(pkg)
    except ImportError:
        print(f"[~] {pkg} kuruluyor...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", pkg, "--quiet"])

install_if_missing("pyngrok")
install_if_missing("streamlit")

from pyngrok import ngrok, conf

# ── Streamlit'i arka planda başlat ──────────────────────────────────────────
def run_streamlit():
    subprocess.Popen(
        [sys.executable, "-m", "streamlit", "run", "app.py",
         "--server.address=0.0.0.0",
         "--server.port=8501",
         "--server.headless=true"],
    )

print("\n┌─────────────────────────────────────────────┐")
print("│   Social Growth Dashboard - Public URL      │")
print("└─────────────────────────────────────────────┘\n")

print("[1/3] Streamlit başlatılıyor...")
t = threading.Thread(target=run_streamlit, daemon=True)
t.start()
time.sleep(4)  # Streamlit'in ayağa kalkmasını bekle

print("[2/3] ngrok tunnel açılıyor...")

# Auth token varsa buraya gir (isteğe bağlı - anonim de çalışır ama 2h limit)
# ngrok.set_auth_token("SENIN_TOKEN_BURAYA")

try:
    tunnel = ngrok.connect(8501, "http")
    public_url = tunnel.public_url

    print("\n" + "─"*50)
    print(f"  ✓ PUBLIC URL:  {public_url}")
    print(f"  ✓ LOCAL URL:   http://localhost:8501")
    print("─"*50)
    print("\n  Bu URL'yi herkesle paylaşabilirsin.")
    print("  ngrok ücretsiz → 2 saat / 40 bağlantı limiti var.")
    print("  Daha uzun süre için: https://ngrok.com/pricing")
    print("\n  Durdurmak için: CTRL + C\n")

    # Canlı tut
    ngrok_process = ngrok.get_ngrok_process()
    try:
        ngrok_process.proc.wait()
    except KeyboardInterrupt:
        print("\n[i] Kapatılıyor...")
        ngrok.kill()

except Exception as e:
    print(f"\n[HATA] ngrok başlatılamadı: {e}")
    print("Çözüm: https://dashboard.ngrok.com/get-started/your-authtoken")
    print("Token aldıktan sonra:")
    print('  from pyngrok import ngrok')
    print('  ngrok.set_auth_token("TOKEN_BURAYA")')
    input("\nDevam etmek için Enter...")
