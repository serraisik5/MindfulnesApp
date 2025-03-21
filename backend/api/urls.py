from django.urls import path
from .views import UserCreateView, UserDetailView, SessionListView, SessionListByUserIdView

urlpatterns = [
    path("user/create/", UserCreateView.as_view(), name="user-create"),
    path("user/<int:id>/", UserDetailView.as_view(), name="user-detail"),
    path("sessions/", SessionListView.as_view(), name="session-list"),
    path("sessions/user/<int:user_id>/", SessionListByUserIdView.as_view(), name="sessions-by-user"),
]
