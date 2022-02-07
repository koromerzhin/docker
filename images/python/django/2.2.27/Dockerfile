FROM python:3.9.0 as build-django-2.2.27

WORKDIR /app

RUN python -m venv apps-env

RUN source ~/envs/apps-env/bin/activate

RUN python -m pip install --upgrade pip

RUN pip install Django==2.2.27

CMD python manage.py runserver 0.0.0.0:8080
