FROM python:3.9.0 as build-django-4.0.2

WORKDIR /app

RUN python -m pip install --upgrade pip

RUN python -m pip install Django==4.0.2

CMD python manage.py runserver 0.0.0.0:8080
