FROM python:3.9.0 as build-django-4.0.2

WORKDIR /app

RUN python -m venv /opt/env

RUN ./opt/envs/apps-env/bin/activate

RUN python -m pip install --upgrade pip

RUN pip install Django==4.0.2

CMD python manage.py runserver 0.0.0.0:8080
