import json
import openai
import os
import asyncio
import websockets
import base64

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_REALTIME_WS_URL = "wss://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview-2024-12-17"

async def generate_meditation_ws(title, duration, user_channel):
    """Connects to OpenAI WebSocket and streams meditation session to user WebSocket."""
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "realtime=v1"
    }

    async with websockets.connect(OPENAI_REALTIME_WS_URL, extra_headers=headers) as ws:
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

        # Step 3: Request OpenAI to respond
        response_event = {
            "type": "response.create",
            "response": {
                "modalities": ["text", "audio"]
            }
        }
        await ws.send(json.dumps(response_event))

        # Step 4: Stream response from OpenAI to the user via WebSocket
        async for message in ws:
            data = json.loads(message)

            # Send text response
            if data.get("type") in ["response.audio_transcript.done", "response.content_part.done"]:
                transcript = data.get("transcript") or data.get("part", {}).get("transcript")
                if transcript:
                    await user_channel.send(json.dumps({"type": "text", "content": transcript}))

            # Send audio response as base64
            if data.get("type") == "response.audio.delta":
                if "delta" in data:
                    audio_chunk = base64.b64encode(base64.b64decode(data["delta"])).decode("utf-8")
                    await user_channel.send(json.dumps({"type": "audio", "content": audio_chunk}))

        # Final step: Close connection
        await user_channel.send(json.dumps({"type": "done"}))
