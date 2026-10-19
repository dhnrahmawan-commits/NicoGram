from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from telethon import TelegramClient
from telethon.errors import SessionPasswordNeededError
import os

app = FastAPI()

api_id = 22162857
api_hash = 'e735f9e5b843d626e18195a843c5e625' # Masukkan api_hash lengkap Anda dari my.telegram.org

# Model data untuk menerima request dari aplikasi Flutter
class PhoneRequest(BaseModel):
    phone: str

class OtpRequest(BaseModel):
    phone: str
    code: str
    phone_code_hash: str

# Sesi disimpan berdasarkan nomor telepon
def get_client(phone: str):
    session_name = f"session_{phone.replace('+', '')}"
    return TelegramClient(session_name, api_id, api_hash)

@app.post("/api/send_code")
async def send_code(data: PhoneRequest):
    client = get_client(data.phone)
    await client.connect()
    try:
        result = await client.send_code_request(data.phone)
        await client.disconnect()
        return {
            "status": "success",
            "phone_code_hash": result.phone_code_hash,
            "message": "Kode OTP berhasil dikirim ke Telegram Anda!"
        }
    except Exception as e:
        await client.disconnect()
        raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/sign_in")
async def sign_in(data: OtpRequest):
    client = get_client(data.phone)
    await client.connect()
    try:
        await client.sign_in(phone=data.phone, code=data.code, phone_code_hash=data.phone_code_hash)
        await client.disconnect()
        return {"status": "success", "message": "Berhasil login ke Telegram!"}
    except Exception as e:
        await client.disconnect()
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
