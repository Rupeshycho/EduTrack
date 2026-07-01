from django.conf import settings
from django.db import models

from students.models import SchoolClass


class Teacher(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="teacher_profile"
    )
    subject = models.CharField(max_length=100)
    classes = models.ManyToManyField(SchoolClass, related_name="teachers", blank=True)
    phone = models.CharField(max_length=15, blank=True)

    def __str__(self):
        return f"{self.user.get_full_name() or self.user.username} ({self.subject})"
