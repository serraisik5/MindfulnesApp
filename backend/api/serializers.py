from rest_framework import serializers
from .models import CustomUser, MeditationSession, FavoriteSession
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError

User = get_user_model()
class CustomUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "email", "password", "first_name", "last_name", "gender", "birthday"]

    def validate_email(self, value):
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("A user with this email already exists.")
        return value

    def create(self, validated_data):
        user = User.objects.create_user(
            email=validated_data["email"],
            password=validated_data["password"],
            first_name=validated_data.get("first_name", ""),
            last_name=validated_data.get("last_name", ""),
            gender=validated_data.get("gender"),
            birthday=validated_data.get("birthday"),
        )
        return user

class MeditationSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = MeditationSession
        fields = [
            "id",
            "user",
            "title",
            "text",
            "duration",
            "background_noise",
            "voice",
            "created_at",
            "audio_file"
        ]

# Favorite Session Serializer
class FavoriteSessionSerializer(serializers.ModelSerializer):
    session = MeditationSessionSerializer(read_only=True)  # Include session details

    class Meta:
        model = FavoriteSession
        fields = ["id", "user", "session", "saved_at"]



class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    username_field = "email"
