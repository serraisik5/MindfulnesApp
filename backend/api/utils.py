import json
import openai
import os
import asyncio
import websockets
import base64
import logging
from dotenv import load_dotenv
from websockets.client import connect  
from websockets.exceptions import ConnectionClosedError
from websockets.client import connect  
from websockets.exceptions import ConnectionClosedError


# Load environment variables from .env file
load_dotenv()

logger = logging.getLogger(__name__)  # Set up logging

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_REALTIME_WS_URL = "wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-12-17"

# 🔹 Log the API key (only first 5 characters for security)
if OPENAI_API_KEY:
    logger.info(f"Using OpenAI API Key: {OPENAI_API_KEY[:5]}... (masked)")
else:
    logger.error("❌ OPENAI_API_KEY is missing or not set!")

async def generate_meditation_ws(title, duration, user_channel):
    """Connects to OpenAI WebSocket and streams meditation session to user WebSocket."""
    
    print("selen123")
    
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "realtime=v1"
    }
    transcript_collected = ""
    
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
                    "voice": "alloy",
                    "output_audio_format": "pcm16",
                    "instructions": "Generate a calm, guided meditation session in a soft, soothing tone."
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
                data = json.loads(message)
                logger.debug(f"📩 Received WebSocket Message: {data}")

                # Send text response
                if data.get("type") in ["response.audio_transcript.done", "response.content_part.done"]:
                    transcript = data.get("transcript") or data.get("part", {}).get("transcript")
                    if transcript:
                        transcript_collected += f" {transcript}"  # Append text to full transcript
                        await user_channel.send_text(transcript) 
                        logger.info(f"📝 Sent transcript update: {transcript[:50]}...")

                # Send audio response as base64
                if data.get("type") == "response.audio.delta":
                    if "delta" in data:
                        audio_chunk = base64.b64decode(data["delta"])
                        await user_channel.send(bytes_data=audio_chunk)
                        logger.info("🎵 Sent audio chunk")
                 # 🔹 Detect when OpenAI streaming is done
                if data.get("type") == "response.done":
                    logger.info("✅ Meditation session complete. Closing WebSocket.")
                    break  # Exit the loop when streaming ends

            await user_channel.close()
            logger.info("🔌 WebSocket closed manually after streaming ended.")

    except websockets.exceptions.ConnectionClosedError as e:
        logger.error(f"❌ WebSocket Connection Error: {e}")

    except Exception as e:
        logger.error(f"❌ Unexpected Error: {e}")
