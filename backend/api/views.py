from rest_framework import generics
from .models import CustomUser, MeditationSession, FavoriteSession
from .serializers import CustomUserSerializer, MeditationSessionSerializer, FavoriteSessionSerializer
## FOR NOT REAL-TIME ENDPOINTS

# Create a new user
class UserCreateView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

# Retrieve user information by ID
class UserDetailView(generics.RetrieveAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    lookup_field = "id"  # Allows fetching user by ID

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
