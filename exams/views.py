from django.contrib.auth.decorators import login_required
from django.shortcuts import render

from .models import Result


@login_required
def my_results(request):
    student_profile = getattr(request.user, "student_profile", None)
    results = []
    if student_profile:
        results = Result.objects.select_related("exam").filter(student=student_profile)
    return render(request, "exams/my_results.html", {"results": results, "student": student_profile})
