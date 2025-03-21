from rest_framework import generics
from .models import CustomUser, MeditationSession, FavoriteSession
from .serializers import CustomUserSerializer, MeditationSessionSerializer, FavoriteSessionSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny
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

# List Meditation Sessions
class SessionListView(generics.ListAPIView):
    """Fetch meditation sessions (including anonymous ones)"""
    serializer_class = MeditationSessionSerializer
    permission_classes = [AllowAny]  # Allow everyone to access

    def get_queryset(self):
        """If user is authenticated, return their sessions. Otherwise, return only anonymous sessions."""
        if self.request.user.is_authenticated:
            return MeditationSession.objects.filter(user=self.request.user)
        else:
            return MeditationSession.objects.filter(user=None)

# List & Create Favorite Sessions
class FavoriteSessionListCreateView(generics.ListCreateAPIView):
    serializer_class = FavoriteSessionSerializer

    def get_queryset(self):
        return FavoriteSession.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
