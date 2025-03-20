from rest_framework import serializers
from .models import CustomUser, MeditationSession, FavoriteSession

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ["id", "username", "first_name", "last_name", "gender", "birthday"]


# Meditation Session Serializer
class MeditationSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = MeditationSession
        fields = ["id", "user", "title", "duration", "created_at"]

# Favorite Session Serializer
class FavoriteSessionSerializer(serializers.ModelSerializer):
    session = MeditationSessionSerializer(read_only=True)  # Include session details

    class Meta:
        model = FavoriteSession
        fields = ["id", "user", "session", "saved_at"]
