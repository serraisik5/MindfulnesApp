import json
from channels.generic.websocket import AsyncWebsocketConsumer
from .utils import generate_meditation_ws
import asyncio

class MeditationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        """Accept WebSocket connection if user is authenticated"""
        self.user = self.scope["user"]
        if self.user.is_authenticated:
            await self.accept()
        else:
            await self.close()

    async def receive(self, text_data):
        """Receive request from Flutter & start meditation session"""
        data = json.loads(text_data)
        title = data.get("title", "Relaxation")
        duration = data.get("duration", 5)

        # Start GPT-4o WebSocket request in background
        asyncio.create_task(generate_meditation_ws(title, duration, self))

    async def disconnect(self, close_code):
        """Handle WebSocket disconnection"""
        pass