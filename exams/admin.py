from django.contrib import admin
from .models import Exam, Result


@admin.register(Exam)
class ExamAdmin(admin.ModelAdmin):
    list_display = ("name", "date", "full_marks")


@admin.register(Result)
class ResultAdmin(admin.ModelAdmin):
    list_display = ("student", "exam", "marks_obtained")
    list_filter = ("exam",)
    search_fields = ("student__roll_number",)
