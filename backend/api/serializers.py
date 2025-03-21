from rest_framework import serializers
from .models import CustomUser, MeditationSession, FavoriteSession

class CustomUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'first_name', 'last_name', 'password', 'gender', 'birthday']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = CustomUser(**validated_data)
        user.set_password(password)  # ✅ Hashes the password
        user.save()
        return user


# Meditation Session Serializer
class MeditationSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = MeditationSession
        fields = ["id", "user", "title", "text", "duration", "created_at"]

# Favorite Session Serializer
class FavoriteSessionSerializer(serializers.ModelSerializer):
    session = MeditationSessionSerializer(read_only=True)  # Include session details

    class Meta:
        model = FavoriteSession
        fields = ["id", "user", "session", "saved_at"]
