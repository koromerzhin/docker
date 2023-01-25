FROM python:3.11.1 as build-django-4.0.2

WORKDIR /app

ENV VIRTUAL_ENV=/opt/venv

RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m pip install --upgrade pip

RUN pip install Django==4.0.2

CMD python manage.py runserver 0.0.0.0:8080
