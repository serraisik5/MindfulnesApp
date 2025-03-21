import os
import django

# 🔹 Set environment variable for Django settings
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "backend.settings")

# 🔹 Initialize Django BEFORE importing any models or Django modules
django.setup()

import logging
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.auth import AuthMiddlewareStack
from django.core.asgi import get_asgi_application
from api.routing import websocket_urlpatterns  # Ensure this import is correct

# 🔹 Setup logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

logger.debug("Starting ASGI application...")

application = ProtocolTypeRouter({
    "http": get_asgi_application(),
    "websocket": AuthMiddlewareStack(
        URLRouter(websocket_urlpatterns)
    ),
})

logger.debug("ASGI application loaded successfully.")
