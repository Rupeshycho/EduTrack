from django.conf import settings
from django.db import models


class SchoolClass(models.Model):
    """A class/grade section, e.g. 'Grade 10 - A'."""

    name = models.CharField(max_length=50, unique=True)
    section = models.CharField(max_length=10, blank=True)

    class Meta:
        verbose_name_plural = "Classes"
        ordering = ["name"]

    def __str__(self):
        return f"{self.name} {self.section}".strip()


class Student(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="student_profile"
    )
    school_class = models.ForeignKey(
        SchoolClass, on_delete=models.SET_NULL, null=True, blank=True, related_name="students"
    )
    roll_number = models.CharField(max_length=20, unique=True)
    date_of_birth = models.DateField(null=True, blank=True)
    guardian_name = models.CharField(max_length=100, blank=True)
    guardian_phone = models.CharField(max_length=15, blank=True)
    photo = models.ImageField(upload_to="students/photos/", blank=True, null=True)

    class Meta:
        ordering = ["roll_number"]

    def __str__(self):
        return f"{self.roll_number} - {self.user.get_full_name() or self.user.username}"

    def attendance_percentage(self):
        records = self.attendance_records.all()
        total = records.count()
        if total == 0:
            return None
        present = records.filter(status="PRESENT").count()
        return round((present / total) * 100, 1)
