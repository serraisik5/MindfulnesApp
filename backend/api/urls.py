from django.urls import path
from .views import UserCreateView, UserDetailView, SessionListView

urlpatterns = [
    path("user/create/", UserCreateView.as_view(), name="user-create"),
    path("user/<int:id>/", UserDetailView.as_view(), name="user-detail"),
    path("sessions/", SessionListView.as_view(), name="session-list"),
]
