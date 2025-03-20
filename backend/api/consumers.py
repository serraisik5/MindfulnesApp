import json
import asyncio
import logging
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth import get_user_model
from channels.db import database_sync_to_async
from .models import MeditationSession
from .utils import generate_meditation_ws

logger = logging.getLogger(__name__)
CustomUser = get_user_model()

class MeditationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        """Accept WebSocket connection and initialize user session."""
        logger.info(f"WebSocket connection attempt: {self.scope}")

        self.user = self.scope["user"] if self.scope["user"].is_authenticated else None
        self.full_transcript = ""
        self.title = None
        self.duration = None

        try:
            await self.accept()
            logger.info(f"✅ WebSocket connection accepted! User: {self.user.username if self.user else 'Anonymous'}")
        except Exception as e:
            logger.error(f"❌ WebSocket connection error: {e}")
            await self.close()

    async def receive(self, text_data):
        """Receive meditation request, validate input, and start streaming."""
        logger.info(f"📩 WebSocket request received: {text_data}")

        if not text_data:
            logger.error("❌ Received empty WebSocket message")
            return

        try:
            data = json.loads(text_data)
            self.title = data.get("title", "Relaxation")
            self.duration = int(data.get("duration", 5))

            if self.duration <= 0:
                raise ValueError("Duration must be greater than 0")

            logger.info(f"🔹 Title: {self.title}, Duration: {self.duration}")

            asyncio.create_task(generate_meditation_ws(self.title, self.duration, self))

        except (json.JSONDecodeError, ValueError) as e:
            logger.error(f"❌ Invalid request: {e}")
            await self.send(json.dumps({"error": str(e)}))

    async def send_text(self, text):
        """Receive and store transcript updates from OpenAI."""
        logger.info(f"📝 Received transcript update: {text[:50]}...")  # Log received transcript
        self.full_transcript += f" {text}"  # Append transcript
        logger.info(f"📏 Updated transcript length: {len(self.full_transcript.strip())}")  # Log length
        await self.send(json.dumps({"type": "text", "content": text}))

    async def disconnect(self, close_code):
        """Save the meditation session when WebSocket disconnects."""
        logger.info(f"🔌 WebSocket disconnected with code: {close_code}")
        transcript_length = len(self.full_transcript.strip())
        logger.info(f"📝 Final transcript length: {transcript_length}")

        if transcript_length > 0:
            await save_meditation_session(
                self.user if self.user else None,
                self.title,
                self.duration,
                self.full_transcript.strip(),
            )
            logger.info(f"💾 Meditation session saved: {self.title} ({self.user.username if self.user else 'Anonymous'})")


@database_sync_to_async
def save_meditation_session(user, title, duration, text):
    """Save meditation session asynchronously in the database."""
    return MeditationSession.objects.create(user=user, title=title, duration=duration, text=text)
