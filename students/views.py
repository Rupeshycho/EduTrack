from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import Student


@login_required
def student_list(request):
    students = Student.objects.select_related("user", "school_class").all()
    return render(request, "students/student_list.html", {"students": students})
