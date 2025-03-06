
import openai
import asyncio
from channels.generic.websocket import AsyncWebsocketConsumer

## FOR TESTING 

#OPENAI_API_KEY = ""
import openai
import asyncio
from channels.generic.websocket import AsyncWebsocketConsumer

class MeditationConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()
        print("🔗 WebSocket connection established.")

    async def receive(self, text_data):
        print(f"📩 Received request: {text_data}")
        try:
            await self.stream_gpt_voice(text_data)
        except Exception as e:
            print(f"❌ Error: {e}")
            await self.send(text_data=f"Error: {e}")

    async def stream_gpt_voice(self, prompt):
        """Streams AI-generated speech from GPT-4 Turbo in real-time"""
        try:
            client = openai.OpenAI(api_key=OPENAI_API_KEY)

            response = client.chat.completions.create(
                model="gpt-4-turbo",
                messages=[{"role": "system", "content": "You are a mindfulness meditation guide."},
                          {"role": "user", "content": prompt}],
                stream=True  # ✅ GPT-4 Turbo supports real-time streaming
            )

            print("🎙 Streaming GPT-4 Turbo voice response...")

            for chunk in response:
                if chunk and "content" in chunk.choices[0].delta:
                    text_chunk = chunk.choices[0].delta["content"]
                    print(f"🗣️ GPT-4 says: {text_chunk}")  # Log text in real-time

                    # Convert text to speech dynamically
                    tts_response = client.audio.speech.create(
                        model="tts-1",
                        voice="alloy",
                        input=text_chunk
                    )

                    await self.send(bytes_data=tts_response.content)  # ✅ Stream speech to Flutter

            print("✅ GPT-4 Turbo streaming complete.")
        except Exception as e:
            print(f"❌ GPT-4 Turbo API Error: {e}")
            await self.send(text_data=f"Error: {e}")

    async def disconnect(self, close_code):
        print(f"🔌 WebSocket disconnected with code: {close_code}")

