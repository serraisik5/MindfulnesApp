from django.urls import path, re_path
from channels.routing import ProtocolTypeRouter, URLRouter
from api.consumers import MeditationConsumer

websocket_urlpatterns = [
    path('ws/meditation/', MeditationConsumer.as_asgi()),
]