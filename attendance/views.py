from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.shortcuts import redirect, render

from .forms import AttendanceForm
from .models import Attendance


@login_required
def mark_attendance(request):
    if request.method == "POST":
        form = AttendanceForm(request.POST)
        if form.is_valid():
            record, created = Attendance.objects.update_or_create(
                student=form.cleaned_data["student"],
                date=form.cleaned_data["date"],
                defaults={
                    "status": form.cleaned_data["status"],
                    "marked_by": getattr(request.user, "teacher_profile", None),
                },
            )
            messages.success(request, f"Attendance saved for {record.student}.")
            return redirect("attendance:mark_attendance")
    else:
        form = AttendanceForm()

    recent = Attendance.objects.select_related("student").order_by("-date")[:15]
    return render(request, "attendance/mark_attendance.html", {"form": form, "recent": recent})
