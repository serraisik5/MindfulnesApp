import json
import asyncio
import logging
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth import get_user_model
from channels.db import database_sync_to_async
from .models import MeditationSession
from .utils import generate_meditation_ws
from rest_framework_simplejwt.tokens import AccessToken
from django.contrib.auth.models import AnonymousUser

logger = logging.getLogger(__name__)
CustomUser = get_user_model()

class MeditationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        """Authenticate JWT if provided, or allow anonymous access."""
        logger.info("🔌 WebSocket connection attempt")

        self.user = await self.get_user_from_token()
        self.full_transcript = ""
        self.title = None
        self.duration = None

        await self.accept()
        if isinstance(self.user, AnonymousUser):
            logger.info("WebSocket accepted for Anonymous user")
        else:
            logger.info(f"WebSocket accepted for user: {self.user.username}")

    async def get_user_from_token(self):
        headers = dict(self.scope.get("headers", []))
        auth_header = headers.get(b"authorization", None)

        if auth_header:
            try:
                # Header format: b'authorization': b'Bearer <token>'
                token_str = auth_header.decode().split(" ")[1]
                validated_token = AccessToken(token_str)
                user_id = validated_token["user_id"]
                user = await database_sync_to_async(CustomUser.objects.get)(id=user_id)
                return user
            except Exception as e:
                logger.error(f"Token authentication failed: {e}")
        return AnonymousUser()

    async def receive(self, text_data):
        """Receive meditation request, validate input, and start streaming."""
        logger.info(f"📩 WebSocket request received: {text_data}")
        if not text_data:
            logger.error("Received empty WebSocket message")
            return

        try:
            data = json.loads(text_data)
            self.title = data.get("title", "Relaxation")
            self.duration = int(data.get("duration", 1))
            self.background_noise = data.get("background_noise", "rainy").lower()
            self.voice = data.get("voice", "sage").lower()

            if self.background_noise not in ["rainy", "piano", "fire"]:
                raise ValueError("Invalid background_noise option")
            if self.duration <= 0:
                raise ValueError("Duration must be greater than 0")

            logger.info(f"🔹 Title: {self.title}, Duration: {self.duration}, Noise: {self.background_noise}, Voice: {self.voice}")

            asyncio.create_task(generate_meditation_ws(self.title, self.duration, self.voice, self))

        except (json.JSONDecodeError, ValueError) as e:
            logger.error(f"Invalid request: {e}")
            await self.send(json.dumps({"error": str(e)}))

    async def send_text(self, text):
        """Receive and store transcript updates from OpenAI."""
        self.full_transcript += f" {text}"  # Append transcript
        await self.send(json.dumps({"type": "text", "content": text}))

    async def disconnect(self, close_code):
        """Save the meditation session when WebSocket disconnects."""
        logger.info(f"🔌 WebSocket disconnected with code: {close_code}")
        transcript_length = len(self.full_transcript.strip())
        logger.info(f"📝 Final transcript length: {transcript_length}")
        