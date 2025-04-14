from django.urls import path
from .views import UserCreateView, UserDetailView, SessionListView, SessionListByUserIdView, user_audio_sessions, session_audio_by_id, add_favorite, FavoriteSessionListView

urlpatterns = [
    path("user/create/", UserCreateView.as_view(), name="user-create"),
    path("user/<int:id>/", UserDetailView.as_view(), name="user-detail"),
    path("sessions/", SessionListView.as_view(), name="session-list"),
    path("sessions/user/<int:user_id>/", SessionListByUserIdView.as_view(), name="sessions-by-user"),
    path("sessions/audio/user/", user_audio_sessions, name="user-audio-sessions"),
    path("sessions/audio/<int:session_id>/", session_audio_by_id, name="session-audio-by-id"),
    path("sessions/favorite/add/", add_favorite, name="add-favorite"),
    path("sessions/favorites/", FavoriteSessionListView.as_view(), name="user-favorites"),
]
