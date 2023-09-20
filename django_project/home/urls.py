from django.urls import path
from .views import index
from .views import form

urlpatterns = [
    path("", index, name="home"),
    path("form/", form, name="form"),
]
