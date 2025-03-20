from django.urls import path
from .views import UserCreateView, UserDetailView

urlpatterns = [
    path("user/create/", UserCreateView.as_view(), name="user-create"),
    path("user/<int:id>/", UserDetailView.as_view(), name="user-detail"),
]
