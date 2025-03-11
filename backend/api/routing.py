from django.urls import path
from api.consumer import MeditationConsumer

websocket_urlpatterns = [
    path("ws/stream_audio/", MeditationConsumer.as_asgi()),  # WebSocket endpoint
]
