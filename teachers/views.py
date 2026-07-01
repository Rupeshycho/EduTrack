from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import Teacher


@login_required
def teacher_list(request):
    teachers = Teacher.objects.select_related("user").all()
    return render(request, "teachers/teacher_list.html", {"teachers": teachers})
