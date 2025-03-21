from rest_framework import generics
from .models import CustomUser, MeditationSession, FavoriteSession
from .serializers import CustomUserSerializer, MeditationSessionSerializer, FavoriteSessionSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
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
    queryset = MeditationSession.objects.all()
    serializer_class = MeditationSessionSerializer
    permission_classes = [AllowAny] 
    
class SessionListByUserIdView(generics.ListAPIView):
    """
    Fetch all meditation sessions for a specific user by user ID.
    Only accessible to authenticated users (you can restrict further if needed).
    """
    serializer_class = MeditationSessionSerializer
    permission_classes = [IsAuthenticated]  # You can change this to IsAdminUser if needed

    def get_queryset(self):
        user_id = self.kwargs["user_id"]
        user = get_object_or_404(CustomUser, id=user_id)
        return MeditationSession.objects.filter(user=user)

# List & Create Favorite Sessions
class FavoriteSessionListCreateView(generics.ListCreateAPIView):
    serializer_class = FavoriteSessionSerializer

    def get_queryset(self):
        return FavoriteSession.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
