from django.urls import re_path
from api.consumers import MeditationConsumer

websocket_urlpatterns = [
    re_path(r"ws/meditation/$", MeditationConsumer.as_asgi()),
]
