from django.shortcuts import render, redirect
from datetime import datetime
from .forms import UserForm

# Create your views here.



def index(request):
    date = datetime.today().strftime('%Y-%m-%d')
    content = {
        "date": date
    }
    return render(request, "home.html", content)



def form(request):
    form = UserForm(request.POST)
    content = {
        "form":form,
    }
    if request.method == "POST":
        if form.is_valid():
            form.save()
            return redirect("home")
    return render(request, "form.html", content)