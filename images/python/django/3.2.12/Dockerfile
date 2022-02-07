FROM python:3.10.2 as build-django-3.2.12

WORKDIR /app

ENV VIRTUAL_ENV=/opt/venv

RUN python3 -m venv $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m pip install --upgrade pip

RUN pip install Django==3.2.12

CMD python manage.py runserver 0.0.0.0:8080
