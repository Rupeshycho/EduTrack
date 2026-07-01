from django.contrib import admin
from .models import SchoolClass, Student


@admin.register(SchoolClass)
class SchoolClassAdmin(admin.ModelAdmin):
    list_display = ("name", "section")
    search_fields = ("name",)


@admin.register(Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ("roll_number", "user", "school_class", "guardian_phone")
    list_filter = ("school_class",)
    search_fields = ("roll_number", "user__username", "user__first_name", "user__last_name")
