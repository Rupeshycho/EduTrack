from django.urls import path

from . import views

app_name = "exams"

urlpatterns = [
    path("my-results/", views.my_results, name="my_results"),
]
