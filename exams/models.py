from django.db import models

from students.models import Student


class Exam(models.Model):
    name = models.CharField(max_length=100)
    date = models.DateField()
    full_marks = models.PositiveIntegerField(default=100)

    class Meta:
        ordering = ["-date"]

    def __str__(self):
        return f"{self.name} ({self.date})"


class Result(models.Model):
    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name="results")
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name="results")
    marks_obtained = models.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        unique_together = ("exam", "student")
        ordering = ["-exam__date"]

    def __str__(self):
        return f"{self.student} - {self.exam} - {self.marks_obtained}"

    def percentage(self):
        if not self.exam.full_marks:
            return None
        return round((float(self.marks_obtained) / self.exam.full_marks) * 100, 1)
