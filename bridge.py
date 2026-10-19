from telethon import TelegramClient
import asyncio

api_id = 22162857
api_hash = 'e735f9e5b843d626e18195a843c5e625'

# Inisialisasi client Telethon
client = TelegramClient('nicogram_session', api_id, api_hash)

async main():
    # Mengambil daftar dialog/chat asli akun Anda
    async for dialog in client.iter_dialogs(limit=10):
        print(f"Chat: {dialog.name} | ID: {dialog.id}")

with client:
    client.loop.run_until_complete(main())
