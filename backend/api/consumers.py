import json
from channels.generic.websocket import AsyncWebsocketConsumer
from .utils import generate_meditation_ws
import asyncio
import base64

import logging

logger = logging.getLogger(__name__)  # Set up logging

class MeditationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        """Accept WebSocket connection and log details"""
        logger.info(f"WebSocket connection attempt: {self.scope}")

        try:
            await self.accept()
            logger.info("WebSocket connection accepted!")
        except Exception as e:
            logger.error(f"WebSocket connection error: {e}")
            await self.close()

    async def receive(self, text_data):
        """Receive meditation request and initiate streaming"""
        logger.info(f"WebSocket request received: {text_data}")

        # 🔹 Check if text_data is empty or None
        if not text_data:
            logger.error("Received empty WebSocket message")
            return

        try:
            data = json.loads(text_data)  # Attempt to parse JSON
            title = data.get("title", "Relaxation")
            duration = data.get("duration", 5)

            # Start OpenAI WebSocket request in background
            asyncio.create_task(generate_meditation_ws(title, duration, self))

        except json.JSONDecodeError as e:
            logger.error(f"JSONDecodeError: {e}")
            await self.send(json.dumps({"error": "Invalid JSON format"}))

    async def send_text(self, text):
        """Send text transcription updates"""
        await self.send(json.dumps({"type": "text", "content": text}))

    async def send_audio(self, audio_chunk_base64):
        """Send audio response in binary mode"""
        try:
            audio_bytes = base64.b64decode(audio_chunk_base64)
            await self.send(bytes_data=audio_bytes)  # Send raw audio bytes
        except Exception as e:
            logger.error(f"Error sending audio: {e}")

    async def disconnect(self, close_code):
        """Handle WebSocket disconnection"""
        logger.info(f"WebSocket disconnected with code: {close_code}")



    
   