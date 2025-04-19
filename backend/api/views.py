from rest_framework import generics
from .models import CustomUser, MeditationSession, FavoriteSession
from .serializers import CustomUserSerializer, MeditationSessionSerializer, FavoriteSessionSerializer, CustomTokenObtainPairSerializer
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

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

# List all sessions with audio for the authenticated user
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def user_audio_sessions(request):
    sessions = MeditationSession.objects.filter(user=request.user).exclude(audio_file="").exclude(audio_file=None)
    result = [
        {
            "id": s.id,
            "title": s.title,
            "audio_url": request.build_absolute_uri(s.audio_file.url),
            "created_at": s.created_at,
        }
        for s in sessions
    ]
    return Response(result)

# Get audio URL for a specific session
@api_view(["GET"])
@permission_classes([AllowAny])  # You can restrict to authenticated if needed
def session_audio_by_id(request, session_id):
    session = get_object_or_404(MeditationSession, id=session_id)
    if session.audio_file:
        return Response({
            "id": session.id,
            "title": session.title,
            "audio_url": request.build_absolute_uri(session.audio_file.url),
            "created_at": session.created_at,
        })
    return Response({"error": "No audio found for this session."}, status=404)

# Add favorite for user
@api_view(["POST"])
@permission_classes([IsAuthenticated])
def add_favorite(request):
    session_id = request.data.get("session_id")
    if not session_id:
        return Response({"error": "session_id is required"}, status=400)

    try:
        session = MeditationSession.objects.get(id=session_id, user=request.user)
    except MeditationSession.DoesNotExist:
        return Response({"error": "Session not found"}, status=404)

    favorite, created = FavoriteSession.objects.get_or_create(user=request.user, session=session)
    return Response({"status": "favorited", "created": created})

# List her favourites
class FavoriteSessionListView(generics.ListAPIView):
    serializer_class = MeditationSessionSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return MeditationSession.objects.filter(favoritesession__user=self.request.user)


