from django.contrib import admin
from .models import Teacher


@admin.register(Teacher)
class TeacherAdmin(admin.ModelAdmin):
    list_display = ("user", "subject", "phone")
    search_fields = ("user__username", "subject")
    filter_horizontal = ("classes",)
