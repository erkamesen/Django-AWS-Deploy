# Django-AWS-Deploy

<p align="center">
<img src="https://user-images.githubusercontent.com/25181517/183896132-54262f2e-6d98-41e3-8888-e40ab5a17326.png" width="150px">
<img src="https://user-images.githubusercontent.com/25181517/183345125-9a7cd2e6-6ad6-436f-8490-44c903bef84c.png" width="150px">
<img src="https://github.com/marwin1991/profile-technology-icons/assets/62091613/9bf5650b-e534-4eae-8a26-8379d076f3b4" width="150px">
</p>

## Content:

1. [Creating an EC2 Instance](https://github.com/erkamesen/Django-AWS-Deploy/new/main?readme=1#creating-an-ec2-instance)
2. [Console Section](https://github.com/erkamesen/Django-AWS-Deploy/new/main?readme=1#console-section)
3. [Project Setup](https://github.com/erkamesen/Django-AWS-Deploy/new/main?readme=1#project-setup)
4. [Nginx Config](https://github.com/erkamesen/Django-AWS-Deploy/new/main?readme=1#nginx-config)
5. [Gunicorn & Supervisor](https://github.com/erkamesen/Django-AWS-Deploy/new/main?readme=1#gunicorn--supervisor)
6. [Run Server](https://github.com/erkamesen/Django-AWS-Deploy/new/main?readme=1#run-server)
# Creating an EC2 Instance
- *Open AWS and search to EC2*

![1](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/73e906e9-9502-43e4-9c65-581c2129a168)

- *Click "Launch Instances"*
- *Name the server*
- *Select Ubuntu's Free Tier from the Application and OS Images (Amazon Machine Image) section*
- *You can choose a free tier Instance Type*
- *Key Pair can be "proceed without a key pair" for now*
- *Allow HTTP and HTTPS traffic in Security Group section*
- *Click Launch Instance*
  
![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/97b3bae3-014a-4b9e-b0b5-a9e4c4ba8453)

- *Click "View all instances"*
- *Wait until the status check turns green, which may take 5 to 10 minutes depending on the situation. You can check it by pressing the refresh button at the top.*
- *Choose your instance and click "Connect"*

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/ba1b1d2a-be8d-41d6-a867-b1c7c011bb9b)

- *Save your Public IP*
- *The name may remain ubuntu*
- *Connect*

**If you have done everything successfully, there should be a console for our computer that we can control remotely.**

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/16e50fef-352b-4f86-91eb-11ad565487a7)

# Console Section

## Infos 
*If the console changes and a different screen appears, you can press enter and move on.*

- *You can use the Clear command to clear the console.*
```
clear
```

- *Use ls for list all files and directory in your current directory*
```
ls
```

## Install and Update 

- *Update & Upgrade System*

```
sudo apt-get update
```

```
sudo apt-get upgrade
```


- *Install virtual enviorement*
```
sudo apt-get install python3-venv
```

- *Change directory to project*

```
cd /home/ubuntu/
```

- *Create Virtual Enviorement*

```
python3 -m venv venv
```

- *Activate*

```
source venv/bin/activate
```

- *Clone the repository*

```
git clone https://github.com/erkamesen/django_project.git
```


- *Install Dependencies*
```
pip3 install -r ./<your_project_folder>/requirements.txt
```
*or briefly for a simple django application we will make now:*
```
pip3 install django
```

- *Change Directory*

```
cd <project_folder>/
```
*For this repository:
```
cd django_project/
```

```
pwd
# /home/ubuntu/django_project
```

# Project Setup

- *Migrate*
```
python manage.py makemigrations
python manage.py migrate
```
- *Collect Statics*
```
python manage.py collectstatic
```

- *Edit settings.py*

```
sudo nano django_project/settings.py
```

- *We add our public IP and Domain name(Optional) to the ALLOWED_HOSTS list.*
- *Change DEBUG to False*
- *You can press CTRL-X and then Y to exit nano editor with save it.*

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/808ec91a-f8d3-4440-9b4b-e25d68166280)

# Nginx Config

- *Install*

```
sudo apt-get install -y nginx
```
*After nginx is installed, you can go to the public IP address from your browser and test it.*

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/a511ea88-f7fd-4ea5-bef3-a2a9456b3195)

- *change user to root*
```
sudo nano /etc/nginx/nginx.conf
```
*The value of root in the first line will be root, not www-data*

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/5653034d-bace-4ccf-99cd-e092a2171e87)

*CTRL-X -> Y to save it*

- *Create django.conf for nginx*

```
sudo nano /etc/nginx/sites-avilable/django.conf
```
*Fill out the template below with your own values and save it*
```
server {

	listen 80;

	server_name <domain> ;

	location / {
		include proxy_params;
		proxy_pass http://unix:/home/ubuntu/<project_folder_name>/app.sock;
	}

	# STATIC FILES 
	location /static/ {
    		alias /home/ubuntu/<project_folder_name>/static;
	}

}


```


![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/eaa6cca5-9d43-44c4-9e1a-1f2f4f1c5d7e)

- *Link to /sites-enabled*
```
sudo ln /etc/nginx/sites-available/django.conf /etc/nginx/sites-enabled/
```

- *Check nginx status*
```
sudo nginx -t
# nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
# nginx: configuration file /etc/nginx/nginx.conf test is successful
```

- *Restart server*
```
sudo service nginx restart
```

# Gunicorn & Supervisor

- *Install Gunicorn*

```
pip3 install gunicorn
```

- *Install Supervisor*

```
sudo apt-get install supervisor
```

- *Create gunicorn.conf*

```
sudo nano /etc/supervisor/conf.d/gunicorn.conf
```

*Use this template*
```
[program:gunicorn]
directory=/home/ubuntu/<appname>
command=/home/ubuntu/env/bin/gunicorn --workers 3 --bind unix:/home/ubuntu/<appname>/app.sock <appname>.wsgi:application  
autostart=true
autorestart=true

stderr_logfile=/var/log/gunicorn/gunicorn.err.log
stdout_logfile=/var/log/gunicorn/gunicorn.out.log

[group:guni]
programs:gunicorn
```

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/166d937f-d554-47c8-8fdb-f7116658198e)

- *Create log directory*
```
sudo mkdir /var/log/gunicorn/
```


# Run server

- *Connect Supervisor*
```
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl enable
sudo supervisorctl status
```

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/e5b93976-7f76-4e99-9f72-f9f7f8b17e8a)

- *Check app.sock*

```
cd /home/ubuntu/django_project/
```
```
ls
```

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/2efbfbad-7c30-4216-9c7a-b3f1f5195c71)

```
sudo service nginx restart
```

![resim](https://github.com/erkamesen/Django-AWS-Deploy/assets/120065120/8a247988-67ef-417a-aa33-5eea2f9f0a49)






