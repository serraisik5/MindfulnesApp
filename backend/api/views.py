from rest_framework import generics
from .models import CustomUser, MeditationSession, FavoriteSession
from .serializers import UserSerializer, MeditationSessionSerializer, FavoriteSessionSerializer
## FOR NOT REAL-TIME ENDPOINTS

# User Profile API
class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user

# List & Create Meditation Sessions
class MeditationSessionListCreateView(generics.ListCreateAPIView):
    serializer_class = MeditationSessionSerializer

    def get_queryset(self):
        return MeditationSession.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

# List & Create Favorite Sessions
class FavoriteSessionListCreateView(generics.ListCreateAPIView):
    serializer_class = FavoriteSessionSerializer

    def get_queryset(self):
        return FavoriteSession.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
