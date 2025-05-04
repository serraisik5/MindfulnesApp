import json
import openai
import os
import asyncio
import websockets
from websockets.client import connect
import base64
import logging
from dotenv import load_dotenv
from io import BytesIO
from django.core.files.base import ContentFile
from asgiref.sync import sync_to_async
from .models import MeditationSession

# Load environment variables from .env file
load_dotenv()

logger = logging.getLogger(__name__)  # Set up logging

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_REALTIME_WS_URL = "wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-12-17"

# Log the API key 
if OPENAI_API_KEY:
    logger.info(f"Using OpenAI API Key: {OPENAI_API_KEY[:5]}... (masked)")
else:
    logger.error("OPENAI_API_KEY is missing or not set!")

async def generate_meditation_ws(title, duration, voice, user_channel):
    """Connects to OpenAI WebSocket and streams meditation session to user WebSocket."""
    logger.info(f"Selected voice: {voice}")
    
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "realtime=v1"
    }
    transcript_collected = ""
    # temporary in-memory storage for favourite session save
    user_channel.audio_buffer = BytesIO()
    user_channel.transcript_collected = ""
    
    # 🔹 Log headers to ensure key is being sent correctly
    logger.info(f"WebSocket Headers: {headers}")

    try:
        async with connect(OPENAI_REALTIME_WS_URL, extra_headers=headers) as ws:
            logger.info("✅ Successfully connected to OpenAI WebSocket")
            
            # Step 1: Start the session
            session_event = {
                "type": "session.update",
                "session": {
                    "modalities": ["audio", "text"],
                    "voice": voice,
                    "output_audio_format": "pcm16",
                    "instructions": "Generate a calm, guided meditation session in a soft, soothing tone, but dont be too slow."
                }
            }
            await ws.send(json.dumps(session_event))
            logger.info("🔹 Sent session update request")
            
            # Step 2: Send the user’s request
            message_event = {
                "type": "conversation.item.create",
                "item": {
                    "type": "message",
                    "role": "user",
                    "content": [
                        {
                            "type": "input_text",
                            "text": f"Create a {duration}-minute meditation session on {title}."
                        }
                    ]
                }
            }
            await ws.send(json.dumps(message_event))
            logger.info(f"🔹 Sent user request: {title}, {duration} min")

            # Step 3: Request OpenAI to respond
            response_event = {
                "type": "response.create",
                "response": {
                    "modalities": ["text", "audio"]
                }
            }
            await ws.send(json.dumps(response_event))
            logger.info("🔹 Sent response request to OpenAI")

            # Step 4: Stream response from OpenAI to the user via WebSocket
            async for message in ws:
                logger.debug(f"📩 Raw message: {message}") 
                data = json.loads(message)
                #logger.debug(f"📩 Received WebSocket Message: {data}")

                # Send text response
                if data.get("type") in ["response.audio_transcript.done", "response.content_part.done"]:
                    transcript = data.get("transcript") or data.get("part", {}).get("transcript")
                    if transcript:
                        transcript_collected += f" {transcript}"  # Append text to full transcript
                        user_channel.transcript_collected = transcript_collected
                        await user_channel.send_text(transcript) 

                # Send audio response as base64
                if data.get("type") == "response.audio.delta":
                    if "delta" in data:
                        audio_chunk = base64.b64decode(data["delta"])
                        user_channel.audio_buffer.write(audio_chunk) # Save to buffer
                        await user_channel.send(bytes_data=audio_chunk)
                        logger.info("🎵 Sent audio chunk")
                 # Detect when OpenAI streaming is done
                if data.get("type") == "response.done":
                    logger.info("✅ Meditation session complete. Closing WebSocket.")
                    break  # Exit the loop when streaming ends
                elif data.get("type", "").startswith("response."):
                    logger.info(f"Unhandled response type: {data['type']} → {data}")
            # Save audio to DB
            if hasattr(user_channel, "audio_buffer"):
                user_channel.audio_buffer.seek(0)
                session = await save_meditation_session_with_audio(
                    user=user_channel.user if not user_channel.user.is_anonymous else None,
                    title=title,
                    duration=duration,
                    text=user_channel.transcript_collected.strip(),
                    background_noise=user_channel.background_noise,
                    voice=voice,
                    audio_data=user_channel.audio_buffer.read()
                )

                # ✅ Send session metadata to client
                await user_channel.send(json.dumps({
                    "type": "session_complete",
                    "session": {
                        "id": session.id,
                        "user_id": session.user.id if session.user else None,
                        "title": session.title,
                        "duration": session.duration,
                        "voice": session.voice,
                        "background_noise": session.background_noise,
                        "text": session.text,
                        "audio_url": session.audio_file.url,
                    }
                }))
            await user_channel.close()
            logger.info("🔌 WebSocket closed manually after streaming ended.")

    except websockets.exceptions.ConnectionClosedError as e:
        logger.error(f"WebSocket Connection Error: {e}")

    except Exception as e:
        logger.error(f"Unexpected Error: {e}")

import wave

def wrap_pcm_to_wav(pcm_data, sample_rate=24000, channels=1, sample_width=2):
    buffer = BytesIO()
    with wave.open(buffer, 'wb') as wav_file:
        wav_file.setnchannels(channels)
        wav_file.setsampwidth(sample_width)  # 2 bytes for 16-bit audio
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(pcm_data)
    buffer.seek(0)
    return buffer

@sync_to_async
def save_meditation_session_with_audio(user, title, duration, text, background_noise, voice, audio_data):
    session = MeditationSession.objects.create(
        user=user,
        title=title,
        duration=duration,
        text=text,
        background_noise=background_noise,
        voice=voice
    )

    # Convert raw PCM to WAV
    wav_file = wrap_pcm_to_wav(audio_data)
    session.audio_file.save(f"{session.id}_audio.wav", ContentFile(wav_file.read()))
    session.save()
    return session

