from django.contrib import messages
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView
from django.shortcuts import redirect, render

from .forms import RegisterForm
from .models import CustomUser


def register(request):
    if request.method == "POST":
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            messages.success(request, f"Welcome, {user.first_name}! Your account has been created.")
            return redirect("users:dashboard")
        messages.error(request, "Please correct the errors below.")
    else:
        form = RegisterForm()
    return render(request, "users/register.html", {"form": form})


class EduTrackLoginView(LoginView):
    template_name = "users/login.html"


@login_required
def dashboard(request):
    user = request.user
    if user.is_admin_role or user.is_staff:
        return redirect("/admin/")
    if user.is_teacher_role:
        return redirect("attendance:mark_attendance")
    return redirect("exams:my_results")
