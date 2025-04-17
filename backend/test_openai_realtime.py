import asyncio
import websockets
import websocket
import json
import base64
import os
import wave
import time
import openai
import threading
import simpleaudio as sa
from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_REALTIME_WS_URL = "wss://api.openai.com/v1/realtime"  # Example WebSocket URL

url = "wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-12-17"
headers = {
    "Authorization": f"Bearer {OPENAI_API_KEY}",
    "OpenAI-Beta": "realtime=v1"
}

# Store received data
audio_data = b""
text_response = ""
audio_received = False  # Track if audio has been received
text_received = False 
waiting_for_audio = False 
output_audio_format = "pcm6"

def send_response_request(ws):
    """Step 3: Ask OpenAI to generate a response"""
    response_event = {
        "type": "response.create",  # ✅ FIXED: Request OpenAI to respond
        "response": {
            "modalities": ["text", "audio"],
        }
    }
    ws.send(json.dumps(response_event))
    print("Requested assistant response.")

def on_open(ws):
    """Step 1 & 2: Set up session and send user message 'How are you?'"""
    print("Connected to OpenAI Realtime API.")

    session_event = {
        "type": "session.update",
        "session": {
            "modalities": ["audio", "text"],  # Request both text & audio
            "voice": "nova",  # Choose voice: alloy, echo, fable, onyx, nova, shimmer
            "output_audio_format": "pcm16", 
            "instructions": "You are a friendly AI assistant. Please provide both text and actual audio data for your responses."
        }
    }
    ws.send(json.dumps(session_event))
    print("Session settings sent.")

    message_event = {
        "type": "conversation.item.create",
        "item": {
            "type": "message",
            "role": "user",
            "content": [
                {
                    "type": "input_text",
                    "text": "Create short meditation session."
                }
            ]
        }
    }
    ws.send(json.dumps(message_event))
    send_response_request(ws)




def play_audio(audio_chunk):
    """Play PCM audio in real-time"""
    if not audio_chunk:
        return
    wave_obj = sa.WaveObject(audio_chunk, num_channels=1, bytes_per_sample=2, sample_rate=24000)
    play_obj = wave_obj.play()
    play_obj.wait_done()  # Ensure playback before continuing

def on_message(ws, message):
    """Receive and process streamed text & audio responses in real-time"""
    global audio_data, text_response
    print(f"\n📩 Raw message: {message}") 

    data = json.loads(message)

    if data.get("type") in ["response.audio_transcript.done", "response.content_part.done"]:
        transcript = data.get("transcript") or data.get("part", {}).get("transcript")
        if transcript:
            text_response += transcript
            print(f"\n📝 Assistant (partial): {transcript}")
    if data.get("type") == "response.audio.delta":
        if "delta" in data:
            audio_chunk = base64.b64decode(data["delta"])
            audio_data += audio_chunk  # Store full audio for later (optional)
            print(f"\n🔊 Received audio chunk (size: {len(audio_chunk)} bytes)...")

            # Play audio in real-time using a separate thread
            threading.Thread(target=play_audio, args=(audio_chunk,)).start()

    if data.get("type") == "response.done":
        print("✅ Full response received. Closing connection...")
        ws.close()

def on_close(ws, close_status_code, close_msg):
    """Handle WebSocket closure"""
    print("\n🔗 Connection closed.")

ws = websocket.WebSocketApp(
    url,
    header=headers,
    on_open=on_open,
    on_message=on_message,
    on_close=on_close
)

ws.run_forever()