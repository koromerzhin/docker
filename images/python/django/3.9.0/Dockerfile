FROM python:3.9.0 as build-django-3.9.0

WORKDIR /app

RUN python -m pip install --upgrade pip

RUN python -m pip install Django

CMD python manage.py runserver 0.0.0.0:8080
