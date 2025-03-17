from django.db import models

# Custom User Model
class CustomUser(models.Model):
    username = models.CharField(max_length=150, unique=True)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    gender = models.CharField(max_length=10, choices=[("male", "Male"), ("female", "Female"), ("other", "Other")])
    birthday = models.DateField()
    
    USERNAME_FIELD = "username"
    REQUIRED_FIELDS = ["first_name", "last_name", "gender", "birthday"]

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

# Meditation Session Model
class MeditationSession(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.title} - {self.user.username}"

# Favorite Session Model
class FavoriteSession(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    session = models.ForeignKey(MeditationSession, on_delete=models.CASCADE)
    saved_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.session.title} (Favorite)"
