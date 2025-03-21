from django.urls import path
from api.consumers import MeditationConsumer

websocket_urlpatterns = [
    path('ws/meditation/', MeditationConsumer.as_asgi()),
]
