from django.db import models
from django.contrib.auth.models import AbstractUser

# Custom User Model

class CustomUser(AbstractUser):
    gender_choices = [("male", "Male"), ("female", "Female"), ("other", "Other")]
    
    gender = models.CharField(max_length=10, choices=gender_choices)
    birthday = models.DateField()

    # Add unique related_name to avoid clashes
    groups = models.ManyToManyField(
        "auth.Group",
        related_name="customuser_groups",  # Avoids conflict with default User model
        blank=True
    )
    user_permissions = models.ManyToManyField(
        "auth.Permission",
        related_name="customuser_permissions",  # Avoids conflict
        blank=True
    )

    REQUIRED_FIELDS = ["first_name", "last_name", "gender", "birthday"]

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

# Meditation Session Model
class MeditationSession(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, null=True, blank=True)  # Allow anonymous users
    title = models.CharField(max_length=255)
    text = models.TextField(blank=True, null=True)
    duration = models.IntegerField(default=3)  # Set a default duration (e.g., 5 minutes)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.title} ({self.user.username if self.user else 'Anonymous'})"

# Favorite Session Model
class FavoriteSession(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    session = models.ForeignKey(MeditationSession, on_delete=models.CASCADE)
    saved_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.session.title} (Favorite)"
