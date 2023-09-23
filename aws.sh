#!/bin/bash

# chmod +x aws.sh

sudo apt-get update 
sudo apt-get -y upgrade

sudo apt-get install python3-venv
python3 -m /home/ubuntu/venv venv

cd /home/ubuntu/

read -p "GitHub Repository URL: " github_url

read -p "Project Name :  project_name
git clone "$github_url"
cd "$project_name"
pip install -r requirements.txt
pip install gunicorn

python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput

sudo apt-get install nginx
sudo apt-get install supervisor
sudo mkdir /var/log/gunicorn/

sudo touch /etc/nginx/sites-available/django.conf
sudo ln /etc/nginx/sites-available/django.conf /etc/nginx/sites-enable/django.conf

sudo touch /etc/supervisor/conf.d/gunicorn.conf
