from django.db import models
from django.contrib.auth.models import AbstractUser

# models.py

from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email must be set")
        email = self.normalize_email(email)
        extra_fields.setdefault("is_active", True)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if not extra_fields.get("is_staff"):
            raise ValueError("Superuser must have is_staff=True.")
        if not extra_fields.get("is_superuser"):
            raise ValueError("Superuser must have is_superuser=True.")

        return self.create_user(email, password, **extra_fields)

class CustomUser(AbstractUser):
    username = None
    email = models.EmailField(unique=True)
    gender_choices = [("male", "Male"), ("female", "Female"), ("other", "Other")]
    gender = models.CharField(max_length=10, choices=gender_choices, blank=True, null=True)
    birthday = models.DateField(blank=True, null=True)

    objects = CustomUserManager()  # ← link it here

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["first_name"]  # still required for createsuperuser

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


VOICE_CHOICES = [
    ("shimmer", "Shimmer"),
    ("echo", "Echo"),
    ("sage", "Sage"),
    ("alloy", "Alloy"),
    ("ash", "Ash"),
    ("ballad", "Ballad"),
    ("coral", "Coral"),
    ("verse", "Verse")
]

# Meditation Session Model
class MeditationSession(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, null=True, blank=True)  # Allow anonymous users
    title = models.CharField(max_length=255)
    text = models.TextField(blank=True, null=True)
    duration = models.IntegerField(default=1)  # Set a default duration (e.g., 1 minutes)
    background_noise = models.CharField(max_length=50, choices=[("rainy", "Rainy"), ("piano", "Piano"), ("fire", "Fire")], default="rainy")
    voice = models.CharField(max_length=20, choices=VOICE_CHOICES, default="sage")
    created_at = models.DateTimeField(auto_now_add=True)
    audio_file = models.FileField(upload_to='sessions/audio/', null=True, blank=True) # to save favourites

    def __str__(self):
        return f"{self.title} ({self.user.username if self.user else 'Anonymous'})"

# Favorite Session Model
class FavoriteSession(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    session = models.ForeignKey(MeditationSession, on_delete=models.CASCADE)
    saved_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'session')
    def __str__(self):
        return f"{self.user.username} - {self.session.title} (Favorite)"
